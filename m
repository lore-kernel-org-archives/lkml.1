Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZAWIDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZAWIDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZAWIDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:03:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:39109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZAWIDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:03:45 -0500
Message-ID: <497979C1.3030103@kernel.org>
Date: Fri, 23 Jan 2009 00:03:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory
 	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com> <49794422.2080109@kernel.org> <49797634.7040500@kernel.org> <4979771E.5050001@kernel.org> <49797949.7090906@kernel.org>
In-Reply-To: <49797949.7090906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> Yinghai Lu wrote:
>>> current tip:
>>> still got
>>>
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c14d21ef 00921101   R_386_32 c1514000  __per_cpu_load
>> Hmm... weird.  Can you please attach the .config file you used and the
>> commit ID and the version of toolchain?  I'll try to reproduce it
>> here.
>>
> 
> my own config full, got that too
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> 40c22260 00d94801   R_386_32 40c7a000  __per_cpu_load
> 
early panic

Loading kernel.org/bzImage_2.6........................                          
Loading kernel.org/mydisk11_x86.gz..............................................Initializing cgroup subsys cpuset.....................                          
Linux version 2.6.29-rc2-tip-00971-gee15b6b-dirty (yhlu@linux-mstp) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #437 SMP Thu Jan 22 23:57:39 PST 2009....................................................................
KERNEL supported cpus:..............................                           
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
 BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
 BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (usable)
 BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
 BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
 BIOS-e820: 00000000d7ff0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000228000000 (usable)
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x228000 max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to b79fe000 @ 10000-18000
NX (Execute Disable) protection: active
RAMDISK: 7ea35000 - 7ffffe57
ACPI: RSDP 000FA570, 0014 (r0 ACPIAM)
ACPI: RSDT D7FB0000, 005C (r1 SUN    X4x40          52 MSFT       97)
ACPI: FACP D7FB0200, 0084 (r2 SUN    X4x40          52 MSFT       97)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT D7FB05D0, 7EB4 (r1 SUN    X4x40          52 INTL 20051117)
ACPI: FACS D7FBE000, 0040
ACPI: APIC D7FB0390, 00EC (r1 SUN    X4x40          52 MSFT       97)
ACPI: SPCR D7FB0480, 0050 (r1 SUN    X4x40          52 MSFT       97)
ACPI: MCFG D7FB04D0, 003C (r1 SUN    OEMMCFG        52 MSFT       97)
ACPI: SLIT D7FB0540, 003C (r1 SUN    OEMSLIT        52 MSFT       97)
ACPI: SPMI D7FB0580, 0041 (r1 SUN    OEMSPMI        52 MSFT       97)
ACPI: OEMB D7FBE040, 00AE (r1 SUN    X4x40          52 MSFT       97)
ACPI: SRAT D7FB8490, 0220 (r1 AMD    FAM_F_10        2 AMD         1)
ACPI: HPET D7FB86B0, 0038 (r1 SUN    OEMHPET0       52 MSFT       97)
ACPI: EINJ D7FB86F0, 0130 (r1  AMIER AMI_EINJ 10000815 MSFT       97)
ACPI: BERT D7FB8880, 0030 (r1  AMIER AMI_BERT 10000815 MSFT       97)
ACPI: ERST D7FB88B0, 01B0 (r1  AMIER AMI_ERST 10000815 MSFT       97)
ACPI: HEST D7FB8A60, 00A8 (r1  AMIER AMI_HEST 10000815 MSFT       97)
ACPI: SSDT D7FB8B10, 21C4 (r1 A M I  POWERNOW        1 AMD         1)
ACPI: Local APIC address 0xfee00000
CPU 04 in proximity domain 00
CPU 05 in proximity domain 00
CPU 06 in proximity domain 00
CPU 07 in proximity domain 00
CPU 08 in proximity domain 01
CPU 09 in proximity domain 01
CPU 0a in proximity domain 01
CPU 0b in proximity domain 01
CPU 0c in proximity domain 02
CPU 0d in proximity domain 02
CPU 0e in proximity domain 02
CPU 0f in proximity domain 02
CPU 10 in proximity domain 03
CPU 11 in proximity domain 03
CPU 12 in proximity domain 03
CPU 13 in proximity domain 03
Memory range 00000000 to 000000a0 in proximity domain 00 enabled
Memory range 00000100 to 00080000 in proximity domain 00 enabled
Memory range 00080000 to 000d8000 in proximity domain 01 enabled
Memory range 00100000 to 00128000 in proximity domain 01 enabled
Memory range 00128000 to 001a8000 in proximity domain 02 enabled
Memory range 001a8000 to 00228000 in proximity domain 03 enabled
ACPI: SLIT: nodes = 4
   10 13 13 16
   13 10 16 13
   13 16 10 13
   16 13 13 10
