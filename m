Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZBUNUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZBUNUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZBUNUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:20:43 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:35910 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZBUNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:20:41 -0500
Message-ID: <499FFFA6.8030709@cfl.rr.com>
Date: Sat, 21 Feb 2009 08:20:38 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com> <499EE3BA.7070105@cfl.rr.com> <499EEB0F.8010201@cfl.rr.com> <20090220182212.GH4834@alberich.amd.com> <499EF662.7010001@cfl.rr.com> <499F0A67.0@cfl.rr.com> <499F122E.1080601@cfl.rr.com> <20090220222847.GJ4834@alberich.amd.com> <499F5586.5090900@cfl.rr.com>
In-Reply-To: <499F5586.5090900@cfl.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Andreas Herrmann wrote:
>> Mark,
>>
>> Here we go ...
>>
>> Attached is a compound version against v2.6.28.4 of some
>> hpet patches that I'd like to submit asap.
>>
>> Can you please apply this patch and test it on your machine.
>>
>> By chance I've found a machine wich also hangs with HZ_1000.
>> And this patch fixes the problem on this machine.
>>
>>
>> Regards,
>> Andreas
>>
>> PS: Please boot with "hpet=verbose" to show the HPET registers
>> (no additional debug parameter needed this time).
>>
>>
> 
> Yep, that works here too. Attached is the bootlog FYI.
> 
> Regards
> Mark
> 
> 
> 

Andreas, I'm sorry but I fat fingered something last night. It didn't work for
me after all. I was configured as 250Hz. Sorry.

BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #11 SMP PREEMPT Sat Feb
 21 08:07:35 EST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
 BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
 BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
DMI 2.5 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0xbffe0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 32ffe000 @ 10000-16000
RAMDISK: 374d0000 - 37feff94
Allocated new RAMDISK: 004a7000 - 00fc6f94
Move RAMDISK from 00000000374d0000 - 0000000037feff93 to 004a7000 - 00fc6f93
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 004C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: SSDT BFFE8E40, 088C (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET BFFE9700, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE9740, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
2255MB HIGHMEM available.
815MB LOWMEM available.
  mapped low ram: 0 - 32ffe000
  low ram: 00000000 - 32ffe000
  bootmap 00012000 - 00018600
(9 early reservations) ==> bootmem [0000000000 - 0032ffe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004a3c54]    TEXT DATA BSS ==> [0000100000 - 00004a3c54]
  #4 [00004a4000 - 00004a7000]    INIT_PG_TABLE ==> [00004a4000 - 00004a7000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [00004a7000 - 0000fc6f94]      NEW RAMDISK ==> [00004a7000 - 0000fc6f94]
  #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f3f00] 000f3f00
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00032ffe
  HighMem  0x00032ffe -> 0x000bffe0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bffe0
On node 0 totalpages: 786287
free_area_init_node: node 0, pgdat c03a5900, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1600 pages used for memmap
  Normal zone: 203198 pages, LIFO batch:31
  HighMem zone: 4512 pages used for memmap
  HighMem zone: 572994 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 36864 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
hpet=verbose debug apic=debug apm=off selinux=0 noresume splash=silent  vmalloc=192
M vga=0x317 console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3000.326 MHz processor.
Console: colour dummy device 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3103636k/3145600k available (1836k kernel code, 40720k reserved, 1098k
data, 276k init, 2310024k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf37fe000 - 0xff7fe000   ( 192 MB)
    lowmem  : 0xc0000000 - 0xf2ffe000   ( 815 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02cb0d7 - 0xc03ddc4c   (1098 kB)
      .text : 0xc0100000 - 0xc02cb0d7   (1836 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet: hpet_enable(837):
hpet: ID: 0x43538301, PERIOD: 0x429b17e
hpet: CFG: 0x0, STATUS: 0x0
hpet: COUNTER_l: 0x0, COUNTER_h: 0x0
hpet: T0: CFG_l: 0x10, CFG_h: 0xc0ffff
hpet: T0: CMP_l: 0xffffffff, CMP_h: 0x0
hpet: T0 ROUTE_l: 0x0, ROUTE_h: 0x0
hpet: T1: CFG_l: 0x10, CFG_h: 0xc0ffff
hpet: T1: CMP_l: 0xffffffff, CMP_h: 0x0
hpet: T1 ROUTE_l: 0x0, ROUTE_h: 0x0
hpet: T2: CFG_l: 0x10, CFG_h: 0xc0ffff
hpet: T2: CMP_l: 0xffffffff, CMP_h: 0x0
hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
hpet: T3: CFG_l: 0x0, CFG_h: 0x0
hpet: T3: CMP_l: 0x0, CMP_h: 0x0
hpet: T3 ROUTE_l: 0x0, ROUTE_h: 0x0
hpet: hpet_se


Regards
Mark


