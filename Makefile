AVX2_INFO := $(shell grep avx2 /proc/cpuinfo 1>/dev/null 2>&1; echo $$?)
AVX2 =1

CC=g++

ifeq ($(AVX2_INFO),1)
$(warning "CPU does not support AVX2...")
#CFLAGS = -w -c -mavx2 -mpopcnt -fomit-frame-pointer -W -Wall -Winline -O3 -lz
CFLAGS = -w -c -msse4.2 -mpopcnt -fomit-frame-pointer -Winline -O3 -lz
LDFLAGS = -lm -lz -lpthread -O3 -mpopcnt -msse4.2 -lz -w
else ifeq ($(AVX2),0)
$(warning "CPU does not support AVX2...")
#CFLAGS = -w -c -mavx2 -mpopcnt -fomit-frame-pointer -W -Wall -Winline -O3 -lz
CFLAGS = -w -c -msse4.2 -mpopcnt -fomit-frame-pointer -Winline -O3 -lz
LDFLAGS = -lm -lz -lpthread -O3 -mpopcnt -msse4.2 -lz -w
else
$(warning "CPU can support AVX2...")
#CFLAGS = -w -c -mavx2 -mpopcnt -fomit-frame-pointer -W -Wall -Winline -O3 -lz
CFLAGS = -w -c -mavx2 -mpopcnt -fomit-frame-pointer -Winline -O3 -lz -D __AVX2__
LDFLAGS = -lm -lz -lpthread -O3 -mpopcnt -mavx2 -lz -w -D __AVX2__
endif

SOURCES = saca-k.cpp bwt.cpp uint40.h Bitmapper_main.cpp Process_CommandLines.cpp Auxiliary.cpp Index.cpp Schema.cpp Process_sam_out.cpp Process_Reads.cpp Ref_Genome.cpp Levenshtein_Cal.cpp SAM_queue.cpp
OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE = bitmapperBS

.ONESHELL:
all: $(SOURCES) $(EXECUTABLE)
	rm -rf *.o; cd libdivsufsort-2.0.1/; cmake -DCMAKE_BUILD_TYPE="Release" .; make; cd ../pSAscan-0.1.0/src; make; cp psascan ../../; chmod 777 psascan
	#@echo $(AVX2_INFO)
	#rm -rf *.o; cd libdivsufsort-2.0.1/; cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="/usr/local" .; make; sudo make install; cd ../pSAscan-0.1.0/src; make; cp psascan ../../; chmod 777 psascan
	#rm -rf *.o
	#cd libdivsufsort-2.0.1/
	#cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="/usr/local" .
	#make
	#sudo make install
	#cd ../pSAscan-0.1.0/src 
	#make
	#cp psascan ../../

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@ 
clean:
	rm -f *.o *~ \#* bitmapper_BS
#relase:
	#chmod 777 psascan


