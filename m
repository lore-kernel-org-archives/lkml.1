Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYHZJcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYHZJcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHZJce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:32:34 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:37771 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYHZJcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:32:33 -0400
Message-ID: <48B3CDAF.604@aitel.hist.no>
Date: Tue, 26 Aug 2008 11:32:31 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
References: <4899AF8E.20105@sbg.ac.at> <489B85A3.7030500@sbg.ac.at>	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>	 <48A43CB5.8010709@sbg.ac.at>	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>	 <48AD8125.7050104@sbg.ac.at>	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>	 <48AE90BB.5090800@aitel.hist.no>	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>	 <48B29320.5070903@aitel.hist.no> <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
In-Reply-To: <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:

> please use "mtrr_spare_reg_nr=3 debug"
> 
> you missed _nr.
> 
Sorry. I got it right this time, and mtrr setup succeeded:

dmesg:
Command line: root=/dev/sda2 ro mtrr_spare_reg_nr=3 debug
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   Centaur CentaurHauls
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fe5a800 (usable)
  BIOS-e820: 000000007fe5a800 - 0000000080000000 (reserved)
  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
last_pfn = 0x7fe5a max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
total RAM coverred: 2047M
  gran_size: 1M  chunk_size: 1M  num_reg: 8      lose RAM: 7M
  gran_size: 1M  chunk_size: 2M  num_reg: 8      lose RAM: 7M
  gran_size: 1M  chunk_size: 4M  num_reg: 8      lose RAM: 7M
  gran_size: 1M  chunk_size: 8M  num_reg: 8      lose RAM: 7M
*BAD* gran_size: 1M     chunk_size: 16M         num_reg: 8      lose 
RAM: -1M
  gran_size: 1M  chunk_size: 32M         num_reg: 8      lose RAM: 0M
  gran_size: 1M  chunk_size: 64M         num_reg: 7      lose RAM: 0M
  gran_size: 1M  chunk_size: 128M        num_reg: 6      lose RAM: 0M
  gran_size: 1M  chunk_size: 256M        num_reg: 5      lose RAM: 0M
  gran_size: 1M  chunk_size: 512M        num_reg: 4      lose RAM: 0M
  gran_size: 1M  chunk_size: 1024M       num_reg: 3      lose RAM: 0M
  gran_size: 1M  chunk_size: 2048M       num_reg: 2      lose RAM: 0M
  gran_size: 1M  chunk_size: 4096M       num_reg: 8      lose RAM: 7M
  gran_size: 2M  chunk_size: 2M  num_reg: 8      lose RAM: 7M
  gran_size: 2M  chunk_size: 4M  num_reg: 8      lose RAM: 7M
  gran_size: 2M  chunk_size: 8M  num_reg: 8      lose RAM: 7M
*BAD* gran_size: 2M     chunk_size: 16M         num_reg: 8      lose 
RAM: -1M
  gran_size: 2M  chunk_size: 32M         num_reg: 8      lose RAM: 1M
  gran_size: 2M  chunk_size: 64M         num_reg: 7      lose RAM: 1M
  gran_size: 2M  chunk_size: 128M        num_reg: 6      lose RAM: 1M
  gran_size: 2M  chunk_size: 256M        num_reg: 5      lose RAM: 1M
  gran_size: 2M  chunk_size: 512M        num_reg: 4      lose RAM: 1M
  gran_size: 2M  chunk_size: 1024M       num_reg: 3      lose RAM: 1M
  gran_size: 2M  chunk_size: 2048M       num_reg: 2      lose RAM: 1M
  gran_size: 2M  chunk_size: 4096M       num_reg: 8      lose RAM: 7M
  gran_size: 4M  chunk_size: 4M  num_reg: 8      lose RAM: 7M
  gran_size: 4M  chunk_size: 8M  num_reg: 8      lose RAM: 7M
