CC:= g++
AR:= ar
MAKE:= make

VERSION:= $(VERSION)-$(shell date +'%Y%m%d%H%M%S')
CFLAGS := -c -Wall -std=c++14 -g -O2 -DGITVERSION=$(VERSION) -MMD -MP

INCLUDES:= -I. -I/usr/local/include

LIB_SOURCE:= temp.cpp

ALL_SOURCES:= main.cpp $(LIB_SOURCES)

ALL_OBJECTS:= $(ALL_SOURCES:.cpp=.o)
ALL_OBJECTS:= $(ALL_OBJECTS:.cc=.o)
ALL_HEADER_DEPS:= $(ALL_OBJECTS:.o=.d)
LIB_OBJECTS:= $(LIB_SOURCES:.cpp=.o)
LIB_OBJECTS:= $(LIB_OBJECTS:.cc=.o)
ALL_GCDA := $(ALL_SOURCES:.cpp=.gcda)
ALL_GCDA := $(ALL_GCDA:.cc=.gcda)
ALL_GCNO := $(ALL_SOURCES:.cpp=.gcno)
ALL_GCNO := $(ALL_GCNO:.cc=.gcno)

EXECUTABLE= xapians

.PHONY: all test clean

all: $(ALL_SOURCES) $(STYLE) $(EXECUTABLE) $(EXECUTABLE_TOOLS)

$(EXECUTABLE): $(ALL_OBJECTS)
	$(CC) $(ALL_OBJECTS) -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) $< -o $@

%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) $< -o $@

-include $(ALL_HEADER_DEPS)

clean:
	\rm -rf  $(ALL_OBJECTS) $(ALL_HEADER_DEPS) $(ALL_GCDA) $(ALL_GCNO) $(EXECUTABLE) $(LIB)

$(LIB): $(LIB_OBJECTS)
	$(AR) -crs $(LIB) $^

test: $(LIB)
	$(MAKE) -C $(TEST_DIR) SKIP_SD_UT=$(SKIP_SD_UT)
