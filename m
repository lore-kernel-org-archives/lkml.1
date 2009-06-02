Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZFBN27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZFBN27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZFBN2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:28:52 -0400
Received: from ryu.zarb.org ([212.85.158.22]:39552 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZFBN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:28:50 -0400
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
From: Pascal Terjan <pterjan@mandriva.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>
In-Reply-To: <4A203BFD.7040000@kernel.org>
References: <1243625720.4426.0.camel@plop>  <4A203BFD.7040000@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Tue, 02 Jun 2009 15:28:45 +0200
Message-Id: <1243949325.19053.100.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1-1mdv2009.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 mai 2009 à 12:48 -0700, Yinghai Lu a écrit :
> Pascal Terjan wrote:
> > (Resending because of wrong To:, sorry for the duplicate)
> > 
> > We have a machine here where hard disk is no longer detected at boot
> > time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
> > not on the same one with HIGHMEM64G). 
> > 
> > Motherboard is ECS PF22 Extreme
> > 
> > bisect blames this commit:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
> > 
> 
> boot log with debug please.
> 

Linux version 2.6.29.2 (a@qadev1.mandriva.com) (gcc version 4.3.2
(GCC) ) #6 SMP Fri May 29 17:35:31 CEST 2009
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
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
 BIOS-e820: 000000001ffc0000 - 000000001ffce000 (ACPI data)
 BIOS-e820: 000000001ffce000 - 000000001fff0000 (ACPI NVS)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
debug: ignoring loglevel setting.
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x1ffc0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1ffc0000 @ 10000-15000
RAMDISK: 1fc24000 - 1ffaf26f
ACPI: RSDP 000F8F60, 0014 (r0 ACPIAM)
ACPI: RSDT 1FFC0000, 0038 (r1 A M I  OEMRSDT  11000516 MSFT       97)
ACPI: FACP 1FFC0200, 0084 (r2 A M I  OEMFACP  11000516 MSFT       97)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 1FFC0440, 46B6 (r1     PF    PF022       22 INTL  2002026)
ACPI: FACS 1FFCE000, 0040
ACPI: APIC 1FFC0390, 006C (r1 A M I  OEMAPIC  11000516 MSFT       97)
ACPI: MCFG 1FFC0400, 003C (r1 A M I  OEMMCFG  11000516 MSFT       97)
ACPI: OEMB 1FFCE040, 0046 (r1 A M I  AMI_OEM  11000516 MSFT       97)
ACPI: ASF! 1FFC4B00, 0099 (r32 LEGEND I865PASF        1 INTL  2002026)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
511MB LOWMEM available.
  mapped low ram: 0 - 1ffc0000
  low ram: 00000000 - 1ffc0000
  bootmap 00011000 - 00014ff8
(9 early reservations) ==> bootmem [0000000000 - 001ffc0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 -
0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 -
0000007000]
  #3 [0000100000 - 00006399a4]    TEXT DATA BSS ==> [0000100000 -
00006399a4]
  #4 [001fc24000 - 001ffaf26f]          RAMDISK ==> [001fc24000 -
001ffaf26f]
  #5 [000063a000 - 000063d000]    INIT_PG_TABLE ==> [000063a000 -
000063d000]
  #6 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 -
0000100000]
  #7 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 -
0000011000]
  #8 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 -
0000015000]
found SMP MP-table at [c00ff780] 000ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0001ffc0
  HighMem  0x0001ffc0 -> 0x0001ffc0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0001ffc0
