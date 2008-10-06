Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYJFT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYJFT2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYJFT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:28:08 -0400
Received: from ns.pirn.net ([194.126.99.226]:56757 "EHLO ares.softexpert.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYJFT2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:28:05 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 15:28:03 EDT
Date: Mon, 6 Oct 2008 22:19:23 +0300 (EEST)
From: =?ISO-8859-1?Q?Reigo_K=FCngas?= <reigo@itx.ee>
X-X-Sender: reigo@ares.softexpert.eu
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: linksys USB1000linksys, asix driver (2.6.26.5)
Message-ID: <Pine.LNX.4.64.0810062130180.23753@ares.softexpert.eu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="2126701155-772943858-1223320763=:23753"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--2126701155-772943858-1223320763=:23753
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi,

I have problem with linksys usb1000 gigabit network adapter - interface is 
stop working after random period. Reloading asix driver will restore 
interface work.

Same behaiviour in 2 servers - one running 2.6.26 kernel and second 
2.6.26.5 kernel both has similar hardware and same usb gigabit network 
adapter and similar problems.

dmesg output below - please let me know if you need more information.

Linux version 2.6.26.5 (root@keep.nagi.ee) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Tue Sep 16 09:58:33 EEST 2008
Command line: ro root=/dev/sda1
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
  BIOS-e820: 00000000bfff0000 - 00000000bfffe000 (ACPI data)
  BIOS-e820: 00000000bfffe000 - 00000000c0000000 (ACPI NVS)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 786416) 1 entries of 256 used
Entering add_active_range(0, 1048576, 4456448) 2 entries of 256 used
max_pfn_mapped = 4456448
init_memory_mapping
DMI 2.3 present.
ACPI: RSDP 000F83F0, 0024 (r2 ACPIAM)
ACPI: XSDT BFFF0100, 0044 (r1 070408 XSDT1803 20080704 MSFT       97)
ACPI: FACP BFFF0290, 00F4 (r3 070408 FACP1803 20080704 MSFT       97)
ACPI: DSDT BFFF04A0, 36D7 (r1  0AAAB 0AAAB001        1 INTL  2002026)
ACPI: FACS BFFFE000, 0040
ACPI: APIC BFFF0390, 00CA (r1 070408 APIC1803 20080704 MSFT       97)
ACPI: OEMB BFFFE040, 0056 (r1 070408 OEMB1803 20080704 MSFT       97)
ACPI: SRAT BFFF3B80, 0110 (r1 AMD    HAMMER          1 AMD         1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 786416) 1 entries of 256 used
Entering add_active_range(0, 1048576, 4456448) 2 entries of 256 used
   early res: 0 [0-fff] BIOS data page
   early res: 1 [6000-7fff] TRAMPOLINE
   early res: 2 [200000-69fd2b] TEXT DATA BSS
   early res: 3 [37d55000-37fefb40] RAMDISK
   early res: 4 [9f400-fffff] BIOS reserved
   early res: 5 [8000-19fff] PGTABLE
  [ffffe20000000000-ffffe2000edfffff] PMD -> [ffff81000c200000-ffff81001affffff] on node 0
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  4456448
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
     0:        0 ->      159
     0:      256 ->   786416
     0:  1048576 ->  4456448
On node 0 totalpages: 4194191
   DMA zone: 56 pages used for memmap
   DMA zone: 1302 pages reserved
   DMA zone: 2641 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 768040 pages, LIFO batch:31
   Normal zone: 46592 pages used for memmap
   Normal zone: 3361280 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 5, version 0, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 6, version 0, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
