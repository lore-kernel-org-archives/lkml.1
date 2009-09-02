Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZIBOwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZIBOwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZIBOwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:52:41 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:36145 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZIBOwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:52:38 -0400
Date: Wed, 2 Sep 2009 16:52:25 +0200
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
Message-ID: <20090902145225.GA16359@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com> <20090902111927.GA4590@chram.org> <51f3faa70909020742g19007084j19a0ed071aaeffdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa70909020742g19007084j19a0ed071aaeffdf@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Hancock:
: Can you post what particular command you're running to run the SMART
: test, and also the full dmesg output from bootup? Also CCing
: linux-ide.

Sure, I'm using:

	smartctl -t long /dev/sda

to launch the SMART test.

Here's the requested dmesg output:

Linux version 2.6.30.5-pata (ram@tours) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #2 SMP Wed Sep 2 13:04:56 CEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff30000 (usable)
 BIOS-e820: 000000003ff30000 - 000000003ff40000 (ACPI data)
 BIOS-e820: 000000003ff40000 - 000000003fff0000 (ACPI NVS)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x3ff30 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-15000
ACPI: RSDP 000f9e60 00014 (v00 ACPIAM)
ACPI: RSDT 3ff30000 00030 (v01 A M I  OEMRSDT  08000320 MSFT 00000097)
ACPI: FACP 3ff30200 00081 (v02 A M I  OEMFACP  08000320 MSFT 00000097)
ACPI: DSDT 3ff303f0 0382D (v01  P4P81 P4P81086 00000086 INTL 02002026)
ACPI: FACS 3ff40000 00040
ACPI: APIC 3ff30390 0005C (v01 A M I  OEMAPIC  08000320 MSFT 00000097)
ACPI: OEMB 3ff40040 0003F (v01 A M I  OEMBIOS  08000320 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00011000 - 00017f00
(8 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 000047afb4]    TEXT DATA BSS ==> [0000100000 - 000047afb4]
  #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
  #5 [000047b000 - 000047d220]              BRK ==> [000047b000 - 000047d220]
  #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #7 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
found SMP MP-table at [c00ff780] ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003ff30
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003ff30
On node 0 totalpages: 261823
free_area_init_node: node 0, pgdat c03c5a00, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 271 pages used for memmap
  HighMem zone: 34339 pages, LIFO batch:7
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at 50000000 (gap: 40000000:bfb80000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 13 pages at c1805000, static data 29852 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259776
Kernel command line: root=/dev/md0 ro vga=2 clocksource=acpi_pm nmi_watchdog=1 netconsole=11003@192.168.0.3/eth0,11003@192.168.0.1/00:00:b4:bd:4b:b3 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:512
CPU 0 irqstacks, hard=c1805000 soft=c1806000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 2806.244 MHz processor.
Console: colour VGA+ 80x43
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing HighMem for node 0 (000377fe:0003ff30)
Memory: 1034076k/1047744k available (1980k kernel code, 12844k reserved, 955k data, 288k init, 138440k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e4000 - 0xc042c000   ( 288 kB)
      .data : 0xc02ef103 - 0xc03de048   ( 955 kB)
      .text : 0xc0100000 - 0xc02ef103   (1980 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5614.34 BogoMIPS (lpj=9354146)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
APIC timer registered as dummy, due to nmi_watchdog=1!
CPU 1 irqstacks, hard=c1815000 soft=c1816000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5614.26 BogoMIPS (lpj=9354031)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (11229.61 BogoMIPS).
Testing NMI watchdog ... OK.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
net_namespace: 532 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 00, should be F1 [20090320]
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:1d.0: reg 20 io port: [0xef00-0xef1f]
pci 0000:00:1d.1: reg 20 io port: [0xef20-0xef3f]
pci 0000:00:1d.2: reg 20 io port: [0xef40-0xef5f]
pci 0000:00:1d.3: reg 20 io port: [0xef80-0xef9f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfebffc00-0xfebfffff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xfc00-0xfc0f]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:00:1f.5: reg 10 io port: [0xe800-0xe8ff]
pci 0000:00:1f.5: reg 14 io port: [0xee80-0xeebf]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xfebff800-0xfebff9ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xfebff400-0xfebff4ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xf4000000-0xf5ffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfe9fc000-0xfe9fffff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xfe000000-0xfe7fffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfe9e0000-0xfe9effff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfd900000-0xfe9fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xf3f00000-0xf7efffff]
pci 0000:02:05.0: reg 10 32bit mmio: [0xfeafc000-0xfeafffff]
pci 0000:02:05.0: reg 14 io port: [0xd800-0xd8ff]
pci 0000:02:05.0: supports D1 D2
pci 0000:02:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:05.0: PME# disabled
pci 0000:02:09.0: reg 10 io port: [0xdfe0-0xdfe7]
pci 0000:02:09.0: reg 14 io port: [0xdfac-0xdfaf]
pci 0000:02:09.0: reg 18 io port: [0xdfa0-0xdfa7]
pci 0000:02:09.0: reg 1c io port: [0xdfa8-0xdfab]
pci 0000:02:09.0: reg 20 io port: [0xdf90-0xdf9f]
pci 0000:02:09.0: reg 24 32bit mmio: [0xfeaf8000-0xfeafbfff]
pci 0000:02:09.0: reg 30 32bit mmio: [0xfeae0000-0xfeae3fff]
pci 0000:02:09.0: supports D1
pci 0000:02:0a.0: reg 10 io port: [0xd000-0xd0ff]
pci 0000:02:0a.0: reg 14 32bit mmio: [0xfeaf7c00-0xfeaf7cff]
pci 0000:02:0a.0: reg 18 32bit mmio: [0xfeaf6000-0xfeaf6fff]
pci 0000:02:0a.0: reg 30 32bit mmio: [0xfead0000-0xfeadffff]
pci 0000:02:0c.0: reg 10 io port: [0xdf88-0xdf8f]
pci 0000:02:0c.0: reg 14 io port: [0xdf84-0xdf87]
pci 0000:02:0c.0: reg 18 io port: [0xdf68-0xdf6f]
pci 0000:02:0c.0: reg 1c io port: [0xdf80-0xdf83]
pci 0000:02:0c.0: reg 20 io port: [0xdf50-0xdf5f]
pci 0000:02:0c.0: reg 24 32bit mmio: [0xfeaf0000-0xfeaf3fff]
pci 0000:02:0c.0: reg 30 32bit mmio: [0xfeac0000-0xfeac3fff]
pci 0000:02:0c.0: supports D1
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet clockevent registered
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:0b: ioport range 0x680-0x6ff has been reserved
system 00:0b: ioport range 0x290-0x297 has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x800-0x87f has been reserved
system 00:0c: ioport range 0x480-0x4bf has been reserved
system 00:0c: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0c: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xc0000-0xdffff could not be reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:0e: iomem range 0xfff00000-0xffffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfd900000-0xfe9fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f3f00000-0x000000f7efffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 1 mem: [0xfd900000-0xfe9fffff]
pci_bus 0000:01: resource 2 pref mem [0xf3f00000-0xf7efffff]
pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
pci_bus 0000:02: resource 2 pref mem [0x50000000-0x500fffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
NET: Registered protocol family 2
Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
 lapic is not functional.
Could not switch to high resolution mode on CPU 0
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
msgmni has been set to 1750
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1d.3: Performing full reset
pci 0000:01:00.0: Boot video device
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /class/input/input1
ACPI: Power Button [PWRB]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
pata_pdc2027x 0000:02:09.0: version 1.0
pata_pdc2027x 0000:02:09.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pata_pdc2027x 0000:02:09.0: PLL input clock 16689 kHz
scsi2 : pata_pdc2027x
scsi3 : pata_pdc2027x
ata3: PATA max UDMA/100 mmio m16384@0xfeaf8000 cmd 0xfeaf97c0 irq 21
ata4: PATA max UDMA/100 mmio m16384@0xfeaf8000 cmd 0xfeaf95c0 irq 21
pata_pdc2027x 0000:02:0c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ata1.00: ATA-6: HDS722512VLAT80, V33OA60A, max UDMA/100
ata1.00: 241254720 sectors, multi 16: LBA48 
ata1.01: ATAPI: PLEXTOR DVD-ROM PX-116A2            0100, 1.00, max UDMA/66
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      HDS722512VLAT80  V33O PQ: 0 ANSI: 5
scsi 0:0:1:0: CD-ROM            PLEXTOR  DVD-ROM PX-116A2 1.00 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 241254720 512-byte hardware sectors: (123 GB/115 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
pata_pdc2027x 0000:02:0c.0: PLL input clock 16689 kHz
 sda:<6>scsi4 : pata_pdc2027x
scsi5 : pata_pdc2027x
ata5: PATA max UDMA/100 mmio m16384@0xfeaf0000 cmd 0xfeaf17c0 irq 20
ata6: PATA max UDMA/100 mmio m16384@0xfeaf0000 cmd 0xfeaf15c0 irq 20
skge 0000:02:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
skge 1.13 addr 0xfeafc000 irq 22 chip Yukon rev 1
skge eth0: addr 00:0c:6e:ca:0d:7a
netconsole: local port 11003
netconsole: local IP 192.168.0.3
netconsole: interface eth0
netconsole: remote port 11003
netconsole: remote IP 192.168.0.1
netconsole: remote ethernet address 00:00:b4:bd:4b:b3
netconsole: device eth0 not up yet, forcing it
skge eth0: enabling interface
ata3.00: ATA-6: HDS722512VLAT80, V33OA60A, max UDMA/100
ata3.00: 241254720 sectors, multi 16: LBA48 
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
ata3.00: configured for UDMA/100
ata5.00: ATA-7: Maxtor 6Y120L0, YAR41BW0, max UDMA/133
ata5.00: 240121728 sectors, multi 16: LBA 
ata5.00: configured for UDMA/100
ata2.00: ATA-7: Maxtor 6Y120P0, YAR41BW0, max UDMA/133
ata2.00: 240121728 sectors, multi 16: LBA 
ata2.01: ATAPI: TSSTcorpDVD-ROM SH-D162D, SB00, max UDMA/33
ata2.00: configured for UDMA/100
ata2.01: configured for UDMA/33
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6Y120P0   YAR4 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 240121728 512-byte hardware sectors: (122 GB/114 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
 sda1 sda2 <<5>scsi 1:0:1:0: CD-ROM            TSSTcorp DVD-ROM SH-D162D SB00 PQ: 0 ANSI: 5
 sdb:<5>scsi 2:0:0:0: Direct-Access     ATA      HDS722512VLAT80  V33O PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 241254720 512-byte hardware sectors: (123 GB/115 GiB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc:<6>console [netcon0] enabled
netconsole: network logging started
usbmon: debugfs is not available
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
 sdc1 sdc2 <<7>drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000ef00
usb usb1: default language 0x0409
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30.5-pata uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
usb usb1: uevent
 sdb1 sdb2 <<7>usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
 sda5<7>hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ef20
usb usb2: default language 0x0409
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30.5-pata uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ef40
usb usb3: default language 0x0409
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30.5-pata uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000ef80
usb usb4: default language 0x0409
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30.5-pata uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.3
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
 sda6<6>serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
 sdc5<6>mice: PS/2 mouse device common for all mice
md: raid1 personality registered for level 1
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
 sdb5 sdc6 sda7 sdc7 sda8 sdb6 sdc8 sda9 sda10 sdb7<6>input: AT Translated Set 2 keyboard as /class/input/input2
 sda11 sdb8 sda12 sdc9 >
sd 2:0:0:0: [sdc] Attached SCSI disk
 sda13 sdb9 >
sd 1:0:0:0: [sdb] Attached SCSI disk
 sda14 >
sd 0:0:0:0: [sda] Attached SCSI disk
uhci_hcd 0000:00:1d.0: port 2 portsc 009b,00
hub 1-0:1.0: port 2: status 0101 change 0003
uhci_hcd 0000:00:1d.1: port 1 portsc 009b,00
hub 2-0:1.0: port 1: status 0101 change 0003
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
ata4.00: ATA-7: Maxtor 6Y120L0, YAR41VW0, max UDMA/133
ata4.00: 240121728 sectors, multi 16: LBA 
ata4.00: configured for UDMA/100
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6Y120L0   YAR4 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 240121728 512-byte hardware sectors: (122 GB/114 GiB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd:<5>scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6Y120L0   YAR4 PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 240121728 512-byte hardware sectors: (122 GB/114 GiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2 < sdd1 sdd2 < sde5 sde6 sdd5 sde7 sde8 sdd6 sde9 sdd7<7>hub 1-0:1.0: state 7 ports 2 chg 0004 evt 0000
hub 1-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
 sde10 sdd8 >
sd 3:0:0:0: [sdd] Attached SCSI disk
 sde11 sde12 >
sd 4:0:0:0: [sde] Attached SCSI disk
usb 1-2: new full speed USB device using uhci_hcd and address 2
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
usb 1-2: ep0 maxpacket = 8
usb 1-2: default language 0x0409
usb 1-2: New USB device found, idVendor=0a48, idProduct=3259
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: zMate CF
usb 1-2: Manufacturer: Dane-Elec
usb 1-2: uevent
usb 1-2: usb_probe_device
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: adding 1-2:1.0 (config #1, interface 0)
usb 1-2:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
hub 2-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: default language 0x0409
usb 2-1: New USB device found, idVendor=03f0, idProduct=3312
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Officejet J6400 series
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: MY87M4B3D0056D
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1: adding 2-1:1.1 (config #1, interface 1)
usb 2-1:1.1: uevent
usb 2-1: adding 2-1:1.2 (config #1, interface 2)
usb 2-1:1.2: uevent
usb 2-1: adding 2-1:1.3 (config #1, interface 3)
usb 2-1:1.3: uevent
drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
input: ImExPS/2 Logitech Wheel Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: Scanned 2 and added 2 devices.
md: autorun ...
md: considering sde1 ...
md:  adding sde1 ...
md:  adding sda6 ...
md: created md0
md: bind<sda6>
md: bind<sde1>
md: running: <sde1><sda6>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
 md0: unknown partition table
VFS: Mounted root (ext2 filesystem) readonly on device 9:0.
Freeing unused kernel memory: 288k freed
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-2: uevent
usb 1-2:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-1: uevent
usb 2-1:1.0: uevent
usb 2-1:1.1: uevent
usb 2-1:1.2: uevent
usb 2-1:1.3: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 54x/125x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebffc00
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
Initializing USB Mass Storage driver...
usb-storage 1-2:1.0: usb_probe_interface
usb-storage 1-2:1.0: usb_probe_interface - got id
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb5: default language 0x0409
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: EHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30.5-pata ehci_hcd
usb usb5: SerialNumber: 0000:00:1d.7
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 20ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage 2-1:1.3: usb_probe_interface
usb-storage 2-1:1.3: usb_probe_interface - got id
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi7 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
hub 1-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
usb 1-2: USB disconnect, address 2
usb 1-2: unregistering device
usb 1-2: usb_disable_device nuking all URBs
usb 1-2: unregistering interface 1-2:1.0
usb 1-2:1.0: uevent
usb 1-2: uevent
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 5-0:1.0: port 2: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 5-0:1.0: port 3: status 0501 change 0001
intel_rng: FWH not detected
sym53c8xx 0000:02:0a.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
sym0: <875> rev 0x26 at pci 0000:02:0a.0 irq 22
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
usb 2-1: USB disconnect, address 2
usb 2-1: unregistering device
usb 2-1: usb_disable_device nuking all URBs
usb 2-1: unregistering interface 2-1:1.0
usb 2-1:1.0: uevent
usb 2-1: unregistering interface 2-1:1.1
usb 2-1:1.1: uevent
usb 2-1: unregistering interface 2-1:1.2
usb 2-1:1.2: uevent
usb 2-1: unregistering interface 2-1:1.3
usb 2-1:1.3: uevent
usb 2-1: uevent
sym0: Tekram NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi8 : sym-2.2.3
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
hub 5-0:1.0: state 7 ports 8 chg 000c evt 0000
hub 5-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 5-0:1.0: port 2 not reset yet, waiting 50ms
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH 0000:00:1f.5: setting latency timer to 64
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
hub 5-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 3 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 5-3: new high speed USB device using ehci_hcd and address 3
ehci_hcd 0000:00:1d.7: port 3 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 5-3: default language 0x0409
usb 5-3: New USB device found, idVendor=03f0, idProduct=3312
usb 5-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 5-3: Product: Officejet J6400 series
usb 5-3: Manufacturer: HP
usb 5-3: SerialNumber: MY87M4B3D0056D
usb 5-3: uevent
usb 5-3: usb_probe_device
usb 5-3: configuration #1 chosen from 1 choice
usb 5-3: adding 5-3:1.0 (config #1, interface 0)
usb 5-3:1.0: uevent
usb 5-3: adding 5-3:1.1 (config #1, interface 1)
usb 5-3:1.1: uevent
usb 5-3: adding 5-3:1.2 (config #1, interface 2)
usb 5-3:1.2: uevent
usb 5-3: adding 5-3:1.3 (config #1, interface 3)
usb 5-3:1.3: uevent
usb-storage 5-3:1.3: usb_probe_interface
usb-storage 5-3:1.3: usb_probe_interface - got id
scsi9 : SCSI emulation for USB Mass Storage devices
drivers/usb/core/inode.c: creating file '003'
hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
hub 1-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
intel8x0: white list rate for 1043:80f3 is 48000
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: ep0 maxpacket = 8
usb 1-2: default language 0x0409
usb 1-2: New USB device found, idVendor=0a48, idProduct=3259
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: zMate CF
usb 1-2: Manufacturer: Dane-Elec
usb 1-2: uevent
usb 1-2: usb_probe_device
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: adding 1-2:1.0 (config #1, interface 0)
usb 1-2:1.0: uevent
usb-storage 1-2:1.0: usb_probe_interface
usb-storage 1-2:1.0: usb_probe_interface - got id
scsi10 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '003'
usb usb2: suspend_rh (auto-stop)
ata2.01: qc timeout (cmd 0xa0)
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/20:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata2.01: status: { DRDY ERR }
scsi 8:0:4:0: CD-ROM            PIONEER  DVD-ROM DVD-305  1.03 PQ: 0 ANSI: 2
 target8:0:4: Beginning Domain Validation
 target8:0:4: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target8:0:4: Domain Validation skipping write tests
 target8:0:4: Ending Domain Validation
scsi 9:0:0:0: Direct-Access     HP       Officejet J6400  1.00 PQ: 0 ANSI: 5
usb-storage: device scan complete
sd 9:0:0:0: [sdf] Attached SCSI removable disk
scsi 10:0:0:0: Direct-Access     DaneElec zMate USB to CF  0100 PQ: 0 ANSI: 0
sd 10:0:0:0: [sdg] Attached SCSI removable disk
usb-storage: device scan complete
ata2: link is slow to respond, please be patient (ready=0)
ata2: device not ready (errno=-16), forcing hardreset
ata2: soft resetting link
ata2.00: configured for UDMA/100
ata2.01: configured for UDMA/33
ata2: EH complete
sdb: detected capacity change from 0 to 122942324736
sdb: detected capacity change from 0 to 122942324736
sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
sr2: scsi3-mmc drive: 16x/40x cd/rw xa/form2 cdda tray
sr 8:0:4:0: Attached scsi CD-ROM sr2
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 0:0:1:0: Attached scsi generic sg1 type 5
sd 1:0:0:0: Attached scsi generic sg2 type 0
sr 1:0:1:0: Attached scsi generic sg3 type 5
sd 2:0:0:0: Attached scsi generic sg4 type 0
sd 3:0:0:0: Attached scsi generic sg5 type 0
sd 4:0:0:0: Attached scsi generic sg6 type 0
sr 8:0:4:0: Attached scsi generic sg7 type 5
sd 9:0:0:0: Attached scsi generic sg8 type 0
sd 10:0:0:0: Attached scsi generic sg9 type 0
Adding 538136k swap on /dev/sdc9.  Priority:8 extents:1 across:538136k 
Adding 538232k swap on /dev/sde11.  Priority:8 extents:1 across:538232k 
Adding 257000k swap on /dev/sda5.  Priority:8 extents:1 across:257000k 
Adding 257000k swap on /dev/sda9.  Priority:7 extents:1 across:257000k 
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
w83627hf: Found W83627THF chip at 0x290
w83627hf w83627hf.656: Reading VID from GPIO5
md: md8 stopped.
md: bind<sda12>
md: bind<sdd1>
md: bind<sdc1>
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  3681.600 MB/sec
xor: using function: pIII_sse (3681.600 MB/sec)
async_tx: api initialized (async)
raid6: int32x1    753 MB/s
raid6: int32x2    789 MB/s
raid6: int32x4    734 MB/s
raid6: int32x8    488 MB/s
raid6: mmxx1     1961 MB/s
raid6: mmxx2     2314 MB/s
raid6: sse1x1    1215 MB/s
raid6: sse1x2    1832 MB/s
raid6: sse2x1    2159 MB/s
raid6: sse2x2    2818 MB/s
raid6: using algorithm sse2x2 (2818 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sdc1 operational as raid disk 0
raid5: device sdd1 operational as raid disk 2
raid5: device sda12 operational as raid disk 1
raid5: allocated 3168kB for md8
raid5: raid level 5 set md8 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sda12
 disk 2, o:1, dev:sdd1
 md8: unknown partition table
md: md5 stopped.
md: bind<sdc5>
md: bind<sdd5>
md: bind<sdb6>
raid5: device sdb6 operational as raid disk 0
raid5: device sdd5 operational as raid disk 2
raid5: device sdc5 operational as raid disk 1
raid5: allocated 3168kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb6
 disk 1, o:1, dev:sdc5
 disk 2, o:1, dev:sdd5
 md5: unknown partition table
md: md6 stopped.
md: bind<sdc6>
md: bind<sdd6>
md: bind<sdb7>
raid5: device sdb7 operational as raid disk 0
raid5: device sdd6 operational as raid disk 2
raid5: device sdc6 operational as raid disk 1
raid5: allocated 3168kB for md6
raid5: raid level 5 set md6 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb7
 disk 1, o:1, dev:sdc6
 disk 2, o:1, dev:sdd6
 md6: unknown partition table
md: md7 stopped.
md: bind<sdc7>
md: bind<sdd7>
md: bind<sdb8>
raid5: device sdb8 operational as raid disk 0
raid5: device sdd7 operational as raid disk 2
raid5: device sdc7 operational as raid disk 1
raid5: allocated 3168kB for md7
raid5: raid level 5 set md7 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb8
 disk 1, o:1, dev:sdc7
 disk 2, o:1, dev:sdd7
 md7: unknown partition table
md: md9 stopped.
md: bind<sdc8>
md: bind<sdd8>
md: bind<sda13>
md: bind<sde10>
md: bind<sdb9>
md: md9: raid array is not clean -- starting background reconstruction
raid5: device sdb9 operational as raid disk 0
raid5: device sda13 operational as raid disk 3
raid5: device sdd8 operational as raid disk 2
raid5: device sdc8 operational as raid disk 1
raid5: allocated 4209kB for md9
raid5: raid level 5 set md9 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdb9
 disk 1, o:1, dev:sdc8
 disk 2, o:1, dev:sdd8
 disk 3, o:1, dev:sda13
 md9: unknown partition table
md: resync of RAID array md9
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 101032640 blocks.
md: md1 stopped.
md: bind<sda7>
md: bind<sde5>
md: md1: raid array is not clean -- starting background reconstruction
raid1: raid set md1 active with 2 out of 2 mirrors
md: delaying resync of md1 until md9 has finished (they share one or more physical units)
 md1: unknown partition table
md: md2 stopped.
md: bind<sda8>
md: bind<sde6>
md: md2: raid array is not clean -- starting background reconstruction
raid1: raid set md2 active with 2 out of 2 mirrors
md: delaying resync of md2 until md1 has finished (they share one or more physical units)
md2: detected capacity change from 0 to 501088256
 md2: unknown partition table
md: md3 stopped.
md: bind<sda10>
md: bind<sdb1>
md: bind<sde7>
md: md3: raid array is not clean -- starting background reconstruction
raid5: device sde7 operational as raid disk 0
raid5: device sdb1 operational as raid disk 2
raid5: device sda10 operational as raid disk 1
raid5: allocated 3168kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sde7
 disk 1, o:1, dev:sda10
 disk 2, o:1, dev:sdb1
md: delaying resync of md3 until md2 has finished (they share one or more physical units)
md3: detected capacity change from 0 to 7484735488
 md3: unknown partition table
md: md4 stopped.
md: bind<sda11>
md: bind<sdb5>
md: bind<sde8>
raid5: device sde8 operational as raid disk 0
raid5: device sdb5 operational as raid disk 2
raid5: device sda11 operational as raid disk 1
raid5: allocated 3168kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sde8
 disk 1, o:1, dev:sda11
 disk 2, o:1, dev:sdb5
md4: detected capacity change from 0 to 7484735488
 md4: unknown partition table
md: md10 stopped.
md: bind<sde9>
md: bind<sda14>
raid1: raid set md10 active with 2 out of 2 mirrors
md10: detected capacity change from 0 to 2294743040
 md10: unknown partition table
fuse init (API version 7.11)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md10, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md9, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
md: md9: resync done.
md: delaying resync of md3 until md2 has finished (they share one or more physical units)
md: delaying resync of md1 until md3 has finished (they share one or more physical units)
md: delaying resync of md2 until md3 has finished (they share one or more physical units)
md: delaying resync of md1 until md3 has finished (they share one or more physical units)
md: resync of RAID array md3
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 3654656 blocks.
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdb9
 disk 1, o:1, dev:sdc8
 disk 2, o:1, dev:sdd8
 disk 3, o:1, dev:sda13
md: md3: resync done.
md: resync of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 489344 blocks.
md: delaying resync of md1 until md2 has finished (they share one or more physical units)
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sde7
 disk 1, o:1, dev:sda10
 disk 2, o:1, dev:sdb1
md: md2: resync done.
md: resync of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 1082240 blocks.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sde6
 disk 1, wo:0, o:1, dev:sda8
md: md1: resync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sde5
 disk 1, wo:0, o:1, dev:sda7

Raphael
