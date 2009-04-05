Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZDEV20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZDEV20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 17:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZDEV2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 17:28:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47296 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZDEV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 17:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=MQvwj++Qmn8pwFNZmzNVeeBDUiKV77AhNzXQMz2C/pPG0NYpfn/cqAGx34tRCLich2
         SSxFnIgXy3l1BgJN9pFmD+LwIR7Z6axZj0p+BI4jGX2DkIS9F4bVERC8fBm51mA1AuDn
         Xc7fK9SgmwC9ZKISFktsdoCmjDYBimgxX3kNE=
Date: Sun, 5 Apr 2009 23:43:36 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ACPI on asus eeepc 701 (v2.6.28-29)
Message-Id: <20090405234336.8e404824.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Been getting this on v2.6.28 and v2.6.29, havent
confirmed it yet for vanilla(going to). Just wanted
to see if this is something people has seen so
I dont spend time fixing it.

Its the "standard" kernel from archlinux and it appeard
for me in 2.6.28.8 (archlinux that is). 

Best wishes
Kristoffer 


BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-ARCH (root@T-POWA-LX) (gcc version 4.3.3 (GCC) ) #1 SMP PREEMPT Sun Jan 25 10:13:11 UTC 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f780000 (usable)
 BIOS-e820: 000000007f780000 - 000000007f790000 (ACPI data)
 BIOS-e820: 000000007f790000 - 000000007f7d0000 (ACPI NVS)
 BIOS-e820: 000000007f7d0000 - 000000007f7de000 (reserved)
 BIOS-e820: 000000007f7e0000 - 000000007f800000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x7f780 max_arch_pfn = 0x100000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009fc00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e4000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000007f780000 (usable)
 modified: 000000007f780000 - 000000007f790000 (ACPI data)
 modified: 000000007f790000 - 000000007f7d0000 (ACPI NVS)
 modified: 000000007f7d0000 - 000000007f7de000 (reserved)
 modified: 000000007f7e0000 - 000000007f800000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000fff80000 - 0000000100000000 (reserved)
kernel direct mapping tables up to 377fe000 @ 10000-16000
RAMDISK: 00e36000 - 00effa71
ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
ACPI: RSDT 7F780000, 0034 (r1 A M I  OEMRSDT   3000803 MSFT       97)
ACPI: FACP 7F780200, 0081 (r1 A M I  OEMFACP   3000803 MSFT       97)
ACPI: DSDT 7F780400, 5F61 (r1  A0797 A0797000        0 INTL 20051117)
ACPI: FACS 7F790000, 0040
ACPI: APIC 7F780390, 0068 (r1 A M I  OEMAPIC   3000803 MSFT       97)
ACPI: OEMB 7F790040, 0046 (r1 A M I  AMI_OEM   3000803 MSFT       97)
ACPI: MCFG 7F786370, 003C (r1 A M I  OEMMCFG   3000803 MSFT       97)
ACPI: Local APIC address 0xfee00000
1151MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 000055b520]    TEXT DATA BSS ==> [0000100000 - 000055b520]
  #4 [0000e36000 - 0000effa71]          RAMDISK ==> [0000e36000 - 0000effa71]
  #5 [000055c000 - 000055f000]    INIT_PG_TABLE ==> [000055c000 - 000055f000]
  #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #7 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
found SMP MP-table at [c00ff780] 000ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007f780
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007f780
On node 0 totalpages: 521999
free_area_init_node: node 0, pgdat c0405580, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2304 pages used for memmap
  HighMem zone: 292482 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7f800000:7f600000)