*BAD* gran_size: 4M     chunk_size: 16M      num_reg: 8      lose RAM: -1M
  gran_size: 4M  chunk_size: 32M         num_reg: 8      lose RAM: 3M
  gran_size: 4M  chunk_size: 64M         num_reg: 7      lose RAM: 3M
  gran_size: 4M  chunk_size: 128M        num_reg: 6      lose RAM: 3M
  gran_size: 4M  chunk_size: 256M        num_reg: 5      lose RAM: 3M
  gran_size: 4M  chunk_size: 512M        num_reg: 4      lose RAM: 3M
  gran_size: 4M  chunk_size: 1024M       num_reg: 3      lose RAM: 3M
  gran_size: 4M  chunk_size: 2048M       num_reg: 2      lose RAM: 3M
  gran_size: 4M  chunk_size: 4096M       num_reg: 8      lose RAM: 7M
  gran_size: 8M  chunk_size: 8M  num_reg: 8      lose RAM: 7M
  gran_size: 8M  chunk_size: 16M         num_reg: 8      lose RAM: 7M
  gran_size: 8M  chunk_size: 32M         num_reg: 8      lose RAM: 7M
  gran_size: 8M  chunk_size: 64M         num_reg: 7      lose RAM: 7M
  gran_size: 8M  chunk_size: 128M        num_reg: 6      lose RAM: 7M
  gran_size: 8M  chunk_size: 256M        num_reg: 5      lose RAM: 7M
  gran_size: 8M  chunk_size: 512M        num_reg: 4      lose RAM: 7M
  gran_size: 8M  chunk_size: 1024M       num_reg: 3      lose RAM: 7M
  gran_size: 8M  chunk_size: 2048M       num_reg: 2      lose RAM: 7M
  gran_size: 8M  chunk_size: 4096M       num_reg: 8      lose RAM: 7M
  gran_size: 16M    chunk_size: 16M         num_reg: 7      lose RAM: 15M
  gran_size: 16M    chunk_size: 32M         num_reg: 7      lose RAM: 15M
  gran_size: 16M    chunk_size: 64M         num_reg: 7      lose RAM: 15M
  gran_size: 16M    chunk_size: 128M        num_reg: 6      lose RAM: 15M
  gran_size: 16M    chunk_size: 256M        num_reg: 5      lose RAM: 15M
  gran_size: 16M    chunk_size: 512M        num_reg: 4      lose RAM: 15M
  gran_size: 16M    chunk_size: 1024M       num_reg: 3      lose RAM: 15M
  gran_size: 16M    chunk_size: 2048M       num_reg: 2      lose RAM: 15M
  gran_size: 16M    chunk_size: 4096M       num_reg: 7      lose RAM: 15M
  gran_size: 32M    chunk_size: 32M         num_reg: 6      lose RAM: 31M
  gran_size: 32M    chunk_size: 64M         num_reg: 6      lose RAM: 31M
  gran_size: 32M    chunk_size: 128M        num_reg: 6      lose RAM: 31M
  gran_size: 32M    chunk_size: 256M        num_reg: 5      lose RAM: 31M
  gran_size: 32M    chunk_size: 512M        num_reg: 4      lose RAM: 31M
  gran_size: 32M    chunk_size: 1024M       num_reg: 3      lose RAM: 31M
  gran_size: 32M    chunk_size: 2048M       num_reg: 2      lose RAM: 31M
  gran_size: 32M    chunk_size: 4096M       num_reg: 6      lose RAM: 31M
  gran_size: 64M    chunk_size: 64M         num_reg: 5      lose RAM: 63M
  gran_size: 64M    chunk_size: 128M        num_reg: 5      lose RAM: 63M
  gran_size: 64M    chunk_size: 256M        num_reg: 5      lose RAM: 63M
  gran_size: 64M    chunk_size: 512M        num_reg: 4      lose RAM: 63M
  gran_size: 64M    chunk_size: 1024M       num_reg: 3      lose RAM: 63M
  gran_size: 64M    chunk_size: 2048M       num_reg: 2      lose RAM: 63M
  gran_size: 64M    chunk_size: 4096M       num_reg: 5      lose RAM: 63M
  gran_size: 128M  chunk_size: 128M        num_reg: 4      lose RAM: 127M
  gran_size: 128M  chunk_size: 256M        num_reg: 4      lose RAM: 127M
  gran_size: 128M  chunk_size: 512M        num_reg: 4      lose RAM: 127M
  gran_size: 128M  chunk_size: 1024M       num_reg: 3      lose RAM: 127M
  gran_size: 128M  chunk_size: 2048M       num_reg: 2      lose RAM: 127M
  gran_size: 128M  chunk_size: 4096M       num_reg: 4      lose RAM: 127M
  gran_size: 256M  chunk_size: 256M        num_reg: 3      lose RAM: 255M
  gran_size: 256M  chunk_size: 512M        num_reg: 3      lose RAM: 255M
  gran_size: 256M  chunk_size: 1024M       num_reg: 3      lose RAM: 255M
  gran_size: 256M  chunk_size: 2048M       num_reg: 2      lose RAM: 255M
  gran_size: 256M  chunk_size: 4096M       num_reg: 3      lose RAM: 255M
  gran_size: 512M  chunk_size: 512M        num_reg: 2      lose RAM: 511M
  gran_size: 512M  chunk_size: 1024M       num_reg: 2      lose RAM: 511M
  gran_size: 512M  chunk_size: 2048M       num_reg: 2      lose RAM: 511M
  gran_size: 512M  chunk_size: 4096M       num_reg: 2      lose RAM: 511M
  gran_size: 1024M chunk_size: 1024M      num_reg: 1      lose RAM: 1023M
  gran_size: 1024M chunk_size: 2048M      num_reg: 1      lose RAM: 1023M
  gran_size: 1024M chunk_size: 4096M      num_reg: 1      lose RAM: 1023M
  gran_size: 2048M chunk_size: 2048M      num_reg: 0      lose RAM: 2047M
  gran_size: 2048M chunk_size: 4096M      num_reg: 0      lose RAM: 2047M
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 256M        num_reg: 5      lose RAM: 0M
range0: 0000000000000000 - 0000000070000000
Setting variable MTRR 0, base: 0MB, range: 1024MB, type WB
Setting variable MTRR 1, base: 1024MB, range: 512MB, type WB
Setting variable MTRR 2, base: 1536MB, range: 256MB, type WB
range: 0000000070000000 - 0000000080000000
Setting variable MTRR 3, base: 1792MB, range: 256MB, type WB
hole: 000000007ff00000 - 0000000080000000
Setting variable MTRR 4, base: 2047MB, range: 1MB, type UC
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 0000000000080000
After UC checking
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
After sorting
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
init_memory_mapping
  0000000000 - 007fe00000 page 2M
  007fe00000 - 007fe5a000 page 4k