On node 0 totalpages: 130895
free_area_init_node: node 0, pgdat c04eaf80, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 125920 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:dee00000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 40960 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
129871
Kernel command line: BOOT_IMAGE=2.6.29.2
root=UUID=93e4c48e-2222-47da-a3c5-1f7cf113b05e
resume=UUID=227b6318-7827-43c1-93ed-0412eefe016e console=ttyS0,115200
console=tty0 loglevel=8 ignore_loglevel 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Fast TSC calibration using PIT
Detected 3215.689 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 509740k/524032k available (2668k kernel code, 13692k reserved,
1575k data, 444k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe07c0000 - 0xff7fe000   ( 496 MB)
    lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
      .init : 0xc052c000 - 0xc059b000   ( 444 kB)
      .data : 0xc039b065 - 0xc0524f08   (1575 kB)
      .text : 0xc0100000 - 0xc039b065   (2668 kB)
Checking if this processor honours the WP bit even in supervisor
mode...Ok.
SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4,
Nodes=1
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6431.37 BogoMIPS (lpj=3215689)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6429.86 BogoMIPS
(lpj=3214932)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 900283104 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (12861.24 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 1056 bytes
Booting paravirtualized kernel on bare hardware
Time: 15:34:36  Date: 06/02/09
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfebf8000-0xfebfbfff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xe080-0xe09f]
pci 0000:00:1d.1: reg 20 io port: [0xe000-0xe01f]
pci 0000:00:1d.2: reg 20 io port: [0xdc00-0xdc1f]
pci 0000:00:1d.3: reg 20 io port: [0xd880-0xd89f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfebff800-0xfebffbff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 00ff)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:1f.2: reg 10 io port: [0xec00-0xec07]
pci 0000:00:1f.2: reg 14 io port: [0xe880-0xe883]
pci 0000:00:1f.2: reg 18 io port: [0xe800-0xe807]
pci 0000:00:1f.2: reg 1c io port: [0xe480-0xe483]
pci 0000:00:1f.2: reg 20 io port: [0xe400-0xe41f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfebffc00-0xfebfffff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfcffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xdfffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
pci 0000:01:00.0: reg 24 io port: [0x9c00-0x9c7f]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfde80000-0xfdefffff]
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xf7e00000-0xfdefffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xaff00000-0xefefffff]
pci 0000:03:00.0: reg 10 32bit mmio: [0xfe7e0000-0xfe7fffff]
pci 0000:03:00.0: reg 14 32bit mmio: [0xfe000000-0xfe3fffff]
pci 0000:03:00.0: reg 18 io port: [0xac00-0xac1f]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable
it with 'pcie_aspm=force'
pci 0000:00:1c.4: bridge io port: [0xa000-0xafff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfdf00000-0xfe7fffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfe9ffc00-0xfe9ffc7f]
pci 0000:04:00.0: reg 18 64bit mmio: [0xfe9f8000-0xfe9fbfff]
pci 0000:04:00.0: reg 20 io port: [0xbc00-0xbc7f]
pci 0000:04:00.0: reg 30 32bit mmio: [0xfe900000-0xfe97ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable
it with 'pcie_aspm=force'
pci 0000:00:1c.5: bridge io port: [0xb000-0xbfff]
pci 0000:00:1c.5: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
pci 0000:05:04.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
pci 0000:05:04.0: reg 14 io port: [0xcc00-0xcc7f]
pci 0000:05:04.0: supports D2
pci 0000:05:04.0: PME# supported from D2 D3hot D3cold
pci 0000:05:04.0: PME# disabled
pci 0000:05:05.0: reg 10 io port: [0xc800-0xc8ff]
pci 0000:05:05.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff4ff]
pci 0000:05:05.0: reg 30 32bit mmio: [0xfeac0000-0xfeadffff]
pci 0000:05:05.0: supports D1 D2
pci 0000:05:05.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:05:05.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] - F6,
should be F1 [20081204]
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
system 00:07: ioport range 0x200-0x207 has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x800-0x87f has been reserved
system 00:07: ioport range 0x480-0x4bf has been reserved
system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:07: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:09: iomem range 0xffc00000-0xfff7ffff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0c: ioport range 0xa00-0xa0f has been reserved
system 00:0c: ioport range 0x290-0x29f has been reserved
system 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0xc0000-0xcffff could not be reserved
system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
system 00:0f: iomem range 0x100000-0x1fffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xf7e00000-0xfdefffff
pci 0000:00:01.0:   PREFETCH window: 0x000000aff00000-0x000000efefffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: 0xa000-0xafff
pci 0000:00:1c.4:   MEM window: 0xfdf00000-0xfe7fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.5:   IO window: 0xb000-0xbfff
pci 0000:00:1c.5:   MEM window: 0xfe800000-0xfe9fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000030000000-0x000000300fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xf7e00000-0xfdefffff]
pci_bus 0000:01: resource 2 mem: [0xaff00000-0xefefffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 mem: [0x0-0x0]
pci_bus 0000:02: resource 1 mem: [0x0-0x0]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:03: resource 1 mem: [0xfdf00000-0xfe7fffff]
pci_bus 0000:03: resource 2 mem: [0x0-0x0]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:04: resource 1 mem: [0xfe800000-0xfe9fffff]
pci_bus 0000:04: resource 2 mem: [0x0-0x0]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:05: resource 1 mem: [0xfea00000-0xfeafffff]
pci_bus 0000:05: resource 2 mem: [0x30000000-0x300fffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3628k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1243956876.066:1): initialized
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1002
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
isapnp: Scanning for PnP cards...
Clocksource tsc unstable (delta = 279929363 ns)
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Using IPI No-Shortcut mode
input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input0
PM: Resume from partition UUID=227b6318-7827-43c1-93ed-0412eefe016e
PM: Checking hibernation image.
PM: Error -6 checking image file
PM: Resume from disk failed.
registered taskstats version 1
  Magic number: 13:767:587
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 444k freed
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: BAR 5: can't reserve mem region
[0xfebffc00-0xfebfffff]
ahci: probe of 0000:00:1f.2 failed with error -16
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4160B, A302, max UDMA/66
ata1.00: configured for UDMA/66
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4160B A302 PQ: 0
ANSI: 5
ata2: port disabled. ignoring.
sata_sil24 0000:04:00.0: version 1.1
sata_sil24 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sata_sil24 0000:04:00.0: BAR 0: can't reserve mem region
[0xfe9ffc00-0xfe9ffc7f]
sata_sil24 0000:04:00.0: PCI INT A disabled
sata_sil24: probe of 0000:04:00.0 failed with error -16
ohci1394 0000:05:04.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ohci1394: MMIO resource (0xfeaff800 - 0xfeb00000) unavailable
ohci1394: probe of 0000:05:04.0 failed with error -12