PERCPU: Allocating 36864 bytes of per cpu data
NR_CPUS: 16, nr_cpu_ids: 1, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517919
Kernel command line: BOOT_IMAGE=safe_ext ro root=821
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 630.113 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Scanning for low memory corruption every 60 seconds
Memory: 2064636k/2088448k available (2227k kernel code, 22500k reserved, 1023k data, 332k init, 1179144k highmem)
virtual kernel memory layout:
    fixmap  : 0xffee8000 - 0xfffff000   (1116 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0433000 - 0xc0486000   ( 332 kB)
      .data : 0xc032cdf9 - 0xc042cb5c   (1023 kB)
      .text : 0xc0100000 - 0xc032cdf9   (2227 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.73 BogoMIPS (lpj=2100376)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 9k freed
ACPI: Core revision 20080926
ACPI: Checking initramfs for custom DSDT
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Celeron(R) M processor          900MHz stepping 08
Brought up 1 CPUs
Total of 1 processors activated (1260.73 BogoMIPS).
net_namespace: 768 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
pci 0000:00:1e.0: transparent bridge
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
system 00:08: ioport range 0x380-0x383 has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x800-0x87f has been reserved
system 00:08: ioport range 0x480-0x4bf has been reserved
system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0x7f7fffff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.2:   IO window: disabled
pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 04 index 0 mmio: [0x0-0x0]
bus: 04 index 1 mmio: [0x0-0x0]
bus: 04 index 2 mmio: [0x0-0x0]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 03 index 0 mmio: [0x0-0x0]
bus: 03 index 1 mmio: [0xfbf00000-0xfbffffff]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xf8000000-0xfbefffff]
bus: 01 index 2 mmio: [0xf0000000-0xf6ffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 05 index 0 mmio: [0x0-0x0]
bus: 05 index 1 mmio: [0x0-0x0]
bus: 05 index 2 mmio: [0x0-0x0]
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
Freeing initrd memory: 806k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1732
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 767 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pcieport-driver 0000:00:1c.1: irq 766 for MSI/MSI-X
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pcieport-driver 0000:00:1c.2: irq 765 for MSI/MSI-X
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 332k freed
input: AT Translated Set 2 keyboard as /class/input/input1
SCSI subsystem initialized
libata version 3.00 loaded.
pata_acpi 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pata_acpi 0000:00:1f.2: setting latency timer to 64
pata_acpi 0000:00:1f.2: PCI INT B disabled
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: PCI INT B disabled
ahci: probe of 0000:00:1f.2 failed with error -22
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
ata2.00: 7815024 sectors, multi 0: LBA 
ata2.00: configured for UDMA/66
scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 3
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb 1-5: configuration #1 chosen from 1 choice
usb 1-8: new high speed USB device using ehci_hcd and address 5
usb 1-8: configuration #1 chosen from 1 choice
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usb 1-3.1: new high speed USB device using ehci_hcd and address 6
Driver 'sd' needs updating - please use bus_type methods
sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 1:0:0:0: [sda] Attached SCSI disk
usb 1-3.1: configuration #1 chosen from 1 choice
usb 1-3.2: new low speed USB device using ehci_hcd and address 7
usb 1-3.2: configuration #1 chosen from 1 choice
usb 1-3.4: new low speed USB device using ehci_hcd and address 8
usb 1-3.4: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb-storage: probe of 2-2:1.0 failed with error -5
usb-storage: probe of 2-2:1.1 failed with error -5
usb-storage: probe of 2-2:1.2 failed with error -1
scsi6 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver hiddev
input: HID 04d9:1203 as /class/input/input2
generic-usb 0003:04D9:1203.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 04d9:1203] on usb-0000:00:1d.7-3.2/input0
input: HID 04d9:1203 as /class/input/input3
generic-usb 0003:04D9:1203.0002: input,hidraw1: USB HID v1.11 Device [HID 04d9:1203] on usb-0000:00:1d.7-3.2/input1
input: B16_b_02 USB-PS/2 Optical Mouse as /class/input/input4
generic-usb 0003:046D:C025.0003: input,hidraw2: USB HID v1.10 Mouse [B16_b_02 USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-3.4/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
scsi 6:0:0:0: Direct-Access     WD       10EAVS External  1.05 PQ: 0 ANSI: 4
sd 6:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 6:0:0:0: [sdc] Assuming drive cache: write through
sd 6:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 6:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2
sd 6:0:0:0: [sdc] Attached SCSI disk
usb-storage: device scan complete
sd 2:0:0:0: [sdb] 15954944 512-byte hardware sectors: (8.16 GB/7.60 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 15954944 512-byte hardware sectors: (8.16 GB/7.60 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
usb-storage: device scan complete
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
udev: starting version 140
udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
atl2 0000:03:00.0: setting latency timer to 64
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:01:00.0: setting latency timer to 64
ath5k_pci 0000:01:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
ath_hal: module license 'Proprietary' taints kernel.
AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
ACPI: AC Adapter [AC0] (on-line)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input7
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input8
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (62 C)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 915GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
eeepc: Eee PC Hotkey Driver
eeepc: Hotkey init flags 0x41
eeepc: Get control methods supported: 0x101711
input: Asus EeePC extra buttons as /class/input/input9
input: Video Bus as /class/input/input10
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for GSM modem (1-port)
option 2-2:1.0: GSM modem (1-port) converter detected
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
option 2-2:1.1: GSM modem (1-port) converter detected
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
intel_rng: FWH not detected
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 6:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
input: UVC Camera (eb1a:2761) as /class/input/input11
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
ACPI: Device needs an ACPI driver
input: PC Speaker as /class/input/input12
Error: Driver 'pcspkr' is already registered, aborting...
Error: Driver 'pcspkr' is already registered, aborting...
Marking TSC unstable due to TSC halts in idle
Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
input: SynPS/2 Synaptics TouchPad as /class/input/input13
Clocksource tsc unstable (delta = -65800588 ns)
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/i8042/modalias
Modules linked in: joydev snd_pcsp psmouse i2c_i801 serio_raw i2c_core uvcvideo compat_ioctl32 videodev v4l1_compat sg iTCO_wdt iTCO_vendor_support option usbserial video output eeepc_laptop rfkill intel_agp agpgart thermal processor fan evdev button battery ac snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ath_pci wlan ath_hal(P) arc4 ecb ath5k mac80211 led_class cfg80211 atl2 rtc_cmos rtc_core rtc_lib ext3 jbd mbcache usbhid hid usb_storage sd_mod uhci_hcd ehci_hcd usbcore ata_piix ahci ata_generic pata_acpi libata scsi_mod

Pid: 1827, comm: fsck.ext3 Tainted: P           (2.6.28-ARCH #1) 701
EIP: 0060:[<f850d031>] EFLAGS: 00010246 CPU: 0
EIP is at acpi_ac_get_state+0x1b/0x59 [ac]
EAX: f6869bdc EBX: 00000000 ECX: 00000000 EDX: f850d418
ESI: f6869b80 EDI: 00000001 EBP: f68fac00 ESP: f6805f0c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process fsck.ext3 (pid: 1827, ti=f6804000 task=f686cc00 task.ti=f6804000)
Stack:
 f6869bdc f6869b80 f68d7360 f850d2fd 00000001 f68d7360 c01ab0e0 00000400
 b805e000 f68fac00 f68d7380 00000000 00000000 00000001 00000000 00000000
 f7323900 fffffffb c01aafb0 f68fac00 c01cead4 f6805fa0 00000400 b805e000
Call Trace:
 [<f850d2fd>] acpi_ac_seq_show+0x12/0x5d [ac]
 [<c01ab0e0>] seq_read+0x130/0x2e0
 [<c01aafb0>] seq_read+0x0/0x2e0
 [<c01cead4>] proc_reg_read+0x64/0xa0
 [<c01cea70>] proc_reg_read+0x0/0xa0
 [<c019346d>] vfs_read+0x9d/0x160
 [<c0193601>] sys_read+0x41/0x80
 [<c0103f13>] sysenter_do_call+0x12/0x33
 [<c0320000>] serial_pnp_probe+0x150/0x250
Code: b8 ea ff ff ff 75 07 8b 43 5c 89 01 31 c0 5b c3 56 89 c6 85 f6 b8 ea ff ff ff 53 74 49 8b 5e 58 8d 46 5c 31 c9 50 ba 18 d4 50 f8 <8b> 03 e8 e0 be d2 c7 89 c2 58 31 c0 85 d2 74 2b 68 1d d4 50 f8 
EIP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac] SS:ESP 0068:f6805f0c
---[ end trace afc201c038e23db4 ]---
EXT3 FS on sdc1, internal journal
Adding 49022336k swap on /dev/sdc2.  Priority:-1 extents:1 across:49022336k
warning: `syslog-ng' uses 32-bit capabilities (legacy support in use)
atl2 0000:03:00.0: irq 764 for MSI/MSI-X
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[drm] Initialized i915 1.6.0 20080730 on minor 0
mtrr: no MTRR for d0000000,10000000 found
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
mtrr: no MTRR for d0000000,10000000 found
mtrr: no MTRR for d0000000,10000000 found
mtrr: no MTRR for d0000000,10000000 found
ipv6: Unknown symbol xfrm_audit_state_notfound_simple
ipv6: Unknown symbol xfrm_audit_state_notfound_simple


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
