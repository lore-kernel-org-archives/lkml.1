Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZBTRkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZBTRkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZBTRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:40:40 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62822 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZBTRkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:40:35 -0500
Message-ID: <499EEB0F.8010201@cfl.rr.com>
Date: Fri, 20 Feb 2009 12:40:31 -0500
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
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com> <499EE3BA.7070105@cfl.rr.com>
In-Reply-To: <499EE3BA.7070105@cfl.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------090703050208000406080901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090703050208000406080901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mark Hounschell wrote:
> Andreas Herrmann wrote:
>> On Fri, Feb 20, 2009 at 05:08:43PM +0100, Andreas Herrmann wrote:
>>> On Fri, Feb 20, 2009 at 10:43:03AM -0500, Mark Hounschell wrote:
>>>> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1
>>>> 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux)
>>>> ) #7 SMP PREEMPT Fri Feb 2 0 09:01:54 EST 2009
>>> Here I doubt that's the right kernel -- at least it was not built today.
>>> Can you please double check this.
>> Oops, your kernel was built today.
>> Have overlooked it as there was a newline between "2" and "0".
>> Sorry for the noise.
>>
>> But still wondering where's the debug output. I've applied the patch
>> both to .29-rc5 and with some fuzziness to .28.4 and on my system the
>> output is visible (e.g. with dmesg). Ah, ... of course you need to use
>> "debug" kernel parameter as well.  Otherwise the KERN_DEBUG messages
>> are not shown on the serial console.
>>
>> Please, can you retry using "hpet=debug debug apic=debug".
>> Thanks.
>>
>>
>> Andreas
>>

Here is the 1000Hz

BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #9 SMP PREEMPT Fri Feb
20 12:14:07 EST 2009
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
RAMDISK: 374d0000 - 37fefeed
Allocated new RAMDISK: 004a7000 - 00fc6eed
Move RAMDISK from 00000000374d0000 - 0000000037fefeec to 004a7000 - 00fc6eec
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
  #7 [00004a7000 - 0000fc6eed]      NEW RAMDISK ==> [00004a7000 - 0000fc6eed]
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
hpet=debug debug apic=debug apm=off selinux=0 noresume splash=silent  vmalloc=192M
vga=0x317 console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3000.331 MHz processor.
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
      .data : 0xc02cb187 - 0xc03ddc4c   (1098 kB)
      .text : 0xc0100000 - 0xc02cb187   (1836 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet: hpet_enable(834):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 0, STATUS: 0
hpet: COUNTER_l: 0, COUNTER_h: 0
hpet: T0_CFG_l: 10, T0_CFG_h: c0ffff
hpet: T0_CMP_l: ffffffff, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
hpet: hpet_set_mode(304):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 3, STATUS: 0
hpet: COUNTER_l: 1b7db, COUNTER_h: 0
hpet: T0_CFG_l: 10, T0_CFG_h: c0ffff
hpet: T0_CMP_l: ffffffff, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
hpet: hpet_se


The 250Hz is attached

Regards
Mark

--------------090703050208000406080901
Content-Type: text/plain;
 name="d.bootlog-250Hz.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="d.bootlog-250Hz.txt"

BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #9 SMP PREEMPT Fri Feb 2
0 12:11:43 EST 2009
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
RAMDISK: 374cf000 - 37fef035
Allocated new RAMDISK: 004a7000 - 00fc7035
Move RAMDISK from 00000000374cf000 - 0000000037fef034 to 004a7000 - 00fc7034
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
  #7 [00004a7000 - 0000fc7035]      NEW RAMDISK ==> [00004a7000 - 0000fc7035]
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
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5 hpet=debug debug apic=debug apm=off selinux=0 noresume splash=silent  vmalloc=192M
vga=0x317 console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 3000.201 MHz processor.
Console: colour dummy device 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3103632k/3145600k available (1836k kernel code, 40724k reserved, 1098k data, 276k init, 2310024k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf37fe000 - 0xff7fe000   ( 192 MB)
    lowmem  : 0xc0000000 - 0xf2ffe000   ( 815 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02cb157 - 0xc03ddc4c   (1098 kB)
      .text : 0xc0100000 - 0xc02cb157   (1836 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet: hpet_enable(834):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 0, STATUS: 0
hpet: COUNTER_l: 1, COUNTER_h: 0
hpet: T0_CFG_l: 10, T0_CFG_h: c0ffff
hpet: T0_CMP_l: ffffffff, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
hpet: hpet_set_mode(304):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 3, STATUS: 0
hpet: COUNTER_l: 1b7c8, COUNTER_h: 0
hpet: T0_CFG_l: 10, T0_CFG_h: c0ffff
hpet: T0_CMP_l: ffffffff, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
hpet: hpet_set_mode(322):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 3, STATUS: 1
hpet: COUNTER_l: b2459, COUNTER_h: 0
hpet: T0_CFG_l: 1c, T0_CFG_h: c0ffff
hpet: T0_CMP_l: d46e2, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
hpet clockevent registered
hpet: hpet_msi_capability_lookup(567):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 3, STATUS: 1
hpet: COUNTER_l: 19e7cd, COUNTER_h: 0
hpet: T0_CFG_l: 1c, T0_CFG_h: c0ffff
hpet: T0_CMP_l: 1c221a, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: ffffffff, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.40 BogoMIPS (lpj=12000804)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting ID: f000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 4-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 4-16 4-17 4-18 4-19 4-20 4-21 4-22 4-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1250071
... PM timer delta = 357949
... PM timer result ok
..... delta 1250071
..... mult: 53686785
..... calibration result: 800045
..... CPU clock speed is 3000.0672 MHz.
..... host bus clock speed is 200.0045 MHz.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 6000.40 BogoMIPS (lpj=12000811)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
masked ExtINT on CPU#2
Calibrating delay using timer specific routine.. 6000.39 BogoMIPS (lpj=12000795)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
masked ExtINT on CPU#3
Calibrating delay using timer specific routine.. 6000.40 BogoMIPS (lpj=12000808)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (24001.60 BogoMIPS).
net_namespace: 776 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:12.0: reg 10 io port: [0xff00-0xff07]
pci 0000:00:12.0: reg 14 io port: [0xfe00-0xfe03]
pci 0000:00:12.0: reg 18 io port: [0xfd00-0xfd07]
pci 0000:00:12.0: reg 1c io port: [0xfc00-0xfc03]
pci 0000:00:12.0: reg 20 io port: [0xfb00-0xfb0f]
pci 0000:00:12.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfe02c000-0xfe02cfff]
pci 0000:00:13.3: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
pci 0000:00:13.4: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
pci 0000:00:13.5: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.0: reg 10 io port: [0xb00-0xb0f]
pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0xf900-0xf90f]
pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xdfffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:01:00.0: reg 24 io port: [0xdf00-0xdf7f]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:02.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:02.0: bridge 64bit mmio pref: [0xc0000000-0xdfffffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xfdce0000-0xfdcfffff]
pci 0000:02:00.0: reg 14 32bit mmio: [0xfdcc0000-0xfdcdffff]
pci 0000:02:00.0: reg 18 io port: [0xcf00-0xcf1f]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:04.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:04.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:00:04.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
pci 0000:03:00.0: reg 24 32bit mmio: [0xfdafe000-0xfdafffff]
pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.1: reg 10 io port: [0xbf00-0xbf07]
pci 0000:03:00.1: reg 14 io port: [0xbe00-0xbe03]
pci 0000:03:00.1: reg 18 io port: [0xbd00-0xbd07]
pci 0000:03:00.1: reg 1c io port: [0xbc00-0xbc03]
pci 0000:03:00.1: reg 20 io port: [0xbb00-0xbb0f]
pci 0000:00:06.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:06.0: bridge 32bit mmio: [0xfda00000-0xfdafffff]
pci 0000:00:06.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfdefc000-0xfdefffff]
pci 0000:04:00.0: reg 18 io port: [0xee00-0xeeff]
pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:07.0: bridge io port: [0xe000-0xefff]
pci 0000:00:07.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
pci 0000:05:05.0: reg 10 io port: [0xaf00-0xaf3f]
pci 0000:05:05.0: reg 14 32bit mmio: [0xfd9ff000-0xfd9fffff]
pci 0000:05:06.0: reg 10 io port: [0xac00-0xacff]
pci 0000:05:06.0: reg 14 32bit mmio: [0xfd9fe000-0xfd9fefff]
pci 0000:05:06.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:05:07.0: reg 10 io port: [0xae00-0xae3f]
pci 0000:05:07.0: reg 14 32bit mmio: [0xfd9fd000-0xfd9fdfff]
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
pci 0000:00:14.4: bridge 32bit mmio: [0xfd900000-0xfd9fffff]
pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd800000-0xfd8fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 3: can't allocate resource

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0001
... PIC  ISR: 0000
... PIC ELCR: 0c28

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000208fc
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c352
... APIC TMCCT: 0000815d
... APIC TDCR: 00000003


printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c352
... APIC TMCCT: 0000a565
... APIC TDCR: 00000003


printing local APIC contents on CPU#2/2:
... APIC ID:      02000000 (2)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 04000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c352
... APIC TMCCT: 0000813c
... APIC TDCR: 00000003


printing local APIC contents on CPU#3/3:
... APIC ID:      03000000 (3)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 08000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c352
... APIC TMCCT: 00006036
... APIC TDCR: 00000003

number of MP IRQ sources: 15.
number of IO-APIC #4 registers: 24.
testing the IO APIC.......................

IO APIC #4......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00178021
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0021
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 00F 0    0    0   0   0    1    1    31
 02 0FF 0    0    0   0   0    1    1    30
 03 00F 0    0    0   0   0    1    1    33
 04 00F 0    0    0   0   0    1    1    34
 05 00F 0    0    0   0   0    1    1    35
 06 00F 0    0    0   0   0    1    1    36
 07 00F 1    0    0   0   0    1    1    37
 08 00F 0    0    0   0   0    1    1    38
 09 00F 0    1    0   1   0    1    1    39
 0a 00F 0    0    0   0   0    1    1    3A
 0b 00F 0    0    0   0   0    1    1    3B
 0c 00F 0    0    0   0   0    1    1    3C
 0d 00F 0    0    0   0   0    1    1    3D
 0e 00F 0    0    0   0   0    1    1    3E
 0f 00F 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
hpet: hpet_late_init(886):
hpet: ID: 43538301, PERIOD: 429b17e
hpet: CFG: 3, STATUS: 1
hpet: COUNTER_l: 245ba7f, COUNTER_h: 0
hpet: T0_CFG_l: 18, T0_CFG_h: c0ffff
hpet: T0_CMP_l: 247ef3a, T0_CMP_h: 0
hpet: T0_ROUTE_l: 0, T0_ROUTE_h: 0
hpet: T1_CFG_l: 10, T1_CFG_h: c0ffff
hpet: T1_CMP_l: ffffffff, T1_CMP_h: 0
hpet: T1_ROUTE_l: 0, T1_ROUTE_h: 0
hpet: T2_CFG_l: 10, T2_CFG_h: c0ffff
hpet: T2_CMP_l: 24401d9, T2_CMP_h: 0
hpet: T2_ROUTE_l: 0, T2_ROUTE_h: 0
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
pnp 00:0d: mem resource (0xf0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x1fffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x100000-0xbffdffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:0d: iomem range 0xfed00000-0xfed000ff has been reserved
system 00:0d: iomem range 0xbffe0000-0xbfffffff could not be reserved
system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0xd000-0xdfff
pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x000000dfffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0xc000-0xcfff
pci 0000:00:04.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:04.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
pci 0000:00:06.0:   IO window: 0xb000-0xbfff
pci 0000:00:06.0:   MEM window: 0xfda00000-0xfdafffff
pci 0000:00:06.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
pci 0000:00:07.0:   IO window: 0xe000-0xefff
pci 0000:00:07.0:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:07.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
pci 0000:00:14.4:   IO window: 0xa000-0xafff
pci 0000:00:14.4:   MEM window: 0xfd900000-0xfd9fffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fd800000-0x000000fd8fffff
IOAPIC[0]: Set routing entry (4-18 -> 0x49 -> IRQ 18 Mode:1 Active:1)
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (4-16 -> 0x51 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:06.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (4-19 -> 0x59 -> IRQ 19 Mode:1 Active:1)
pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:07.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
bus: 01 index 2 mmio: [0xc0000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xc000-0xcfff]
bus: 02 index 1 mmio: [0xfdc00000-0xfdcfffff]
bus: 02 index 2 mmio: [0xfdb00000-0xfdbfffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xb000-0xbfff]
bus: 03 index 1 mmio: [0xfda00000-0xfdafffff]
bus: 03 index 2 mmio: [0xfdf00000-0xfdffffff]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0xe000-0xefff]
bus: 04 index 1 mmio: [0xfde00000-0xfdefffff]
bus: 04 index 2 mmio: [0xfdd00000-0xfddfffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xa000-0xafff]
bus: 05 index 1 mmio: [0xfd900000-0xfd9fffff]
bus: 05 index 2 mmio: [0xfd800000-0xfd8fffff]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 11392k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1235132930.640:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1573
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pcieport-driver 0000:00:02.0: irq 1279 for MSI/MSI-X
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie03: allocate port service
pcieport-driver 0000:00:04.0: setting latency timer to 64
pcieport-driver 0000:00:04.0: found MSI capability
pcieport-driver 0000:00:04.0: irq 1278 for MSI/MSI-X
pci_express 0000:00:04.0:pcie00: allocate port service
pci_express 0000:00:04.0:pcie03: allocate port service
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: found MSI capability
pcieport-driver 0000:00:06.0: irq 1277 for MSI/MSI-X
pci_express 0000:00:06.0:pcie00: allocate port service
pci_express 0000:00:06.0:pcie03: allocate port service
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: found MSI capability
pcieport-driver 0000:00:07.0: irq 1276 for MSI/MSI-X
pci_express 0000:00:07.0:pcie00: allocate port service
pci_express 0000:00:07.0:pcie03: allocate port service
vesafb: framebuffer at 0xf9000000, mapped to 0xf3880000, using 3072k, total 14336k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: protected mode interface info at c000:b0a0
vesafb: pmi: set display start = c00cb103, set palette = c00cb15e
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 276k freed
doing fast boot
Boot logging started on /dev/ttyS0(/dev/console) at Fri Feb 20 12:28:51 2009
FATAL: Module processor not founSCSI subsystem initialized
d.
FATAL: Module thermal not found.
libata version 3.00 loaded.
pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pata_jmicron 0000:03:00.1: setting latency timer to 64
scsi0 : pata_jmicron
scsi1 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xbf00 ctl 0xbe00 bmdma 0xbb00 irq 19
ata2: PATA max UDMA/100 cmd 0xbd00 ctl 0xbc00 bmdma 0xbb08 irq 19
logips2pp: Detected unknown logitech mouse model 11
ahci 0000:00:12.0: version 3.0
IOAPIC[0]: Set routing entry (4-22 -> 0x81 -> IRQ 22 Mode:1 Active:1)
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
ata3: softreset failed (device not ready)
ata3: failed due to HW bug, retry pmp=0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: configured for UDMA/133
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: configured for UDMA/133
ata5: softreset failed (device not ready)
ata5: failed due to HW bug, retry pmp=0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ahci 0000:03:00.0: setting latency timer to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe100 irq 18
ata8: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe180 irq 18
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
Uniform Multi-Platform E-IDE driver
atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf900-0xf907
Probing IDE interface ide0...
hda: ST3120023A, ATA DISK drive
hdb: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
IOAPIC[0]: Set routing entry (4-21 -> 0x89 -> IRQ 21 Mode:1 Active:1)
aic7xxx 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

FATAL: Module fan not found.
BIOS EDD facility v0.16 2004-Jun-25, 4 devices found
sky2 driver version 1.22
sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 5
sky2 0000:04:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
 Part Number: Yukon 88E8056
 Engineering Level: Rev. 1.3
 Manufacturer: Marvell
sky2 0000:04:00.0: irq 1275 for MSI/MSI-X
sky2 eth0: addr 00:e0:4d:7a:8c:ee
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
preping 03-storage.sh
running 03-storage.sh
preping 04-udev.sh
running 04-udev.sh
Creating device nodes with udev
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
sd 2:0:0:0: [sda] Write Protect is off
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28.3-250Hz ehci_hcd
usb usb1: SerialNumber: 0000:00:13.5
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ohci_hcd 0000:00:13.0: OHCI Host Controller
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5<6>ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
 sda6<6>ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
 sda7 sda8 sda9 sda10 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
IOAPIC[0]: Set routing entry (4-17 -> 0x99 -> IRQ 17 Mode:1 Active:1)
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
sd 3:0:0:0: [sdb] Write Protect is off
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:<6>usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 sdb1 sdb2 sdb3 <<6>usb usb3: Product: OHCI Host Controller
 sdb5<6>usb usb3: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
 sdb6<6>usb usb3: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
usb 1-1: new high speed USB device using ehci_hcd and address 2
 sdb7<6>ohci_hcd 0000:00:13.2: OHCI Host Controller
 sdb8<6>ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
 sdb9 sdb10 >
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=03f0, idProduct=5111
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: Photosmart 3200 series
usb 1-1: Manufacturer: HP
usb 1-1: SerialNumber: MY5B98310Z045K
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb6: SerialNumber: 0000:00:13.4
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
usb 2-2: new full speed USB device using ohci_hcd and address 2
preping 05-blogd.sh
running 05-blogd.sh
preping 11-block.sh
running 11-block.sh
preping 11-usb.sh
running 11-usb.sh
preping 21-devinit_done.sh
usb 2-2: device descriptor read/64, error -62

preping 81-kdump.sh
running 81-kdump.sh
preping 82-resume.userspace.sh
running 82-resume.userspace.sh
preping 83-resume.kernel.sh
running 83-resume.kernel.sh
preping 84-mount.sh
running 84-mount.sh
Waiting for device /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5 to appear:  ok
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
fsck 1.40.8 (13-Mar-2008)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5: recovering journal
usb 2-2: device descriptor read/64, error -62
usb 2-2: new full speed USB device using ohci_hcd and address 3
usb 2-2: device descriptor read/64, error -62
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5: clean, 346628/3280320 files, 4787265/6554512 blocks
fsck succeeded. Mounting root device read-write.kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

Mounting root /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
preping 85-remount.sh
running 85-remount.sh
preping 91-createfb.sh
running 91-crusb 2-2: device descriptor read/64, error -62
eatefb.sh
preping 91-killblogd.sh
running 91-killblogd.sh
preping 91-killudev.sh
running 91-killudev.sh
preping 91-shell.sh
running 91-shell.sh
preping 92-killblogd2.sh
running 92-killblogd2.sh
usb 2-2: new full speed USB device using ohci_hcd and address 4
preping 93-boot.sh
running 93-boot.sh
usb 2-2: device not accepting address 4, error -62
usb 2-2: new full speed USB device using ohci_hcd and address 5
INIT: version 2.86 booting
usb 2-2: device not accepting address 5, error -62
hub 2-0:1.0: unable to enumerate USB device on port 2
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc                                              done
Mounting sysfs at /sys                                                done
Mounting debugfs at /sys/kernel/debug                                 done
Initializing /dev                                                     done
Mounting devpts at /dev/pts                                           done
                                                                      done
Starting udevd: sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: irq 1274 for MSI/MSI-X
0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:0f:09:1b
0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
0000:02:00.0: eth1: MAC: 1, PHY: 4, PBA No: d50854-003
Linux agpgart interface v0.103
ide-cd driver 5.00
ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: waiting for device to settle before scanning
usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x5111
usbcore: registered new interface driver usblp
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
IT8718 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
ppdev: user-space parallel port driver
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3055: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:3059:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3063:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3064:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3072:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x0, aux=0x0
                                                                      done
Loading required kernel modules                                       done
Activating swap-devices in /etc/fstab...
Adding 8393952k swap on /dev/sda2.  Priority:-1 extents:1 across:83939done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
mount: according to mtab, /dev/sda5 is already mounted on /

Setting up the hardware clock                                         done
Activating device mapper...
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
                                                                      done
Checking file systems...
fsck 1.40.8 (13-Mar-2008)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part1
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part1: clean, 133/131616 files, 90643/263056 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part6
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part6: clean, 84123/5903072 files, 1456103/11797726 blocks
[/sbin/fsck.ext3 (1) -- /misc] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part7
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part7: clean, 10/8536064 files, 313923/17040940 blocks
[/sbin/fsck.ext3 (1) -- /usr/local] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part8
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part8: clean, 10111/656000 files, 562964/1311297 blocks
[/sbin/fsck.ext3 (1) -- /usr/src] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part9
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part9: clean, 988859/6557152 files, 10060870/13109032 blocks
[/sbin/fsck.ext3 (1) -- /misc1] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part10
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part10: clean, 13/12992512 files, 455787/25967056 blocks
[/sbin/fsck.ext3 (1) -- /local] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDWN-part1
/dev/disk/by-id/ata-ST3320620AS_6QF4HDWN-part1: clean, 1673848/39075840 files, 21295684/78142160 blocks
[/sbin/fsck.ext3 (1) -- /lcrs] fsck.ext3 -a /dev/disk/by-id/ata-ST3120023A_3KA0P431-part1
/dev/disk/by-id/ata-ST3120023A_3KA0P431-part1: clean, 32325/14663680 fdone, 24187969/29302552 blocks
                                                                      done
Mounting local file systems...
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
loop: module loaded
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda1 on /boot type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda6 on /home type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda7 on /misc type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda8 on /usr/local type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda9 on /usr/src type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda10 on /misc1 type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdc1 on /local type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/hda1 on /lcrs type ext3 (rw,acl,user_xattr)                      done
Retry device configuration:                                           done
Configuring serial ports...
/dev/ttyS0 at 0x03f8 (irq = 4) is a 16550A
Configured serial ports                                               done
fuse init (API version 7.10)
Loading fuse module                                                   done
Mounting fuse control filesystem                                      done
Setting current sysctl status from /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
fs.inotify.max_user_watches = 65536
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.all.promote_secondaries = 1
                                                                      done
Mounting securityfs on /sys/kernel/security                           done
ls: cannot access /sys/module/apparmor: No such file or directory
ls: cannot access /sys/module/apparmor: No such file or directory
Loading AppArmor module                                               failed
Enabling syn flood protection                                         done
Disabling IP forwarding                                               done
                                                                      done
Activating remaining swap-devices in /etc/fstab...                    done
Creating /var/log/boot.msg                                            done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
scsi 9:0:0:0: Direct-Access     HP       Photosmart 3210  1.00 PQ: 0 ANSI: 2
sd 9:0:0:0: [sdd] Attached SCSI removable disk
sd 9:0:0:0: Attached scsi generic sg3 type 0
Setting up hostname 'harley'                                          done
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
                                                                      done
System Boot Control: The system has been                              set up
Failed features:                                                             boot.apparmor
Skipped features:                                                                boot.cycle
System Boot Control: Running /etc/init.d/boot.local
Linking /usr/src/linix to /usr/src/linux-2.6.28.3-250Hz
No rtom kernel driver found in /lib/modules/2.6.28.3-250Hz/misc
kernel.shmmax = 81943040                                              done
INIT: Entering runlevel: 5
Boot logging started on /dev/ttyS0(/dev/console) at Fri Feb 20 12:29:17 2009
Master Resource Control: previous runlevel: N, switching to runlevel: 5
mkdir: cannot create directory `/dev/cpuset': File exists
mount: cpuset already mounted or /dev/cpuset busy
mount: according to mtab, cpuset is already mounted on /dev/cpuset
Initializing random number generator                                  done
Starting resource manager                                             done
acpid: starting up

Starting acpid                                                        done
acpid: 1 rule loaded

Starting D-Bus daemonStarting syslog services                         done
                                                                      done
Starting ConsoleKit                                                   done
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
Loading CPUFreq modules (CPUFreq not supported)
Starting HAL daemonip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Starting Firewall Initialization (phase 1 of 2)                       done
                                                                      done
Setting up network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8                                 done
    eth0      device: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 13)
    eth0      IP address: 10.10.10.100/24                             done
    eth1      device: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
    eth1      IP address: 192.168.10.100/24                           done
Waiting for mandatory devices:  eth2 eth3 __NSC__
19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
    eth2                                No interface found            failed
    eth3                                No interface found            failed
Setting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .  .  failed
Starting service kdm                                                  done
Mount CIFS File Systems                                               unused
VMware Server is installed, but it has not been (correctly) configured
for the running kernel. To (re-)configure it, invoke the
following command: /usr/bin/vmware-config.pl.

Starting RPC portmap daemon                                           done
Loading Module rfm2g.
=========================================================
COPYRIGHT NOTICE
Copyright (C) 2002, 2004 GE Fanuc Embedded Systems, Inc.
International Copyright Secured.  All Rights Reserved.
=========================================================

cat: /proc/rfm2g: No such file or directory
/etc/init.d/rfm2g_init: line 84: [: 0: unary operator expected
chmod: cannot access `/dev/rfm2g[0-4]': No such file or directory
                                                                      failed
Starting auditd                                                       done
Starting cupsd                                                        done
Starting SSH daemon                                                   done
Starting Avahi daemon.                                                done
Starting Avahi DNS Configuration daemon                               done
Initializing gpib boards
FATAL: Module tnt4882 not found.
failed to open device file '/dev/gpib0'
main: No such file or directory
failed to open device file '/dev/gpib1'
main: No such file or directory
                                                                      failed
Loading keymap i386/qwerty/us.map.gz                                  done
Clearing PCIRMS Sram Memory
prm_clear_sram: prm_mmap_open failed: No such device
PCIRMS Board 0 SRAM Cleared with option local
                                                                      done
Loading compose table latin1.add                                      done
Start Unicode mode                                                    done
Loading console font lat9w-16.psfu  -m trivial G0:loadable            done
ntpd: time set +0.301592s
Starting network time protocol daemon (NTPD)                          done
Starting Name Service Cache Daemon                                    done
Starting mail service (Postfix)                                       done
Starting CRON daemon                                                  done
                                                                      done
Starting Firewall Initialization (phase 2 of 2) SuSEfirewall2: Warning: no default firewall zone defined, assuming 'ext'
                                                                      done
Master Resource Control: runlevel 5 has been                          reached
Failed services in runlevel 5:                                            network vmware gpib rfm2g_init
Skipped services in runlevel 5: smbfs prm prm_dmatest prm_healthy splash

--------------090703050208000406080901--
