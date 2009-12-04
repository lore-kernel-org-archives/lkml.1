Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZLDXcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZLDXcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbZLDXcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:32:53 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:63446 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755156AbZLDXcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:32:51 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: kernel problem , regressions
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 04 Dec 2009 19:32:52 -0400
Message-ID: <web-102781866@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A next problem with 2.6.32:
/ When before boot one had put in an USB key, fdisk dont 
find / dont show it. Only when, after, one remove it and 
then put it in again, then fdisk find it, as /dev/uba . 
 This is a regression, because, on earlier kernels, fdisk 
after boot also found such USB-keys which were put in 
before the boot started.

dmesg below. This is booting my machine, there is again 
the boot error what I reported for 2.6.32-rc8-gitX on my 
machine and earlier today on 2.6.32 on a friend`s machine.


In the last time, the kernel is becoming unreliable. 
 Plenty laptops get problems which with older kernels 
didn`t occure, often I have to install kernel 2.6.26.X or 
earlier.    During 2.6.27 I reported about a problem with 
eth cards -- the drivers working and ifconfig showing eth0 
etc, but the traffic isn`t passing (nor to the modem 
direktly connected with the card via a cable).   This 
problem meanwhile disappeared almost, but not completely. 
 The most computers work with recent kernels without this 
problem,  but some still have this problem.   It looks 
that the problem entered with 2.6.24, because sometimes I 
had go back and install 2.6.23.12 because of this.

To my opinion, one should test extensively the kernel on 
as many as possible different hardware and laptops, and 
repair these problems.


Werner Landgraf
Linux  SYS

===================
Linux version 2.6.32 (root@werner) (gcc version 4.3.3 
(GCC) ) #1 SMP Fri Dec 4 13:30:31 GFT 2009
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
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 
(reserved)
  BIOS-e820: 00000000000e8000 - 0000000000100000 
(reserved)
  BIOS-e820: 0000000000100000 - 0000000037fb0000 (usable)
  BIOS-e820: 0000000037fb0000 - 0000000037fc0000 (ACPI 
data)
  BIOS-e820: 0000000037fc0000 - 0000000037ff0000 (ACPI 
NVS)
  BIOS-e820: 0000000037ff0000 - 0000000038000000 
(reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 
(reserved)
  BIOS-e820: 00000000fee00000 - 00000000fef00000 
(reserved)
  BIOS-e820: 00000000ff380000 - 0000000100000000 
(reserved)
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working 
around it.
e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
last_pfn = 0x37fb0 max_arch_pfn = 0x1000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-EFFFF uncachable
   F0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 0000000000 mask FFC0000000 write-back
   1 disabled
   2 disabled
   3 disabled
   4 disabled
   5 disabled
   6 disabled
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
Scanning 0 areas for low memory corruption
modified physical RAM map:
  modified: 0000000000000000 - 0000000000010000 (reserved)
  modified: 0000000000010000 - 000000000009fc00 (usable)
  modified: 000000000009fc00 - 00000000000a0000 (reserved)
  modified: 00000000000e8000 - 0000000000100000 (reserved)
  modified: 0000000000100000 - 0000000037fb0000 (usable)
  modified: 0000000037fb0000 - 0000000037fc0000 (ACPI 
data)
  modified: 0000000037fc0000 - 0000000037ff0000 (ACPI NVS)
  modified: 0000000037ff0000 - 0000000038000000 (reserved)
  modified: 00000000fec00000 - 00000000fec01000 (reserved)
  modified: 00000000fee00000 - 00000000fef00000 (reserved)
  modified: 00000000ff380000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 02600000
init_memory_mapping: 0000000000000000-00000000377fe000
NX (Execute Disable) protection: active
  0000000000 - 0000200000 page 4k
  0000200000 - 0037600000 page 2M
  0037600000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-17000
ACPI: RSDP 000fa280 00014 (v00 ACPIAM)
ACPI: RSDT 37fb0000 00034 (v01 A M I  OEMRSDT  11000623 
MSFT 00000097)
ACPI: FACP 37fb0200 00084 (v02 A M I  OEMFACP  11000623 
MSFT 00000097)
ACPI: DSDT 37fb0440 04F1C (v01  8N6GV 8N6GV123 00000123 
INTL 20051117)
ACPI: FACS 37fc0000 00040
ACPI: APIC 37fb0390 00070 (v01 A M I  OEMAPIC  11000623 
MSFT 00000097)
ACPI: MCFG 37fb0400 0003C (v01 A M I  OEMMCFG  11000623 
MSFT 00000097)
ACPI: OEMB 37fc0040 00060 (v01 A M I  AMI_OEM  11000623 
MSFT 00000097)
found SMP MP-table at [c00ff780] ff780
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
MPTABLE: OEM ID: TEMPLATE
MPTABLE: Product ID: ETEMPLATE
MPTABLE: APIC at: 0xFEE00000
Warning! Not a NUMA-Q system!
could not find any ACPI SRAT memory areas.
failed to get NUMA memory information from SRAT table
NUMA - single node, flat memory mode
Node: 0, start_pfn: 0, end_pfn: 37fb0
   Setting physnode_map array to node 0 for pfns:
   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 
28000 2c000 30000 34000
node 0 pfn: [0 - 37fb0]
Reserving 2048 pages of KVA for lmem_map of node 0 at 
37600
remove_active_range (0, 226816, 228864)
Reserving total of 800 pages for numa KVA remap
kva_start_pfn ~ 36e00 max_low_pfn ~ 377fe
max_pfn = 37fb0
7MB HIGHMEM available.
887MB LOWMEM available.
max_low_pfn = 377fe, highstart_pfn = 377fe
Low memory ends at vaddr f77fe000
node 0 will remap to vaddr f6e00000 - f7600000
allocate_pgdat: node 0 NODE_DATA f6e00000
remap_numa_kva: node 0
remap_numa_kva: f6e00000 to pfn 00037600
remap_numa_kva: f7000000 to pfn 00037800
remap_numa_kva: f7200000 to pfn 00037a00
remap_numa_kva: f7400000 to pfn 00037c00
High memory starts at vaddr f77fe000
   mapped low ram: 0 - 377fe000
   low ram: 0 - 377fe000
   node 0 low ram: 00000000 - 377fe000
   node 0 bootmap 00014000 - 0001af00
(10 early reservations) ==> bootmem [0000000000 - 
00377fe000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
   #3 [0001000000 - 0002278ba8]    TEXT DATA BSS ==> 
[0001000000 - 0002278ba8]
   #4 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
   #5 [0002279000 - 000228c127]              BRK ==> 
[0002279000 - 000228c127]
   #6 [0000010000 - 0000014000]          PGTABLE ==> 
[0000010000 - 0000014000]
   #7 [0037600000 - 0037e00000]          KVA RAM ==> 
[0037600000 - 00377fe000]
   #8 [0036e00000 - 0037600000]           KVA PG ==> 
[0036e00000 - 0037600000]
   #9 [0000014000 - 000001b000]          BOOTMAP ==> 
[0000014000 - 000001b000]
found SMP MP-table at [c00ff780] ff780
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   Normal   0x00001000 -> 0x000377fe
   HighMem  0x000377fe -> 0x00037fb0
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
     0: 0x00000010 -> 0x0000009f
     0: 0x00000100 -> 0x00037600
     0: 0x00037e00 -> 0x00037fb0
On node 0 totalpages: 227135
free_area_init_node: node 0, pgdat f6e00000, node_mem_map 
f6e02200
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 3951 pages, LIFO batch:0
   Normal zone: 1744 pages used for memmap
   Normal zone: 220976 pages, LIFO batch:31
   HighMem zone: 16 pages used for memmap
   HighMem zone: 416 pages, LIFO batch:0
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: No APIC-table, disabling MPS
SFI: Simple Firmware Interface v0.7 
http://simplefirmware.org
SMP: Allowing 1 CPUs, 0 hotplug CPUs
APIC: disable apic facility
nr_irqs_gsi: 16
PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 
00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 
0000000000100000
Allocating PCI resources starting at 38000000 (gap: 
38000000:c6c00000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:16
PERCPU: Embedded 14 pages/cpu @c2400000 s34872 r0 d22472 
u2097152
pcpu-alloc: s34872 r0 d22472 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on. 
 Total pages: 225343
Policy zone: HighMem
Kernel command line: BOOT_IMAGE=2632 ro root=301 4 
root=/dev/hda1 devfs=nomount noapic nolapic acpi=ht 
rootwait
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:00037fb0)
Memory: 880448k/917184k available (12293k kernel code, 
30132k reserved, 4617k data, 848k init, 1728k highmem)
virtual kernel memory layout:
     fixmap  : 0xffd55000 - 0xfffff000   (2728 kB)
     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
       .init : 0xc2084000 - 0xc2158000   ( 848 kB)
       .data : 0xc1c014a9 - 0xc2083b00   (4617 kB)
       .text : 0xc1000000 - 0xc1c014a9   (12293 kB)
Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=16
Hierarchical RCU implementation.
NR_IRQS:1280
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1808.403 MHz processor.
Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3616.80 BogoMIPS (lpj=1808403)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
mce: CPU supports 5 MCE banks
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 41k freed
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Mapping cpu 0 to node 0
Apic disabled
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Mapping cpu 0 to node 0
Brought up 1 CPUs
Total of 1 processors activated (3616.80 BogoMIPS).
devtmpfs: initialized
xor: automatically using best checksumming function: 
pIII_sse
    pIII_sse  :  5556.000 MB/sec
xor: using function: pIII_sse (5556.000 MB/sec)
regulator: core version 0.5
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    460 MB/s
raid6: int32x2    625 MB/s
raid6: int32x4    500 MB/s
raid6: int32x8    406 MB/s
raid6: mmxx1     1425 MB/s
raid6: mmxx2     2730 MB/s
raid6: sse1x1    1199 MB/s
raid6: sse1x2    1765 MB/s
raid6: sse2x1    2070 MB/s
raid6: sse2x2    2593 MB/s
raid6: using algorithm sse2x2 (2593 MB/s)
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:01.1: reg 10 io port: [0xec00-0xec3f]
pci 0000:00:01.1: reg 20 io port: [0x5000-0x503f]
pci 0000:00:01.1: reg 24 io port: [0x6000-0x603f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: 
[0xdffff000-0xdfffffff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: 
[0xdfffec00-0xdfffecff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:05.0: reg 10 32bit mmio: 
[0xdfff8000-0xdfffbfff]
pci 0000:00:05.0: PME# supported from D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:07.0: reg 10 32bit mmio: 
[0xdfffd000-0xdfffdfff]
pci 0000:00:07.0: reg 14 io port: [0xe480-0xe487]
pci 0000:00:07.0: supports D1 D2
pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: reg 10 io port: [0xe00-0xe07]
pci 0000:00:08.0: reg 14 io port: [0xe20-0xe23]
pci 0000:00:08.0: reg 18 io port: [0xe40-0xe47]
pci 0000:00:08.0: reg 1c io port: [0xe60-0xe63]
pci 0000:00:08.0: reg 20 io port: [0xd880-0xd88f]
pci 0000:00:08.0: reg 24 32bit mmio: 
[0xdfffc000-0xdfffcfff]
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot 
D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: reg 10 32bit mmio: 
[0xde000000-0xdeffffff]
pci 0000:00:0d.0: reg 14 64bit mmio pref: 
[0xc0000000-0xcfffffff]
pci 0000:00:0d.0: reg 1c 64bit mmio: 
[0xdd000000-0xddffffff]
pci 0000:00:0d.0: reg 30 32bit mmio pref: 
[0xdffc0000-0xdffdffff]
pci 0000:00:04.0: transparent bridge
vgaarb: device added: 
PCI:0000:00:0d.0,decodes=io+mem,owns=io+mem,locks=none
pci 0000:00:01.0: default IRQ router [10de:03e0]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource tsc
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 
0xc00f8cc0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x59aa, dseg 
0xf0000
PnPBIOS: 16 nodes reported by PnP BIOS; 16 recorded by 
driver
system 00:00: iomem range 0x0-0x9fbff could not be 
reserved
system 00:00: iomem range 0x9fc00-0x9ffff could not be 
reserved
system 00:00: iomem range 0xe8000-0xfffff could not be 
reserved
system 00:00: iomem range 0x100000-0x37faffff could not be 
reserved
system 00:00: iomem range 0x37fb0000-0x37fbffff could not 
be reserved
system 00:00: iomem range 0x37fc0000-0x37feffff could not 
be reserved
system 00:00: iomem range 0x37ff0000-0x37ffffff has been 
reserved
system 00:00: iomem range 
0xfffffffffec00000-0xfffffffffec00fff has been reserved
system 00:00: iomem range 
0xfffffffffee00000-0xfffffffffeefffff has been reserved
system 00:00: iomem range 
0xffffffffff380000-0xffffffffffffffff has been reserved
system 00:0a: ioport range 0x290-0x29f has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0xcf8-0xcff could not be 
reserved
system 00:0b: ioport range 0x4400-0x447f has been reserved
system 00:0b: ioport range 0x4480-0x44ff has been reserved
system 00:0b: ioport range 0x4000-0x407f has been reserved
system 00:0b: ioport range 0x4080-0x40ff has been reserved
system 00:0b: ioport range 0x4800-0x487f has been reserved
system 00:0b: ioport range 0x4880-0x48ff has been reserved
system 00:0b: ioport range 0x2000-0x207f has been reserved
system 00:0b: ioport range 0x2080-0x20ff has been reserved
system 00:0b: ioport range 0x5000-0x503f has been reserved
system 00:0b: ioport range 0x6000-0x603f has been reserved
system 00:0b: iomem range 
0xfffffffffefe0000-0xfffffffffefe01ff has been reserved
system 00:0b: iomem range 
0xfffffffffefe1000-0xfffffffffefe1fff has been reserved
system 00:0b: iomem range 
0xfffffffffed00000-0xfffffffffed00fff has been reserved
system 00:0c: iomem range 
0xffffffffe0000000-0xffffffffefffffff has been reserved
pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
pci 0000:00:04.0:   IO window: disabled
pci 0000:00:04.0:   MEM window: disabled
pci 0000:00:04.0:   PREFETCH window: disabled
pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
pci 0000:00:09.0:   IO window: disabled
pci 0000:00:09.0:   MEM window: disabled
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: 
[0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: 
[0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)
TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 
bytes)
TCP: Hash tables configured (established 131072 bind 
65536)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:0d.0: Boot video device
Machine check injector initialized
elanfreq: error: no Elan processor found!
cpufreq-nforce2: No nForce2 chipset.
apm: BIOS version 1.2 Flags 0x02 (Driver version 1.16ac)
scx200: NatSemi SCx200 Driver
microcode: CPU0: AMD CPU family 0xf not supported
Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1259938271.231:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Dec  4 2009 12:32:53) installed
squashfs: version 4.0 (2009/01/31) Phillip Lougher
FS-Cache: Netfs 'nfs' registered for caching
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, 
Inc.
ROMFS MTD (C) 2007 Red Hat, Inc.
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.13)
JFS: nTxBlock = 6878, nTxLock = 55030
SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
OCFS2 1.5.0
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
Btrfs loaded
GFS2 (built Dec  4 2009 12:33:59) installed
msgmni has been set to 1716
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
cpqphp: Compaq Hot Plug PCI Controller Driver version: 
0.9.8
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
pciehp: PCI Express Hot Plug Controller Driver version: 
0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 
0.2
cpcihp_generic: Generic port I/O CompactPCI Hot Plug 
Driver version: 0.1
cpcihp_generic: not configured, disabling.
shpchp: Standard Hot Plug PCI Controller Driver version: 
0.4
mdacon: MDA with 8K of memory detected.
Console: switching consoles 13-16 to MDA-2
nvidiafb: Device ID: 10de03d1
nvidiafb: CRTC0 analog found
nvidiafb: CRTC1 analog not found
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
nvidiafb: MTRR set to ON
fbcon: NV3d (fb0) is primary device
Console: switching to colour frame buffer device 160x64
nvidiafb: PCI nVidia NV3d framebuffer (64MB @ 0xC0000000)
VIA Graphics Intergration Chipset framebuffer 2.4 
initializing
vmlfb: initializing
Could not find Carillo Ranch MCH device.
no IO addresses supplied
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and 
executable
uvesafb: Getting VBE info block failed (eax=0x4f00, 
err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
vesafb: cannot reserve video memory at 0xc0000000
vesafb: framebuffer at 0xc0000000, mapped to 0xfd600000, 
using 6144k, total 131072k
vesafb: mode is 1024x768x32, linelength=4096, pages=1
vesafb: protected mode interface info at c000:d030
vesafb: pmi: set display start = c00cd066, set palette = 
c00cd0d0
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 
3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
fb1: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb2: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
toshiba: not a supported Toshiba laptop
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0f: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:08: reported by Plug and Play BIOS
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
------------[ cut here ]------------
WARNING: at mm/page_alloc.c:1805 
__alloc_pages_nodemask+0x127/0x48f()
Hardware name: To Be Filled By O.E.M.
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.32 #1
Call Trace:
  [<c103d79b>] warn_slowpath_common+0x65/0x95
  [<c103d7dd>] warn_slowpath_null+0x12/0x15
  [<c10958a4>] __alloc_pages_nodemask+0x127/0x48f
  [<c10becf8>] ? get_slab+0x8/0x50
  [<c10b8d0d>] alloc_page_interleave+0x2e/0x6e
  [<c10b8da4>] alloc_pages_current+0x57/0x99
  [<c20bd8fa>] ? xd_init+0x0/0x482
  [<c1094fd0>] __get_free_pages+0xd/0x1e
  [<c20bd944>] xd_init+0x4a/0x482
  [<c20bcca0>] ? loop_init+0x104/0x16a
  [<c1691e85>] ? loop_probe+0x0/0xaf
  [<c20bd8fa>] ? xd_init+0x0/0x482
  [<c1001143>] do_one_initcall+0x51/0x13f
  [<c2084307>] kernel_init+0x10b/0x15f
  [<c20841fc>] ? kernel_init+0x0/0x15f
  [<c1004347>] kernel_thread_helper+0x7/0x10
---[ end trace edf38881bb9b4fcf ]---
xd: Out of memory.
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
MM: desc_per_page = 128
nbd: registered device at major 43
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 
loaded
Phantom Linux Driver, version n0.9.8, init OK
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo 
Giometti
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 
bytes total)
input: Macintosh mouse button emulation as 
/devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 
0xa2)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: not 100% native mode: will probe 
irqs later
     ide0: BM-DMA at 0xffa0-0xffa7
Probing IDE interface ide0...
hda: Maxtor 6L160P0, ATA DISK drive
hdb: HL-DT-STDVD-RAM GH22NP20, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter 
for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 320173056 sectors (163928 MB) w/8192KiB Cache, 
CHS=19929/255/63
hda: cache flushes supported
  hda: hda1 hda2
ide-cd driver 5.00
ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 
2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-870.
rdac: device handler registered
hp_sw: device handler registered
emc: device handler registered
alua: device handler registered
fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2461]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 
loaded
scsi: <fdomain> Detection failed (no card)
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address 
and IRQ using iobase= and irq= options
QLogic Fibre Channel HBA Driver: 8.03.01-k6
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.3.4
Copyright(c) 2004-2009 Emulex.  All rights reserved.
Brocade BFA FC/FCOE SCSI driver - version: 2.0.0.0
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get 
problems load
        with "disable_clustering=1" and report to 
maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
mpt2sas version 02.100.03.00 loaded
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux 
v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux 
v2.26.02.012.
ppa: Version 2.07 (for Linux 2.4.x)
imm: Version 2.05 (for Linux 2.4.0)
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 
(June 10, 2009)
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
stex: Promise SuperTrak EX Driver version: 4.6.0000.3
cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
iscsi: registered transport (cxgb3i)
Broadcom NetXtreme II iSCSI Driver bnx2i v2.0.1e (June 22, 
2009)
iscsi: registered transport (bnx2i)
iscsi: registered transport (be2iscsi)
st: Version 20081215, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp 
$
SCSI Media Changer driver v0.25
osd: LOADED open-osd 0.1.0
sata_nv 0000:00:08.0: version 3.5
sata_nv 0000:00:08.0: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0xe00 ctl 0xe20 bmdma 0xd880 
irq 10
ata2: SATA max UDMA/133 cmd 0xe40 ctl 0xe60 bmdma 0xd888 
irq 10
Error: Driver 'pata_platform' is already registered, 
aborting...
SSFDC read-only Flash Translation layer
L440GX flash mapping: failed to find PIIX4 ISA bridge, 
cannot continue
device id = 2440
device id = 2480
device id = 24c0
device id = 24d0
device id = 25a1
device id = 2670
physmap-flash.0: failed to claim resource 0
SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
Could not find PAR responsible for SC520CDP Flash Bank #0
Trying default address 0x8400000
Could not find PAR responsible for SC520CDP Flash Bank #1
Trying default address 0x8c00000
Could not find PAR responsible for SC520CDP DIL Flash
Trying default address 0x9400000
SC520 CDP flash device: 0x800000 at 0x8400000
Failed to ioremap_nocache
NetSc520 flash device: 0x100000 at 0x200000
Failed to ioremap_nocache
Failed to ioremap_nocache
scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
SNAPGEAR: failed to ioremap() BOOTCS
Generic platform RAM MTD, (c) 2004 Simtec Electronics
No recognised DiskOnChip devices found
slram: not enough parameters.
Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 
Nortel Networks.
pmc551: not detected
ftl_cs: FTL header not found.
No valid DiskOnChip devices found
NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba 
NAND 8MiB 1,8V 8-bit)
flash size: 8 MiB
page size: 512 bytes
OOB area size: 16 bytes
sector size: 8 KiB
pages number: 16384
pages per sector: 16
bus width: 8
bits in sector size: 13
bits in page size: 9
bits in OOB size: 4
flash size with OOB: 8448 KiB
page address bytes: 3
sector address bytes: 2
options: 0x62
Scanning device for bad blocks
Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
0x000000000000-0x000000800000 : "NAND simulator partition 
0"
ftl_cs: FTL header not found.
usbcore: registered new interface driver alauda
OneNAND Manufacturer: Samsung (0xec)
OneNAND 16MB 1.8V 16-bit (0x04)
OneNAND version = 0x001e
Lock scheme is Continuous Lock
Scanning device for bad blocks
Creating 1 MTD partitions on "OneNAND simulator":
0x000000000000-0x000001000000 : "OneNAND simulator 
partition"
ftl_cs: FTL header not found.
Fixed MDIO Bus: probed
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Broadcom NetXtreme II CNIC Driver cnic v2.0.1 (Oct 01, 
2009)
D-Link DE-620 pocket adapter io 0x378, which is busy.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
PPPoL2TP kernel driver, V1.0
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, 
max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of 
California.
SLIP linefill/keepalive option.
DE600: port 0x378 busy
atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.12
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.12
Fusion MPT FC Host driver 3.04.12
Fusion MPT SAS Host driver 3.04.12
Fusion MPT misc device (ioctl) driver 3.04.12
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
Fusion MPT LAN driver 3.04.12
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
aoe: AoE v47 initialised.
paride: aten registered as protocol 0
paride: bpck registered as protocol 1
paride: comm registered as protocol 2
paride: dstr registered as protocol 3
paride: k951 registered as protocol 4
paride: k971 registered as protocol 5
paride: epat registered as protocol 6
paride: epia registered as protocol 7
paride: frpw registered as protocol 8
paride: friq registered as protocol 9
paride: fit2 registered as protocol 10
paride: fit3 registered as protocol 11
paride: on20 registered as protocol 12
paride: on26 registered as protocol 13
paride: ktti registered as protocol 14
bpck6: BACKPACK Protocol Driver V2.0.2
bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. 
USA
paride: bpck6 registered as protocol 15
pd: pd version 1.05, major 45, cluster 64, nice 0
Clocksource tsc unstable (delta = 289885102 ns)
pda: Autoprobe failed
pd: no valid drive found
pcd: pcd version 1.07, major 46, nice 0
pcd0: Autoprobe failed
pcd: No CD-ROM drive found
pf: pf version 1.04, major 47, cluster 64, nice 0
pf: No ATAPI disk detected
pt: pt version 1.04, major 96
pt0: Autoprobe failed
pt: No ATAPI tape drive detected
pg: pg version 1.02, major 97
pga: Autoprobe failed
pg: No ATAPI device detected
Switching to clocksource pit
usbcore: registered new interface driver hwa-rc
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned 
bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not 
supported
ehci_hcd 0000:00:02.1: irq 10, io mem 0xdfffec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, 
idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
driver isp1362-hcd, 2005-04-04
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned 
bus number 2
ohci_hcd 0000:00:02.0: irq 5, io mem 0xdffff000
usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
sl811: driver sl811-hcd, 19 May 2005
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
usbcore: registered new interface driver hwa-hc
usbcore: registered new interface driver wusb-cbaf
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB 
modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver cdc_wdm
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
ata1: SATA link down (SStatus 0 SControl 300)
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: PARKBD AT adapter on parport0
gameport: NS558 PnP Gameport is pnp00:09/gameport0, io 
0x200, speed 755kHz
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
inport.c: Didn't find InPort mouse at 0x23c
logibm.c: Didn't find Logitech busmouse at 0x23c
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet 
Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene 
van Paassen
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006
usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
usbcore: registered new interface driver wacom
wacom: v1.51:USB Wacom Graphire and Wacom Intuos tablet 
driver
input: PC Speaker as /devices/platform/pcspkr/input/input1
i2c /dev entries driver
Linux video capture interface: v2.00
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input2
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) 
initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.1.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
EDAC MC: Ver: 2.1.0 Dec  4 2009
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 2
Cannot allocate resource for EISA slot 4
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA 
Technologies, Inc.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
dell-wmi: No known WMI GUID found
oprofile: using timer interrupt.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 33
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
lib80211_crypt: registered algorithm 'WEP'
lib80211_crypt: registered algorithm 'CCMP'
lib80211_crypt: registered algorithm 'TKIP'
powernow-k8: Found 1 AMD Sempron(tm) Processor 3000+ 
processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x6
Using IPI No-Shortcut mode
ata2: SATA link down (SStatus 0 SControl 300)
usb 1-4: new high speed USB device using ehci_hcd and 
address 4
usb 1-4: New USB device found, idVendor=0951, 
idProduct=1624
usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
usb 1-4: Product: DataTraveler G2
usb 1-4: Manufacturer: Kingston
usb 1-4: SerialNumber: 001D0F0C0807B980D51F0038
usb 1-4: configuration #1 chosen from 1 choice
  uba: uba1
kAFS: Red Hat AFS client v0.1 registering.
raid6test: testing the 4-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) 
 OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P) 
 OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q) 
 OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P) 
 OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q) 
 OK
raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q) 
 OK
raid6test: testing the 5-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) 
 OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D) 
 OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P) 
 OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q) 
 OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D) 
 OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P) 
 OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q) 
 OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P) 
 OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q) 
 OK
raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q) 
 OK
raid6test: testing the 16-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) 
 OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D) 
 OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D) 
 OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D) 
 OK
raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D) 
 OK
raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D) 
 OK
raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D) 
 OK
raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D) 
 OK
raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D) 
 OK
raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D) 
 OK
raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D) 
 OK
raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D) 
 OK
raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D) 
 OK
raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P) 
 OK
raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q) 
 OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D) 
 OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D) 
 OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D) 
 OK
raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D) 
 OK
raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D) 
 OK
raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D) 
 OK
raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D) 
 OK
raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D) 
 OK
raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D) 
 OK
raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D) 
 OK
raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D) 
 OK
raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D) 
 OK
raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P) 
 OK
raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q) 
 OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D) 
 OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D) 
 OK
raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D) 
 OK
raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D) 
 OK
raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D) 
 OK
raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D) 
 OK
raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D) 
 OK
raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D) 
 OK
raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D) 
 OK
raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D) 
 OK
raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D) 
 OK
raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P) 
 OK
raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q) 
 OK
raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D) 
 OK
raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D) 
 OK
raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D) 
 OK
raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D) 
 OK
raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D) 
 OK
raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D) 
 OK
raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D) 
 OK
raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D) 
 OK
raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D) 
 OK
raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D) 
 OK
raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P) 
 OK
raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q) 
 OK
raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D) 
 OK
raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D) 
 OK
raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D) 
 OK
raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D) 
 OK
raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D) 
 OK
raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D) 
 OK
raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D) 
 OK
raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D) 
 OK
raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D) 
 OK
raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P) 
 OK
raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q) 
 OK
raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D) 
 OK
raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D) 
 OK
raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D) 
 OK
raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D) 
 OK
raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D) 
 OK
raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D) 
 OK
raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D) 
 OK
raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D) 
 OK
raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P) 
 OK
raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q) 
 OK
raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D) 
 OK
raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D) 
 OK
raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D) 
 OK
raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D) 
 OK
raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D) 
 OK
raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D) 
 OK
raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D) 
 OK
raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P) 
 OK
raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q) 
 OK
raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D) 
 OK
raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D) 
 OK
raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D) 
 OK
raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D) 
 OK
raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D) 
 OK
raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D) 
 OK
raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P) 
 OK
raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q) 
 OK
raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D) 
 OK
raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D) 
 OK
raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D) 
 OK
raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D) 
 OK
raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D) 
 OK
raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P) 
 OK
raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q) 
 OK
raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D) 
 OK
raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D) 
 OK
raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D) 
 OK
raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D) 
 OK
raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P) 
 OK
raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q) 
 OK
raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D) 
 OK
raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D) 
 OK
raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D) 
 OK
raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P) 
 OK
raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q) 
 OK
raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D) 
 OK
raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D) 
 OK
raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P) 
 OK
raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q) 
 OK
raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D) 
 OK
raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P) 
 OK
raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q) 
 OK
raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P) 
 OK
raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q) 
 OK
raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q) 
 OK
raid6test:
raid6test: complete (136 tests, 0 failures)
register_blkdev: cannot get major 3 for hd
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
md: Waiting for all devices to be available before 
autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 
3:1.
usb 2-1: new low speed USB device using ohci_hcd and 
address 2
devtmpfs: mounted
Freeing unused kernel memory: 848k freed
usb 2-1: New USB device found, idVendor=046d, 
idProduct=c016
usb 2-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
usb 2-1: Product: Optical USB Mouse
usb 2-1: Manufacturer: Logitech
usb 2-1: configuration #1 chosen from 1 choice
input: Logitech Optical USB Mouse as 
/devices/pci0000:00/0000:00:02.0/usb2/2-1/2-1:1.0/input/input3
generic-usb 0003:046D:C016.0001: input,hidraw0: USB HID 
v1.10 Mouse [Logitech Optical USB Mouse] on 
usb-0000:00:02.0-1/input0
usb 2-2: new full speed USB device using ohci_hcd and 
address 3
usb 2-2: New USB device found, idVendor=0c45, 
idProduct=602d
usb 2-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
usb 2-2: Product: USB camera
usb 2-2: configuration #1 chosen from 1 choice
forcedeth: Reverse Engineered nForce ethernet driver. 
Version 0.64.
forcedeth 0000:00:07.0: setting latency timer to 64
forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x732 @ 1, 
addr 00:13:8f:fb:00:56
forcedeth 0000:00:07.0: highdma pwrctl mgmt lnktim msi 
desc-v3
i2c i2c-3: nForce2 SMBus adapter at 0x5000
i2c i2c-4: nForce2 SMBus adapter at 0x6000
gspca: main v2.7.0 registered
gspca: probing 0c45:602d
gspca: probe ok
usbcore: registered new interface driver sonixb
sonixb: registered
HDA Intel 0000:00:05.0: setting latency timer to 64
Driver 'rtc_cmos' needs updating - please use bus_type 
methods
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:05.0/input/input4
EXT3 FS on hda1, internal journal
parport0: no more devices allowed
lp: driver loaded but no devices found
usbcore: registered new interface driver snd-usb-audio
rt2860sta: module is from the staging directory, the 
quality is unknown, you have been warned.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
---
Professional hosting for everyone - http://www.host.ru