kernel direct mapping tables up to 7fe5a000 @ 8000-c000
last_map_addr: 7fe5a000 end: 7fe5a000
DMI 2.4 present.

Xorg.0.log:
(II) VESA(0): Primary V_BIOS segment is: 0xc000
(II) VESA(0): VESA BIOS detected
(II) VESA(0): VESA VBE Version 3.0
(II) VESA(0): VESA VBE Total Mem: 14336 kB
(II) VESA(0): VESA VBE OEM: NVIDIA
(II) VESA(0): VESA VBE OEM Software Rev: 96.134
(II) VESA(0): VESA VBE OEM Vendor: NVIDIA Corporation
(II) VESA(0): VESA VBE OEM Product: G86 Board - dawson0
(II) VESA(0): VESA VBE OEM Product Rev: Chip Rev
(II) VESA(0): Splitting WC range: base: 0xf3000000, size: 0xe00000
(II) VESA(0): Splitting WC range: base: 0xf3800000, size: 0x600000
(==) VESA(0): Write-combining range (0xf3c00000,0x200000)
(==) VESA(0): Write-combining range (0xf3800000,0x600000)
(==) VESA(0): Write-combining range (0xf3000000,0xe00000)
(II) VESA(0): virtual address = 0x7fe74b00e000,
         physical address = 0xf3000000, size = 14680064
(==) VESA(0): Default visual is TrueColor
(==) VESA(0): Backing store disabled


$ cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
reg03: base=0x70000000 (1792MB), size= 256MB: write-back, count=1
reg04: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
reg05: base=0xf3c00000 (3900MB), size=   2MB: write-combining, count=1
reg06: base=0xf3800000 (3896MB), size=   4MB: write-combining, count=1
reg07: base=0xf3000000 (3888MB), size=   8MB: write-combining, count=1

This time X got its 3 regions, and no sluggishness when moving
opaque windows. :-)

I hope this helps so the extra bootup parameters can be avoided in the 
release kernel.

Helge Hafting
