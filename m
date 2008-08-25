Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYHYLKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYHYLKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYHYLK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:10:28 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38094 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYHYLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:10:27 -0400
Message-ID: <48B29320.5070903@aitel.hist.no>
Date: Mon, 25 Aug 2008 13:10:24 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
References: <4899AF8E.20105@sbg.ac.at>	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>	 <489B85A3.7030500@sbg.ac.at>	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>	 <48A43CB5.8010709@sbg.ac.at>	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>	 <48AD8125.7050104@sbg.ac.at>	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>	 <48AE90BB.5090800@aitel.hist.no> <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
In-Reply-To: <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Aug 22, 2008 at 3:11 AM, Helge Hafting
>   
[old bug report removed]
> please boot with "mtrr_spare_reg_nr=3 debug"
>   
I did that, and got:
dmesg:
Command line: root=/dev/sda2 ro mtrr_spare_reg=3 debug
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe80400 (usable)
 BIOS-e820: 000000007fe80400 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
last_pfn = 0x7fe80 max_arch_pfn = 0x3ffffffff
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
*BAD* gran_size: 4M     chunk_size: 16M         num_reg: 8      lose 
RAM: -1M
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
 gran_size: 16M         chunk_size: 16M         num_reg: 7      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 32M         num_reg: 7      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 64M         num_reg: 7      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 128M        num_reg: 6      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 256M        num_reg: 5      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 512M        num_reg: 4      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 1024M       num_reg: 3      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 2048M       num_reg: 2      lose 
RAM: 15M
 gran_size: 16M         chunk_size: 4096M       num_reg: 7      lose 
RAM: 15M
 gran_size: 32M         chunk_size: 32M         num_reg: 6      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 64M         num_reg: 6      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 128M        num_reg: 6      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 256M        num_reg: 5      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 512M        num_reg: 4      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 1024M       num_reg: 3      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 2048M       num_reg: 2      lose 
RAM: 31M
 gran_size: 32M         chunk_size: 4096M       num_reg: 6      lose 
RAM: 31M
 gran_size: 64M         chunk_size: 64M         num_reg: 5      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 128M        num_reg: 5      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 256M        num_reg: 5      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 512M        num_reg: 4      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 1024M       num_reg: 3      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 2048M       num_reg: 2      lose 
RAM: 63M
 gran_size: 64M         chunk_size: 4096M       num_reg: 5      lose 
RAM: 63M
 gran_size: 128M        chunk_size: 128M        num_reg: 4      lose 
RAM: 127M
 gran_size: 128M        chunk_size: 256M        num_reg: 4      lose 
RAM: 127M
 gran_size: 128M        chunk_size: 512M        num_reg: 4      lose 
RAM: 127M
 gran_size: 128M        chunk_size: 1024M       num_reg: 3      lose 
RAM: 127M
 gran_size: 128M        chunk_size: 2048M       num_reg: 2      lose 
RAM: 127M
 gran_size: 128M        chunk_size: 4096M       num_reg: 4      lose 
RAM: 127M
 gran_size: 256M        chunk_size: 256M        num_reg: 3      lose 
RAM: 255M
 gran_size: 256M        chunk_size: 512M        num_reg: 3      lose 
RAM: 255M
 gran_size: 256M        chunk_size: 1024M       num_reg: 3      lose 
RAM: 255M
 gran_size: 256M        chunk_size: 2048M       num_reg: 2      lose 
RAM: 255M
 gran_size: 256M        chunk_size: 4096M       num_reg: 3      lose 
RAM: 255M
 gran_size: 512M        chunk_size: 512M        num_reg: 2      lose 
RAM: 511M
 gran_size: 512M        chunk_size: 1024M       num_reg: 2      lose 
RAM: 511M
 gran_size: 512M        chunk_size: 2048M       num_reg: 2      lose 
RAM: 511M
 gran_size: 512M        chunk_size: 4096M       num_reg: 2      lose 
RAM: 511M
 gran_size: 1024M       chunk_size: 1024M       num_reg: 1      lose 
RAM: 1023M
 gran_size: 1024M       chunk_size: 2048M       num_reg: 1      lose 
RAM: 1023M
 gran_size: 1024M       chunk_size: 4096M       num_reg: 1      lose 
RAM: 1023M
 gran_size: 2048M       chunk_size: 2048M       num_reg: 0      lose 
RAM: 2047M
 gran_size: 2048M       chunk_size: 4096M       num_reg: 0      lose 
RAM: 2047M
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 64M         num_reg: 7      lose RAM: 0M
range0: 0000000000000000 - 000000007c000000
Setting variable MTRR 0, base: 0MB, range: 1024MB, type WB
Setting variable MTRR 1, base: 1024MB, range: 512MB, type WB
Setting variable MTRR 2, base: 1536MB, range: 256MB, type WB
Setting variable MTRR 3, base: 1792MB, range: 128MB, type WB
Setting variable MTRR 4, base: 1920MB, range: 64MB, type WB
range: 000000007c000000 - 0000000080000000
Setting variable MTRR 5, base: 1984MB, range: 64MB, type WB
hole: 000000007ff00000 - 0000000080000000
Setting variable MTRR 6, base: 2047MB, range: 1MB, type UC
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 0000000000080000
After UC checking
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
After sorting
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
init_memory_mapping
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe80000 page 4k
kernel direct mapping tables up to 7fe80000 @ 8000-c000
last_map_addr: 7fe80000 end: 7fe80000
DMI 2.4 present.

Xorg.0.log:
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Reloading /usr/lib/xorg/modules//libint10.so
(II) VESA(0): initializing int10
(II) VESA(0): Primary V_BIOS segment is: 0xc000
(II) VESA(0): VESA BIOS detected
(II) VESA(0): VESA VBE Version 3.0
(II) VESA(0): VESA VBE Total Mem: 14336 kB
(II) VESA(0): VESA VBE OEM: NVIDIA
(II) VESA(0): VESA VBE OEM Software Rev: 96.134
(II) VESA(0): VESA VBE OEM Vendor: NVIDIA Corporation
(II) VESA(0): VESA VBE OEM Product: G86 Board - dawson0
(II) VESA(0): VESA VBE OEM Product Rev: Chip Rev  
(II) VESA(0): Splitting WC range: base: 0xfb000000, size: 0xe00000
(II) VESA(0): Splitting WC range: base: 0xfb800000, size: 0x600000
(==) VESA(0): Write-combining range (0xfbc00000,0x200000)
(WW) VESA(0): Failed to set up write-combining range (0xfb800000,0x600000)
(WW) VESA(0): Failed to set up write-combining range (0xfb000000,0xe00000)
(II) VESA(0): virtual address = 0x7f3ccaf43000,
        physical address = 0xfb000000, size = 14680064

Just like last time, this lack of mtrr is reflected in dmesg:
mtrr: no more MTRRs available
mtrr: no more MTRRs available

$ cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
reg07: base=0xfbc00000 (4028MB), size=   2MB: write-combining, count=1


The problem is still there, I hope the output is useful.
I can test experimental patches if necessary.

Helge Hafting