Scan SMP from 40000000 for 1024 bytes.
Scan SMP from 4009fc00 for 1024 bytes.
Scan SMP from 400f0000 for 65536 bytes.
found SMP MP-table at [400ff780] 000ff780
pxm bitmap: 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Number of logical nodes in system = 4
Number of memory chunks in system = 6
chunk 0 nid 0 start_pfn 00000000 end_pfn 000000a0
Adding active range (0, 0x10, 0x99) 0 entries of 3200 used
chunk 1 nid 0 start_pfn 00000100 end_pfn 00080000
Adding active range (0, 0x100, 0x80000) 1 entries of 3200 used
chunk 2 nid 1 start_pfn 00080000 end_pfn 000d8000
Adding active range (1, 0x80000, 0xd7fa0) 2 entries of 3200 used
Adding active range (1, 0xd7fae, 0xd7fb0) 3 entries of 3200 used
chunk 3 nid 1 start_pfn 00100000 end_pfn 00128000
Adding active range (1, 0x100000, 0x128000) 4 entries of 3200 used
chunk 4 nid 2 start_pfn 00128000 end_pfn 001a8000
Adding active range (2, 0x128000, 0x1a8000) 5 entries of 3200 used
chunk 5 nid 3 start_pfn 001a8000 end_pfn 00228000
Adding active range (3, 0x1a8000, 0x228000) 6 entries of 3200 used
node 0 pfn: [0 - 80000]
Reserving 4608 pages of KVA for lmem_map of node 0 at 7d800
Removing active range (0, 0x7d800, 0x7ea00)
Adding active range (0, 0x7ea00, 0x80000) 7 entries of 3200 used
node 1 pfn: [80000 - 128000]
Reserving 5632 pages of KVA for lmem_map of node 1 at 126a00
Removing active range (1, 0x126a00, 0x128000)
node 2 pfn: [128000 - 1a8000]
Reserving 4608 pages of KVA for lmem_map of node 2 at 1a6e00
Removing active range (2, 0x1a6e00, 0x1a8000)
node 3 pfn: [1a8000 - 228000]
Reserving 4608 pages of KVA for lmem_map of node 3 at 226e00
Removing active range (3, 0x226e00, 0x228000)
Reserving total of 4c00 pages for numa KVA remap
kva_start_pfn ~ 80000 max_low_pfn ~ b79fe
max_pfn = 228000
5894MB HIGHMEM available.
2937MB LOWMEM available.
max_low_pfn = b79fe, highstart_pfn = b79fe
Low memory ends at vaddr f79fe000
node 0 will remap to vaddr c0000000 - c1200000
allocate_pgdat: node 0 NODE_DATA c0000000
node 1 will remap to vaddr c1200000 - c2800000
allocate_pgdat: node 1 NODE_DATA c1200000
node 2 will remap to vaddr c2800000 - c3a00000
allocate_pgdat: node 2 NODE_DATA c2800000
node 3 will remap to vaddr c3a00000 - c4c00000
allocate_pgdat: node 3 NODE_DATA c3a00000
remap_numa_kva: node 0
remap_numa_kva: c0000000 to pfn 0007d800
remap_numa_kva: c0200000 to pfn 0007da00
remap_numa_kva: c0400000 to pfn 0007dc00
remap_numa_kva: c0600000 to pfn 0007de00
remap_numa_kva: c0800000 to pfn 0007e000
remap_numa_kva: c0a00000 to pfn 0007e200
remap_numa_kva: c0c00000 to pfn 0007e400
remap_numa_kva: c0e00000 to pfn 0007e600
remap_numa_kva: c1000000 to pfn 0007e800
remap_numa_kva: node 1
remap_numa_kva: c1200000 to pfn 00126a00
remap_numa_kva: c1400000 to pfn 00126c00
remap_numa_kva: c1600000 to pfn 00126e00
remap_numa_kva: c1800000 to pfn 00127000
remap_numa_kva: c1a00000 to pfn 00127200
remap_numa_kva: c1c00000 to pfn 00127400
remap_numa_kva: c1e00000 to pfn 00127600
remap_numa_kva: c2000000 to pfn 00127800
remap_numa_kva: c2200000 to pfn 00127a00
remap_numa_kva: c2400000 to pfn 00127c00
remap_numa_kva: c2600000 to pfn 00127e00
remap_numa_kva: node 2
remap_numa_kva: c2800000 to pfn 001a6e00
remap_numa_kva: c2a00000 to pfn 001a7000
remap_numa_kva: c2c00000 to pfn 001a7200
remap_numa_kva: c2e00000 to pfn 001a7400
remap_numa_kva: c3000000 to pfn 001a7600
remap_numa_kva: c3200000 to pfn 001a7800
remap_numa_kva: c3400000 to pfn 001a7a00
remap_numa_kva: c3600000 to pfn 001a7c00
remap_numa_kva: c3800000 to pfn 001a7e00
remap_numa_kva: node 3
remap_numa_kva: c3a00000 to pfn 00226e00
remap_numa_kva: c3c00000 to pfn 00227000
remap_numa_kva: c3e00000 to pfn 00227200
remap_numa_kva: c4000000 to pfn 00227400
remap_numa_kva: c4200000 to pfn 00227600
remap_numa_kva: c4400000 to pfn 00227800
remap_numa_kva: c4600000 to pfn 00227a00
remap_numa_kva: c4800000 to pfn 00227c00
remap_numa_kva: c4a00000 to pfn 00227e00
High memory starts at vaddr f79fe000
  mapped low ram: 0 - b79fe000
  low ram: 00000000 - b79fe000
  bootmap 00011000 - 00027f40
Pid: 0, comm: swapper Not tainted 2.6.29-rc2-tip-00971-gee15b6b-dirty #437
Call Trace:
 [<40c32ecd>] ? mark_bootmem_node+0x44/0x7d
 [<40c33001>] ? free_bootmem_node+0x20/0x24
 [<40c33c1a>] ? free_bootmem_with_active_regions+0x63/0x94
 [<40c2e181>] ? setup_bootmem_allocator+0xe4/0x12e
 [<40c2f25c>] ? initmem_init+0x617/0x629
 [<40c3a7be>] ? acpi_table_parse+0x66/0x6f
 [<40c219aa>] ? setup_arch+0x756/0x957
 [<40240e44>] ? up+0x2b/0x2f
 [<40c23ee1>] ? __reserve_early+0xe4/0xf8
 [<40c1b59f>] ? start_kernel+0x6d/0x2d6
 [<40c1b085>] ? __init_begin+0x85/0x8d

it seems we get lost with 32bit...

YH