SMP: Allowing 8 CPUs, 4 hotplug CPUs
PERCPU: Allocating 34672 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 8
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4131961
Kernel command line: ro root=/dev/sda1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2393.999 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Checking aperture...
Node 0: aperture @ c0000000 size 128 MB
Node 1: aperture @ c0000000 size 128 MB
Memory: 16499616k/17825792k available (2415k kernel code, 276408k reserved, 1402k data, 228k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Calibrating delay using timer specific routine.. 4790.19 BogoMIPS (lpj=2395095)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080321
CPU0: Dual-Core AMD Opteron(tm) Processor 2216 stepping 03
Using local APIC timer interrupts.
APIC timer calibration result 12468752
Detected 12.468 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4799.77 BogoMIPS (lpj=2399887)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Dual-Core AMD Opteron(tm) Processor 2216 stepping 03
Booting processor 2/2 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4787.83 BogoMIPS (lpj=2393915)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU2: Dual-Core AMD Opteron(tm) Processor 2216 stepping 03
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4787.79 BogoMIPS (lpj=2393897)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 2216 stepping 03
Brought up 4 CPUs
Total of 4 processors activated (19165.58 BogoMIPS).
CPU0 attaching sched-domain:
  domain 0: span 0-3
   groups: 0 1 2 3
CPU1 attaching sched-domain:
  domain 0: span 0-3
   groups: 1 2 3 0
CPU2 attaching sched-domain:
  domain 0: span 0-3
   groups: 2 3 0 1
CPU3 attaching sched-domain:
  domain 0: span 0-3
   groups: 3 0 1 2
net_namespace: 1224 bytes
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, ff70ffff]
TOM2: 0000000440000000 aka 17408M
bus: [00,07] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [c0000000, ffffffff]
bus: 00 index 3 mmio: [440000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: Enabling HT MSI Mapping
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR28._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR32._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR3C._PRT]
ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN10] (IRQs 1 *3 4 5 6 7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 *7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
ACPI: PCI Interrupt Link [LNSA] (IRQs 11) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c0000000 size 131072 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 128MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
system 00:06: ioport range 0x800-0x87f has been reserved
system 00:06: ioport range 0xa80-0xa8f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0xc00-0xc01 has been reserved
system 00:07: ioport range 0xcd6-0xcd7 has been reserved
system 00:07: ioport range 0xcd4-0xcd5 has been reserved
system 00:07: ioport range 0xcd8-0xcdf has been reserved
system 00:07: ioport range 0x40b-0x40b has been reserved
system 00:07: ioport range 0x4d6-0x4d6 has been reserved
system 00:07: ioport range 0xc06-0xc07 has been reserved
system 00:07: ioport range 0xc14-0xc14 has been reserved
system 00:07: ioport range 0xc49-0xc49 has been reserved
system 00:07: ioport range 0xc4a-0xc4a has been reserved
system 00:07: ioport range 0xc50-0xc51 has been reserved
system 00:07: ioport range 0xc52-0xc52 has been reserved
system 00:07: ioport range 0xc6c-0xc6c has been reserved
system 00:07: ioport range 0xc6f-0xc6f has been reserved
system 00:07: ioport range 0x500-0x57f has been reserved
system 00:09: ioport range 0x580-0x58f has been reserved
system 00:09: ioport range 0x590-0x593 has been reserved
system 00:09: ioport range 0x700-0x703 has been reserved
system 00:09: ioport range 0xca0-0xcaf has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:09: iomem range 0xfec01000-0xfec01fff could not be reserved
system 00:09: iomem range 0xfec02000-0xfec02fff could not be reserved
system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
system 00:09: iomem range 0xff780000-0xffbfffff has been reserved
system 00:09: iomem range 0xfebfe000-0xfebfefff has been reserved
system 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0x0-0x9ffff could not be reserved
system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
system 00:0b: iomem range 0x100000-0xbfffffff could not be reserved
PCI: Bridge: 0000:01:0d.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
Switched to high resolution mode on CPU 0
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
PCI: Bridge: 0000:00:06.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
   IO window: disabled.
   MEM window: 0xff400000-0xff4fffff
   PREFETCH window: 0x00000000cbd00000-0x00000000cbdfffff
PCI: Bridge: 0000:00:08.0
   IO window: b000-bfff
   MEM window: 0xff500000-0xff5fffff
   PREFETCH window: 0x00000000cbe00000-0x00000000cfefffff
PCI: Bridge: 0000:00:09.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 2666k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1222435864.083:1): initialized
Total HugeTLB memory allocated, 0
msgmni has been set to 32232
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci 0000:00:04.0: Firmware left e100 interrupts enabled; disabling
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:0a.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Boot video device
PCI: Setting latency timer of device 0000:00:08.0 to 64
Allocate Port Service[0000:00:08.0:pcie00]
PCI: Setting latency timer of device 0000:00:09.0 to 64
Allocate Port Service[0000:00:09.0:pcie00]
PCI: Setting latency timer of device 0000:00:0a.0 to 64
Allocate Port Service[0000:00:0a.0:pcie00]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
Allocate Port Service[0000:00:0b.0:pcie00]
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 28 (level, low) -> IRQ 28
PCI: Setting latency timer of device 0000:05:00.0 to 64
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xff5ff000, IRQ: 28.
3w-9xxx: scsi0: Firmware FE9X 3.06.00.003, BIOS BE9X 3.06.00.002, Ports: 4.
Driver 'sd' needs updating - please use bus_type methods
scsi 0:0:0:0: Direct-Access     AMCC     9650SE-4LP DISK  3.06 PQ: 0 ANSI: 5
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
sd 0:0:0:0: [sda] 2929625088 512-byte hardware sectors (1499968 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 2929625088 512-byte hardware sectors (1499968 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
  sda:<6>input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
  sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
EDAC MC: Ver: 2.1.0 Sep 16 2008
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Freeing unused kernel memory: 228k freed
Write protecting the kernel read-only data: 3572k
ACPI: PCI Interrupt 0000:00:03.2[A] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6ee000
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26.5 ehci_hcd
usb usb1: SerialNumber: 0000:00:03.2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6ec000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26.5 ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
ACPI: PCI Interrupt 0000:00:03.1[A] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ed000
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26.5 ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
USB Universal Host Controller Interface driver v3.0
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=1737, idProduct=0039
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product:  USB2.0 Gigabit Adapter 
usb 1-1: Manufacturer: USB2.0
usb 1-1: SerialNumber: 005220
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1222435866.694:2): selinux=0 auid=4294967295 ses=4294967295
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xff6eb000, irq 16, MAC addr 00:e0:81:4c:39:6e
piix4_smbus 0000:00:02.0: Found 0000:00:02.0 device
tg3.c:v3.92.1 (June 9, 2008)
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 26 (level, low) -> IRQ 26
eth1: Tigon3 [partno(BCM95780) rev 8100 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:4c:39:50
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76144000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:04:04.1[B] -> GSI 27 (level, low) -> IRQ 27
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
eth2: Tigon3 [partno(BCM95780) rev 8100 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:4c:39:51
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[76144000] dma_mask[40-bit]
input: PC Speaker as /devices/platform/pcspkr/input/input2
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input3
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
ACPI: Power Button (CM) [PWRB]
udev: renamed network interface eth0 to eth3
udev: renamed network interface eth1 to eth0
udev: renamed network interface eth2_rename to eth1
eth2: register 'asix' at usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet, 00:12:17:f2:2b:c4
usbcore: registered new interface driver asix
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 15593768k swap on /dev/sda4.  Priority:-1 extents:1 across:15593768k
ip_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
IPVS: Registered protocols (TCP, UDP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: ipvs loaded.
IPVS: ftp: loaded support on port[0] = 20
IPVS: ftp: loaded support on port[1] = 21
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
martian source 192.168.1.7 from 192.168.1.2, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:e0:81:47:c9:23:08:06
martian source 192.168.1.7 from 192.168.1.4, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:e0:81:34:c4:23:08:06
martian source 192.168.1.7 from 192.168.1.9, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:e0:81:45:55:ff:08:06
martian source 192.168.1.7 from 192.168.1.6, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:e0:81:48:6b:e7:08:06
martian source 192.168.1.7 from 192.168.1.5, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:e0:81:4a:06:47:08:06
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth0: no IPv6 routers present
martian source 90.190.106.137 from 194.126.99.226, on dev eth2
ll header: 00:12:17:f2:2b:c4:00:12:43:50:58:ef:08:00
ADDRCONF(NETDEV_UP): eth3: link is not ready
martian source 217.159.236.133 from 192.89.123.41, on dev eth0
ll header: 00:e0:81:4c:39:50:00:e0:81:4a:06:46:08:00
eth1: no IPv6 routers present
eth2: no IPv6 routers present
warning: `named' uses deprecated v2 capabilities in a way that may be insecure.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
fuse init (API version 7.9)
martian source 217.159.236.137 from 194.126.99.226, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
martian source 217.159.236.137 from 194.126.99.226, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
martian source 217.159.236.137 from 87.119.168.91, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
martian source 217.159.236.137 from 194.126.99.226, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
martian source 217.159.236.137 from 194.126.99.226, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
martian source 217.159.236.137 from 194.126.99.226, on dev eth0
ll header: 00:e0:81:4c:39:50:00:12:43:50:58:e0:08:00
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda3
Ending clean XFS mount for filesystem: sda3
php[1904]: segfault at 7fff26fc2ff8 ip 56c6f1 sp 7fff26fc2fd0 error 6 in php[400000+2a5000]
usbcore: deregistering interface driver asix
eth2: unregister 'asix' usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet
eth2: register 'asix' at usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet, 00:12:17:f2:2b:c4
usbcore: registered new interface driver asix
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: link down
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth2: no IPv6 routers present
php[23069]: segfault at 7fff54872fd8 ip 5922f0 sp 7fff54873008 error 6 in php[400000+2a5000]
php[10622]: segfault at 7fff43750fb8 ip 5c67b1 sp 7fff43750fb0 error 6 in php[400000+2a5000]
php[32052]: segfault at 7fffa6ba0ff8 ip 56c6e7 sp 7fffa6ba0fc0 error 6 in php[400000+2a5000]
php[21768]: segfault at 7fff9a2d0fe8 ip 5c4d75 sp 7fff9a2d0fe0 error 6 in php[400000+2a5000]
php[14696]: segfault at 7fff2fddaff8 ip 56cbfe sp 7fff2fddb000 error 6 in php[400000+2a5000]
php[3370]: segfault at 7fffb8cb9fa8 ip 5c67b1 sp 7fffb8cb9fa0 error 6 in php[400000+2a5000]
php[21221]: segfault at 7fff770a4ff8 ip 5c6824 sp 7fff770a5000 error 6 in php[400000+2a5000]
php[24013]: segfault at 7fff8006bf60 ip 56c6a5 sp 7fff8006bf10 error 6 in php[400000+2a5000]
php[13551]: segfault at 7fff82c51ff8 ip 5c67a6 sp 7fff82c52000 error 6 in php[400000+2a5000]
php[26701]: segfault at 7fff5cd2cfe0 ip 5c4d50 sp 7fff5cd2d008 error 6 in php[400000+2a5000]
php[32226]: segfault at 7fffedc28fe0 ip 5c4d50 sp 7fffedc29008 error 6 in php[400000+2a5000]
possible SYN flooding on port 8080. Sending cookies.
possible SYN flooding on port 8080. Sending cookies.
php[8262]: segfault at 7fff09e54ff8 ip 5c67a6 sp 7fff09e55000 error 6 in php[400000+2a5000]
usbcore: deregistering interface driver asix
eth2: unregister 'asix' usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet
eth2: register 'asix' at usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet, 00:12:17:f2:2b:c4
usbcore: registered new interface driver asix
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth2: no IPv6 routers present
TCP: Treason uncloaked! Peer 217.228.138.121:2126/8080 shrinks window 2829308322:2829321390. Repaired.
php[5684]: segfault at 7fffd5524f10 ip 56c6a5 sp 7fffd5524ec0 error 6 in php[400000+2a5000]
TCP: Treason uncloaked! Peer 88.196.248.115:63583/8080 shrinks window 3604724912:3604728120. Repaired.
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 0, comm: swapper Not tainted 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff803d972e>] ? __kfree_skb+0x74/0x78
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff80415a75>] ? tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803fc26d>] ? ip_rcv_finish+0x305/0x32a
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff8020a02b>] ? default_idle+0x2b/0x40
  [<ffffffff8020b043>] ? enter_idle+0x22/0x24
  [<ffffffff8020b0bd>] ? cpu_idle+0x78/0xc0
  [<ffffffff80454405>] ? start_secondary+0x15a/0x15e

---[ end trace f572c69b397874af ]---
php[8719]: segfault at 7fff4ae51f40 ip 56c6a5 sp 7fff4ae51ef0 error 6 in php[400000+2a5000]
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 8545, comm: httpd Tainted: G        W 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8023ad52>] ? lock_timer_base+0x26/0x4a
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI> 
---[ end trace f572c69b397874af ]---
TCP: Treason uncloaked! Peer 90.191.236.234:50268/8080 shrinks window 405320482:405325027. Repaired.
php[917]: segfault at 7fff4a349fe8 ip 5c4d75 sp 7fff4a349fe0 error 6 in php[400000+2a5000]
php[18391]: segfault at 7fff73befff8 ip 5c4d83 sp 7fff73bf0000 error 6 in php[400000+2a5000]
php[3128]: segfault at 7fffefab8ff8 ip 5c67a2 sp 7fffefab9000 error 6 in php[400000+2a5000]
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:2492/80 shrinks window 2967344648:2967344649. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:2492/80 shrinks window 2967344648:2967344649. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:2529/80 shrinks window 3452638969:3452638970. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:2529/80 shrinks window 3452638969:3452638970. Repaired.
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 32616, comm: httpd Tainted: G        W 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff8023afe8>] ? __mod_timer+0xbb/0xcd
  [<ffffffff803d972e>] ? __kfree_skb+0x74/0x78
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff8023ad52>] ? lock_timer_base+0x26/0x4a
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI> 
---[ end trace f572c69b397874af ]---
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:1619/80 shrinks window 2277736378:2277736379. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:1619/80 shrinks window 2277736378:2277736379. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:3a93:8112:34267/80 shrinks window 1091031876:1091031877. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:3a93:8112:34390/80 shrinks window 1560626825:1560626826. Repaired.
usbcore: deregistering interface driver asix
eth2: unregister 'asix' usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet
eth2: register 'asix' at usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet, 00:12:17:f2:2b:c4
usbcore: registered new interface driver asix
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: link down
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth2: no IPv6 routers present
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 29797, comm: squid Tainted: G        W 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8023ad52>] ? lock_timer_base+0x26/0x4a
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff803ae9a4>] ? usb_free_urb+0x15/0x17
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI> 
---[ end trace f572c69b397874af ]---
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff803ae9a4>] ? usb_free_urb+0x15/0x17
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff80249573>] ? getnstimeofday+0x3a/0x96
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff8020a02b>] ? default_idle+0x2b/0x40
  [<ffffffff8020b043>] ? enter_idle+0x22/0x24
  [<ffffffff8020b0bd>] ? cpu_idle+0x78/0xc0
  [<ffffffff80454405>] ? start_secondary+0x15a/0x15e

---[ end trace f572c69b397874af ]---
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:7e22:51040/80 shrinks window 1181125095:1181125096. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:1111/80 shrinks window 1866349495:1866349496. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:1111/80 shrinks window 1866349495:1866349496. Repaired.
TCP: Treason uncloaked! Peer 0000:0000:0000:0000:0000:ffff:58ca:246a:1115/80 shrinks window 1937974094:1937974095. Repaired.
------------[ cut here ]------------
WARNING: at net/core/dev.c:1451 skb_gso_segment+0x83/0x1b4()
Modules linked in: asix xfs nfsd lockd nfs_acl auth_rpcgss exportfs fuse sunrpc ipt_REJECT xt_multiport xt_state xt_tcpudp ipt_REDIRECT iptable_mangle iptable_nat nf_nat iptable_filter ip_vs_ftp ip_vs nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack ipv6 ip_tables x_tables rtc_cmos pcspkr button tg3 rtc_core i2c_piix4 usbnet k8temp rtc_lib e100 i2c_core mii hwmon uhci_hcd ohci_hcd ehci_hcd [last unloaded: asix]
Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #1

Call Trace:
  <IRQ>  [<ffffffff80231fbf>] warn_on_slowpath+0x58/0x94
  [<ffffffffa00fc8f2>] ? :nf_nat:tcp_manip_pkt+0xcc/0xde
  [<ffffffffa00fb267>] ? :nf_nat:manip_pkt+0x85/0xf8
  [<ffffffff80435580>] ? xfrm_lookup+0x11/0x2e
  [<ffffffff803dedcc>] skb_gso_segment+0x83/0x1b4
  [<ffffffff803df083>] dev_hard_start_xmit+0x186/0x245
  [<ffffffff803edbb7>] __qdisc_run+0xd5/0x1d6
  [<ffffffff803df401>] dev_queue_xmit+0x1b1/0x2c8
  [<ffffffff80400ce5>] ? ip_finish_output+0x0/0x241
  [<ffffffff80400ee4>] ip_finish_output+0x1ff/0x241
  [<ffffffff80400fc1>] ip_output+0x9b/0xa0
  [<ffffffff80400120>] ip_local_out+0x20/0x24
  [<ffffffff8040094b>] ip_queue_xmit+0x2c9/0x31f
  [<ffffffff8023afe8>] ? __mod_timer+0xbb/0xcd
  [<ffffffff803d972e>] ? __kfree_skb+0x74/0x78
  [<ffffffff80410cf9>] tcp_transmit_skb+0x6a1/0x6e4
  [<ffffffff80413677>] __tcp_push_pending_frames+0x745/0x85b
  [<ffffffff803d99c3>] ? skb_release_data+0xc6/0xcb
  [<ffffffff8040f44d>] tcp_rcv_established+0x11d/0xb68
  [<ffffffff80415a75>] tcp_v4_do_rcv+0x31/0x1d6
  [<ffffffff803e9b8c>] ? sk_filter+0x81/0x8d
  [<ffffffff80416077>] tcp_v4_rcv+0x45d/0x6d0
  [<ffffffff803fc64a>] ip_local_deliver_finish+0x124/0x1f9
  [<ffffffff803fc791>] ip_local_deliver+0x72/0x7a
  [<ffffffff803fc26d>] ip_rcv_finish+0x305/0x32a
  [<ffffffff8023ad52>] ? lock_timer_base+0x26/0x4a
  [<ffffffff803fc4f0>] ip_rcv+0x25e/0x294
  [<ffffffff803dea37>] netif_receive_skb+0x32d/0x34f
  [<ffffffffa00591ee>] :tg3:tg3_poll+0x782/0xa35
  [<ffffffff803dd63e>] net_rx_action+0x7a/0x12e
  [<ffffffff8023702a>] __do_softirq+0x66/0xd3
  [<ffffffff8020d11c>] call_softirq+0x1c/0x28
  [<ffffffff8020ec34>] do_softirq+0x34/0x72
  [<ffffffff80236e0e>] irq_exit+0x3f/0x80
  [<ffffffff8020ef1c>] do_IRQ+0x145/0x167
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020a000>] ? default_idle+0x0/0x40
  [<ffffffff8020c4a1>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff8020a02b>] ? default_idle+0x2b/0x40
  [<ffffffff8020b043>] ? enter_idle+0x22/0x24
  [<ffffffff8020b0bd>] ? cpu_idle+0x78/0xc0
  [<ffffffff80454405>] ? start_secondary+0x15a/0x15e

---[ end trace f572c69b397874af ]---
php[13736]: segfault at 7fff768eaf58 ip 5c67b1 sp 7fff768eaf50 error 6 in php[400000+2a5000]
php[1649]: segfault at 7fff9af2fff8 ip 56c6f1 sp 7fff9af2ffd0 error 6 in php[400000+2a5000]
php[21174]: segfault at 7fff8fc19ff8 ip 5c6824 sp 7fff8fc1a000 error 6 in php[400000+2a5000]
usbcore: deregistering interface driver asix
eth2: unregister 'asix' usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet
eth2: register 'asix' at usb-0000:00:03.2-1, ASIX AX88178 USB 2.0 Ethernet, 00:12:17:f2:2b:c4
usbcore: registered new interface driver asix
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: link up, 1000Mbps, full-duplex, lpa 0xC1E1
eth2: no IPv6 routers present

--
Reigo Küngas
SoftExpert
reigo@softexpert.eu

-----
He who walks on burning coals is sure to get burned.
 		-- Sinbad
--2126701155-772943858-1223320763=:23753--
