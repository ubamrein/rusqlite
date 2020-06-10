#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$_")" && pwd)

# omitting -DSQLITE_CORE -DSQLITE_ENABLE_STAT2
BUNDLED=" \
-DSQLITE_DEFAULT_FOREIGN_KEYS=1 \
-DSQLITE_ENABLE_DBSTAT_VTAB \
-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS \
-DSQLITE_ENABLE_FTS5 \
-DSQLITE_ENABLE_JSON1 \
-DSQLITE_ENABLE_LOAD_EXTENSION=1 \
-DSQLITE_ENABLE_RTREE \
-DSQLITE_ENABLE_STAT4 \
-DSQLITE_SOUNDEX \
-DSQLITE_USE_URI \
-DSQLITE_ENABLE_API_ARMOR \
-DSQLITE_ENABLE_COLUMN_METADATA \
-DSQLITE_ENABLE_MEMORY_MANAGEMENT \
-DSQLITE_THREADSAFE=1 \
"

MORE=" \
-DSQLITE_ENABLE_GEOPOLY \
-DSQLITE_ENABLE_STMTVTAB \
-DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1 \
-DSQLITE_LIKE_DOESNT_MATCH_BLOBS \
-DSQLITE_SECURE_DELETE \
-DSQLITE_TRUSTED_SCHEMA=0 \
"

SHELL=" \
-DSQLITE_OMIT_AUTOINIT \
-USQLITE_ENABLE_API_ARMOR \
-USQLITE_ENABLE_MEMORY_MANAGEMENT \
-DSQLITE_OMIT_PROGRESS_CALLBACK \
-DSQLITE_DEFAULT_LOCKING_MODE=1 \
-USQLITE_THREADSAFE \
-DSQLITE_THREADSAFE=0 \
-DSQLITE_DEFAULT_MEMSTATUS=0 \
-DSQLITE_OMIT_SHARED_CACHE \
-DSQLITE_OMIT_DECLTYPE \
-USQLITE_ENABLE_COLUMN_METADATA \
-DSQLITE_ENABLE_EXPLAIN_COMMENTS \
-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION \
"

SESSION=" \
-DSQLITE_ENABLE_PREUPDATE_HOOK \
-DSQLITE_ENABLE_SESSION \
"

SHARED_CACHE=" \
-DSQLITE_ENABLE_UNLOCK_NOTIFY \
-USQLITE_OMIT_SHARED_CACHE \
"

EXTRA_METADATA=" \
-USQLITE_OMIT_DECLTYPE \
-DSQLITE_ENABLE_COLUMN_METADATA \
"

RECOMMENDED=" \
-DSQLITE_INTROSPECTION_PRAGMAS \
-DSQLITE_ENABLE_DBPAGE_VTAB \
-DSQLITE_ENABLE_OFFSET_SQL_FUNC \
-DSQLITE_ENABLE_FTS4 \
"

case $1 in
    sqlcipher) CODEC="-DSQLITE_HAS_CODEC -lcrypto" ;;
    sqlite3) : ;;
    *) echo "usage: $0 <sqlite3|sqlcipher>" >&2; exit 1 ;;
esac

cd "$SCRIPT_DIR/$1"

"${CC:-clang}" -Os -I. -DHAVE_ISNAN -DHAVE_LOCALTIME_R -DHAVE_USLEEP=1 -DSQLITE_USE_ALLOCA \
-DSQLITE_MAX_VARIABLE_NUMBER=512 -DSQLITE_MAX_EXPR_DEPTH=0 \
-DSQLITE_OMIT_DEPRECATED -DSQLITE_DQS=0 \
$BUNDLED $MORE $SHELL $SESSION \
-DSQLITE_TEMP_STORE=2 $CODEC \
-DSQLITE_HAVE_ZLIB -DHAVE_EDITLINE \
-I/opt/local/include -L/opt/local/lib \
shell.c sqlite3.c \
-ldl -lz -lm -lpthread -ledit \
-o "$1"
