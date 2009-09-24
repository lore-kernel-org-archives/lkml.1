Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZIXEfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZIXEfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 00:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZIXEfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 00:35:17 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:43515 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750794AbZIXEfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 00:35:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Reply-To:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=IpdWJ+m+y/1VDybk+AFnzQhRyox6H5aqa8Slf4EInxIHbBzUHGBMHHR6/UpzQoxR1OGnIcOpIvIYktJDpvDVYEk2hmyw1VGn5FP4egJyXhTPx/YtZq3Fd2pF4bhy7zkeY07cgOpsBBJV8+xsRFxb5xZgJhuzcRLHugGqs9HdTyo=  ;
X-YMail-OSG: mWCOoVUVM1mGOPfvukth0cQ1q7nVvl3v2EBtg5ZdKTsIFxXSSrb5w4Kp1BPa62FFc6h1oGgSp8S3UNVnkWsQXaabXor9mgnUB2pGMkDM3RxKwj1XxVul1pBS22z6q3OVLfajR6_1QKj9ZHGVwnCXxX8AVUGehCW.NGmVHfitOuIi4_mmXXF9FRR1YHICeFiyhw5TgDshTdpRnazbiOJfGn0_VovE2U9RA3XgpdWzW1Uq6Xc.pnMzTIYgaF4gtONJ3OZ7TKcUJbMUp43fKUQ4agJ6BPgJ2zF_r6i9MhxzcYTa3ur13Oof4JjJxxOtxnJo9OQIt..TqQlkoTHJ
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Sep 2009 23:35:05 -0500
From: Will <whansard@sbcglobal.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
Message-Id: <20090923233505.a567667b.whansard@sbcglobal.net>
In-Reply-To: <4ABAE271.80309@gmail.com>
References: <4ABA0FDA.9090707@sbcglobal.net>
	<4ABAE271.80309@gmail.com>
Reply-To: whansard@sbcglobal.net
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 21:07:29 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On 09/23/2009 06:08 AM, will wrote:
> > I had been using an old 2.6.22 kernel on my machine, and I often backup
> > one partition of my main hard drive to a partition on a second hard
> > drive. The main hard drive is sata 640 gigs, and the second is a pata
> > 320 gig. copying this partition from one drive to the other with dd
> > takes about 3 minutes and 30 seconds. When I installed kernel 2.6.30,
> > and 2.6.31, the time took 9 minutes and 20 seconds. I decided to go to
> > the trouble of compiling all the kernels between, and kernels
> > 2.6.22-2.6.28 all do the operation in about 3 minutes and 30 seconds.
> > 2.6.29- newer all take about 9 minutes and 20 seconds. The partition is
> > 16 gigs. each drive seems to be as fast as before otherwise, it's just
> > much slower copying from one drive to another, which I do very often.
> > This is an nforce 3 based motherboard, amd southbridge, i think, with 4
> > gigs of ram, athlon 64x2. 32 bit kernel. has anyone heard of this problem?
> > I currently have 3 hard drives hooked up.
> > a 200 gig on a promise controller,
> > a 320 gig on the amd pata?
> > a 640 sata on the nv i think.
> > The motherboard is a Asrock-AM2NF3-VSTA
> > copying this partition with dd or cat or schily's dd between any of these 3
> > different hard drives takes different times depending on the speed of
> > the drive with
> > kernels 2.6.22-2.6.28, but takes about 9 minutes and 30 seconds on any
> > of the drives
> > with the kernels 2.6.29 and after.
> > Please cc me with any followups or anything. thanks.
> 
> Can you post the dmesg output from bootup on both the good and bad kernels?

good
Linux version 2.6.28-04985-gebdab07 (root@Wil.com) (gcc version 4.4.1 (GCC) ) #14 SMP Wed Sep 23 21:12:50 CDT 2009
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
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000ebfb0000 (usable)
 BIOS-e820: 00000000ebfb0000 - 00000000ebfc0000 (ACPI data)
 BIOS-e820: 00000000ebfc0000 - 00000000ebff0000 (ACPI NVS)
 BIOS-e820: 00000000ebff0000 - 00000000ec000000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000114000000 (usable)
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0xebfb0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 377fe000 @ 10000-16000
ACPI: RSDP 000F9910, 0014 (r0 ACPIAM)
ACPI: RSDT EBFB0000, 0034 (r1 A M I  OEMRSDT   1000808 MSFT       97)
ACPI: FACP EBFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
ACPI: DSDT EBFB0400, 3D56 (r1  M2N3V M2N3V234      234 INTL  2002026)
ACPI: FACS EBFC0000, 0040
ACPI: APIC EBFB0390, 006C (r1 A M I  OEMAPIC   1000808 MSFT       97)
ACPI: OEMB EBFC0040, 0056 (r1 A M I  AMI_OEM   1000808 MSFT       97)
ACPI: SSDT EBFB4160, 0248 (r1 A M I  POWERNOW        1 AMD         1)
ACPI: Local APIC address 0xfee00000
2887MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(8 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00006e88f4]    TEXT DATA BSS ==> [0000100000 - 00006e88f4]
  #4 [00006e9000 - 00006ec000]    INIT_PG_TABLE ==> [00006e9000 - 00006ec000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000ebfb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000ebfb0
On node 0 totalpages: 966463
free_area_init_node: node 0, pgdat c0643940, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 5776 pages used for memmap
  HighMem zone: 733474 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at ee000000 (gap: ec000000:13000000)
PERCPU: Allocating 32768 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 958911
Kernel command line: BOOT_IMAGE=Linux ro root=805
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 2736.863 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x30
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3827692k/3866304k available (4150k kernel code, 37220k reserved, 1329k data, 284k init, 2957000k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9f000 - 0xfffff000   ( 384 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0661000 - 0xc06a8000   ( 284 kB)
      .data : 0xc050d96b - 0xc0659e60   (1329 kB)
      .text : 0xc0100000 - 0xc050d96b   (4150 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5473.72 BogoMIPS (lpj=2736863)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) X2 Dual Core Processor BE-2400 stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5472.99 BogoMIPS (lpj=2736496)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) X2 Dual Core Processor BE-2400 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (10946.71 BogoMIPS).
net_namespace: 684 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xec000000-0xefffffff]
pci 0000:00:01.1: reg 10 io port: [0x5080-0x509f]
pci 0000:00:01.1: reg 20 io port: [0x5000-0x503f]
pci 0000:00:01.1: reg 24 io port: [0x5040-0x507f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: [0xfcffd000-0xfcffdfff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xfcffe000-0xfcffefff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: reg 10 32bit mmio: [0xfcfffc00-0xfcfffcff]
pci 0000:00:02.2: supports D1 D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.2: PME# disabled
pci 0000:00:05.0: reg 10 32bit mmio: [0xfcffc000-0xfcffcfff]
pci 0000:00:05.0: reg 14 io port: [0xdc00-0xdc07]
pci 0000:00:05.0: supports D1 D2
pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:08.0: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:0a.0: reg 10 io port: [0xf80-0xf87]
pci 0000:00:0a.0: reg 14 io port: [0xf00-0xf03]
pci 0000:00:0a.0: reg 18 io port: [0xe80-0xe87]
pci 0000:00:0a.0: reg 1c io port: [0xe00-0xe03]
pci 0000:00:0a.0: reg 20 io port: [0xd000-0xd00f]
pci 0000:00:0a.0: reg 24 io port: [0xc800-0xc87f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf7ffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfeae0000-0xfeafffff]
pci 0000:00:0b.0: bridge 32bit mmio: [0xfd000000-0xfeafffff]
pci 0000:00:0b.0: bridge 32bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:02:07.0: reg 10 32bit mmio: [0xfebf8000-0xfebfffff]
pci 0000:02:07.0: supports D2
pci 0000:02:08.0: reg 10 io port: [0xec00-0xec07]
pci 0000:02:08.0: reg 14 io port: [0xe880-0xe883]
pci 0000:02:08.0: reg 18 io port: [0xe800-0xe807]
pci 0000:02:08.0: reg 1c io port: [0xe480-0xe483]
pci 0000:02:08.0: reg 20 io port: [0xe400-0xe40f]
pci 0000:02:08.0: reg 24 32bit mmio: [0xfebf4000-0xfebf7fff]
pci 0000:02:08.0: reg 30 32bit mmio: [0xfebe0000-0xfebe3fff]
pci 0000:02:08.0: supports D1
pci 0000:00:0e.0: bridge io port: [0xe000-0xefff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *3
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *5
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *11
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 22) *14
ACPI: Power Resource [ISAV] (on)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 26, should be 21 [20080926]
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0x4000-0x407f has been reserved
system 00:06: ioport range 0x4080-0x40ff has been reserved
system 00:07: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:07: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:07: iomem range 0xff380000-0xffffffff has been reserved
system 00:0b: ioport range 0x290-0x29f has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0xebffffff could not be reserved
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xfd000000-0xfeafffff
pci 0000:00:0b.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0xe000-0xefff
pci 0000:00:0e.0:   MEM window: 0xfeb00000-0xfebfffff
pci 0000:00:0e.0:   PREFETCH window: disabled
pci 0000:00:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xfd000000-0xfeafffff]
bus: 01 index 2 mmio: [0xf0000000-0xf7ffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xe000-0xefff]
bus: 02 index 1 mmio: [0xfeb00000-0xfebfffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
cpufreq: No nForce2 chipset.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
fuse init (API version 7.10)
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with security attributes, no debug enabled
OCFS2 1.5.0
OCFS2 Node Manager 1.5.0
msgmni has been set to 1702
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:01:00.0: Boot video device
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
lp: driver loaded but no devices found
Linux agpgart interface v0.103
agpgart-amd64 0000:00:00.0: AGP bridge [10de/00e1]
agpgart-amd64 0000:00:00.0: setting up Nforce3 AGP
agpgart-amd64 0000:00:00.0: AGP aperture is 64M @ 0xec000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:05: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
floppy0: no floppy controllers found
loop: module loaded
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
  alloc irq_2_pin on cpu 0 node 0
forcedeth 0000:00:05.0: PCI INT A -> Link[LKLN] -> GSI 22 (level, low) -> IRQ 22
forcedeth 0000:00:05.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:05.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:66:49:5f:99
forcedeth 0000:00:05.0: csum timirq lnktim desc-v2
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:08.0: UDMA133 controller
amd74xx 0000:00:08.0: IDE controller (0x10de:0x00e5 rev 0xa2)
pci 0000:00:08.0: power state changed by ACPI to D0
amd74xx 0000:00:08.0: BIOS didn't set cable bits correctly. Enabling workaround.
amd74xx 0000:00:08.0: BIOS didn't set cable bits correctly. Enabling workaround.
amd74xx 0000:00:08.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7
    ide1: BM-DMA at 0xffa8-0xffaf
Probing IDE interface ide0...
hda: MAXTOR STM3320620A, ATA DISK drive
hdb: _NEC DVD_RW ND-3550A, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
Probing IDE interface ide1...
hdc: _NEC DVD_RW ND-3550A, ATAPI CD/DVD-ROM drive
hdd: PIONEER DVD-RW DVR-111D, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
pdc202xx_new 0000:02:08.0: IDE controller (0x105a:0x4d68 rev 0x02)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
vendor=10de device=00ed
  alloc irq_2_pin on cpu 0 node 0
pci 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
pdc202xx_new 0000:02:08.0: PLL input clock is 16641 kHz
pdc202xx_new 0000:02:08.0: 100% native mode on irq 19
    ide2: BM-DMA at 0xe400-0xe407
    ide3: BM-DMA at 0xe408-0xe40f
Probing IDE interface ide2...
Probing IDE interface ide3...
ide2 at 0xec00-0xec07,0xe882 on irq 19
ide3 at 0xe800-0xe807,0xe482 on irq 19
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 625142448 sectors (320072 MB) w/16384KiB Cache, CHS=38913/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 >
ide-cd driver 5.00
ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-cd: hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
ide-cd: hdd: ATAPI 63X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
  alloc irq_2_pin on cpu 0 node 0
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd000 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd008 irq 21
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3640323AS, CC1F, max UDMA/133
ata2.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3640323AS      CC1F PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1250263728 512-byte hardware sectors: (640 GB/596 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 1250263728 512-byte hardware sectors: (640 GB/596 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
Advanced Linux Sound Architecture Driver Version 1.0.18a.
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 18
vendor=10de device=00ed
  alloc irq_2_pin on cpu 0 node 0
Yamaha DS-1 PCI 0000:02:07.0: PCI INT A -> Link[LNKD] -> GSI 18 (level, low) -> IRQ 18
Yamaha DS-1 PCI 0000:02:07.0: firmware: using built-in firmware yamaha/ds1_dsp.fw
Yamaha DS-1 PCI 0000:02:07.0: firmware: using built-in firmware yamaha/ds1e_ctrl.fw
input: AT Translated Set 2 keyboard as /class/input/input0
ALSA device list:
  #0: Yamaha DS-1 (YMF724F) at 0xfebf8000, irq 18
IPv4 over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) X2 Dual Core Processor BE-2400 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xf (2300 MHz), vid 0xe
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xf
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x11
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x13
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x16
Using IPI No-Shortcut mode
rtc_cmos 00:02: setting system clock to 2009-09-23 22:58:36 UTC (1253746716)
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
ReiserFS: sda5: found reiserfs format "3.6" with standard journal
ReiserFS: sda5: using ordered data mode
ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda5: checking transaction log (sda5)
ReiserFS: sda5: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 284k freed
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[18060 33348 0xf6c5325c UNKNOWN] not found
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[18060 113891 0xf6c55758 UNKNOWN] not found
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[117144 365484 0xf6c56188 UNKNOWN] not found
ip_tables: (C) 2000-2006 Netfilter Core Team
hdb: UDMA/33 mode selected
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x3c/0x50()
Hardware name: To Be Filled By O.E.M.
sysfs: duplicate filename 'audio' can not be created
Modules linked in: sound(+) ipt_LOG ip_tables x_tables
Pid: 1666, comm: modprobe Not tainted 2.6.28-04985-gebdab07 #14
Call Trace:
 [<c01406b2>] warn_slowpath+0x82/0xc0
 [<c050a8fe>] schedule+0x21e/0x780
 [<c012eb77>] xapic_wait_icr_idle+0x17/0x20
 [<c035ca84>] idr_get_empty_slot+0xe4/0x260
 [<c035cc79>] ida_get_new_above+0x79/0x1b0
 [<c01cfcd0>] sysfs_ilookup_test+0x0/0x10
 [<c01cfff1>] sysfs_find_dirent+0x21/0x30
 [<c01d012d>] __sysfs_add_one+0x1d/0xe0
 [<c019e8a6>] ilookup5+0x36/0x40
 [<c01d022c>] sysfs_add_one+0x3c/0x50
 [<c01d07d8>] create_dir+0x48/0x90
 [<c01d0849>] sysfs_create_dir+0x29/0x40
 [<c035d75f>] kobject_get+0xf/0x20
 [<c035d853>] kobject_add_internal+0x83/0x1d0
 [<c035da2a>] kobject_set_name_vargs+0x3a/0x50
 [<c035da5e>] kobject_add_varg+0x1e/0x60
 [<c035dafd>] kobject_add+0x2d/0x60
 [<c035d75f>] kobject_get+0xf/0x20
 [<c03c9a0a>] device_add+0xca/0x600
 [<c035d515>] kobject_init+0x25/0xa0
 [<c03c9fdb>] device_create_vargs+0x8b/0xd0
 [<c03ca04b>] device_create+0x2b/0x30
 [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
 [<c0101123>] do_one_initcall+0x33/0x170
 [<f85ff000>] oss_init+0x0/0x149 [sound]
 [<c016345b>] sys_init_module+0x8b/0x1b0
 [<c018b688>] sys_close+0x58/0x90
 [<c011c26e>] syscall_call+0x7/0xb
---[ end trace c45370bb6aa94452 ]---
kobject_add_internal failed for audio with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1666, comm: modprobe Tainted: G        W  2.6.28-04985-gebdab07 #14
Call Trace:
 [<c035d902>] kobject_add_internal+0x132/0x1d0
 [<c035dafd>] kobject_add+0x2d/0x60
 [<c035d75f>] kobject_get+0xf/0x20
 [<c03c9a0a>] device_add+0xca/0x600
 [<c035d515>] kobject_init+0x25/0xa0
 [<c03c9fdb>] device_create_vargs+0x8b/0xd0
 [<c03ca04b>] device_create+0x2b/0x30
 [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
 [<c0101123>] do_one_initcall+0x33/0x170
 [<f85ff000>] oss_init+0x0/0x149 [sound]
 [<c016345b>] sys_init_module+0x8b/0x1b0
 [<c018b688>] sys_close+0x58/0x90
 [<c011c26e>] syscall_call+0x7/0xb
hdc: UDMA/33 mode selected
Driver 'sr' needs updating - please use bus_type methods
hdd: UDMA/66 mode selected
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[117144 365494 0xf6ca87d8 UNKNOWN] not found
w83627ehf: Found W83627EHG chip at 0x290
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?


bad

Linux version 2.6.28-04986-g295f000 (root@Wil.com) (gcc version 4.4.1 (GCC) ) #13 SMP Wed Sep 23 21:08:03 CDT 2009
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
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000ebfb0000 (usable)
 BIOS-e820: 00000000ebfb0000 - 00000000ebfc0000 (ACPI data)
 BIOS-e820: 00000000ebfc0000 - 00000000ebff0000 (ACPI NVS)
 BIOS-e820: 00000000ebff0000 - 00000000ec000000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000114000000 (usable)
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0xebfb0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 377fe000 @ 10000-16000
ACPI: RSDP 000F9910, 0014 (r0 ACPIAM)
ACPI: RSDT EBFB0000, 0034 (r1 A M I  OEMRSDT   1000808 MSFT       97)
ACPI: FACP EBFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
ACPI: DSDT EBFB0400, 3D56 (r1  M2N3V M2N3V234      234 INTL  2002026)
ACPI: FACS EBFC0000, 0040
ACPI: APIC EBFB0390, 006C (r1 A M I  OEMAPIC   1000808 MSFT       97)
ACPI: OEMB EBFC0040, 0056 (r1 A M I  AMI_OEM   1000808 MSFT       97)
ACPI: SSDT EBFB4160, 0248 (r1 A M I  POWERNOW        1 AMD         1)
ACPI: Local APIC address 0xfee00000
2887MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(8 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00006e88f4]    TEXT DATA BSS ==> [0000100000 - 00006e88f4]
  #4 [00006e9000 - 00006ec000]    INIT_PG_TABLE ==> [00006e9000 - 00006ec000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000ebfb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000ebfb0
On node 0 totalpages: 966463
free_area_init_node: node 0, pgdat c0643940, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 5776 pages used for memmap
  HighMem zone: 733474 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at ee000000 (gap: ec000000:13000000)
PERCPU: Allocating 32768 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 958911
Kernel command line: BOOT_IMAGE=Linux ro root=805
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 2737.051 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x30
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3827692k/3866304k available (4150k kernel code, 37220k reserved, 1329k data, 284k init, 2957000k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9f000 - 0xfffff000   ( 384 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0661000 - 0xc06a8000   ( 284 kB)
      .data : 0xc050d98b - 0xc0659e60   (1329 kB)
      .text : 0xc0100000 - 0xc050d98b   (4150 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5474.10 BogoMIPS (lpj=2737051)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) X2 Dual Core Processor BE-2400 stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5472.99 BogoMIPS (lpj=2736496)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) X2 Dual Core Processor BE-2400 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (10947.09 BogoMIPS).
net_namespace: 684 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xec000000-0xefffffff]
pci 0000:00:01.1: reg 10 io port: [0x5080-0x509f]
pci 0000:00:01.1: reg 20 io port: [0x5000-0x503f]
pci 0000:00:01.1: reg 24 io port: [0x5040-0x507f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: [0xfcffd000-0xfcffdfff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xfcffe000-0xfcffefff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.2: reg 10 32bit mmio: [0xfcfffc00-0xfcfffcff]
pci 0000:00:02.2: supports D1 D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.2: PME# disabled
pci 0000:00:05.0: reg 10 32bit mmio: [0xfcffc000-0xfcffcfff]
pci 0000:00:05.0: reg 14 io port: [0xdc00-0xdc07]
pci 0000:00:05.0: supports D1 D2
pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:08.0: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:0a.0: reg 10 io port: [0xf80-0xf87]
pci 0000:00:0a.0: reg 14 io port: [0xf00-0xf03]
pci 0000:00:0a.0: reg 18 io port: [0xe80-0xe87]
pci 0000:00:0a.0: reg 1c io port: [0xe00-0xe03]
pci 0000:00:0a.0: reg 20 io port: [0xd000-0xd00f]
pci 0000:00:0a.0: reg 24 io port: [0xc800-0xc87f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf7ffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfeae0000-0xfeafffff]
pci 0000:00:0b.0: bridge 32bit mmio: [0xfd000000-0xfeafffff]
pci 0000:00:0b.0: bridge 32bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:02:07.0: reg 10 32bit mmio: [0xfebf8000-0xfebfffff]
pci 0000:02:07.0: supports D2
pci 0000:02:08.0: reg 10 io port: [0xec00-0xec07]
pci 0000:02:08.0: reg 14 io port: [0xe880-0xe883]
pci 0000:02:08.0: reg 18 io port: [0xe800-0xe807]
pci 0000:02:08.0: reg 1c io port: [0xe480-0xe483]
pci 0000:02:08.0: reg 20 io port: [0xe400-0xe40f]
pci 0000:02:08.0: reg 24 32bit mmio: [0xfebf4000-0xfebf7fff]
pci 0000:02:08.0: reg 30 32bit mmio: [0xfebe0000-0xfebe3fff]
pci 0000:02:08.0: supports D1
pci 0000:00:0e.0: bridge io port: [0xe000-0xefff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *3
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *5
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *11
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 22) *14
ACPI: Power Resource [ISAV] (on)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 26, should be 21 [20080926]
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0x4000-0x407f has been reserved
system 00:06: ioport range 0x4080-0x40ff has been reserved
system 00:07: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:07: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:07: iomem range 0xff380000-0xffffffff has been reserved
system 00:0b: ioport range 0x290-0x29f has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0xebffffff could not be reserved
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xfd000000-0xfeafffff
pci 0000:00:0b.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0xe000-0xefff
pci 0000:00:0e.0:   MEM window: 0xfeb00000-0xfebfffff
pci 0000:00:0e.0:   PREFETCH window: disabled
pci 0000:00:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xfd000000-0xfeafffff]
bus: 01 index 2 mmio: [0xf0000000-0xf7ffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xe000-0xefff]
bus: 02 index 1 mmio: [0xfeb00000-0xfebfffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
cpufreq: No nForce2 chipset.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
fuse init (API version 7.10)
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with security attributes, no debug enabled
OCFS2 1.5.0
OCFS2 Node Manager 1.5.0
msgmni has been set to 1702
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:01:00.0: Boot video device
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
lp: driver loaded but no devices found
Linux agpgart interface v0.103
agpgart-amd64 0000:00:00.0: AGP bridge [10de/00e1]
agpgart-amd64 0000:00:00.0: setting up Nforce3 AGP
agpgart-amd64 0000:00:00.0: AGP aperture is 64M @ 0xec000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:05: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
floppy0: no floppy controllers found
loop: module loaded
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
  alloc irq_2_pin on cpu 0 node 0
forcedeth 0000:00:05.0: PCI INT A -> Link[LKLN] -> GSI 22 (level, low) -> IRQ 22
forcedeth 0000:00:05.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:05.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:66:49:5f:99
forcedeth 0000:00:05.0: csum timirq lnktim desc-v2
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:08.0: UDMA133 controller
amd74xx 0000:00:08.0: IDE controller (0x10de:0x00e5 rev 0xa2)
pci 0000:00:08.0: power state changed by ACPI to D0
amd74xx 0000:00:08.0: BIOS didn't set cable bits correctly. Enabling workaround.
amd74xx 0000:00:08.0: BIOS didn't set cable bits correctly. Enabling workaround.
amd74xx 0000:00:08.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7
    ide1: BM-DMA at 0xffa8-0xffaf
Probing IDE interface ide0...
hda: MAXTOR STM3320620A, ATA DISK drive
hdb: _NEC DVD_RW ND-3550A, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
Probing IDE interface ide1...
hdc: _NEC DVD_RW ND-3550A, ATAPI CD/DVD-ROM drive
hdd: PIONEER DVD-RW DVR-111D, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
pdc202xx_new 0000:02:08.0: IDE controller (0x105a:0x4d68 rev 0x02)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
vendor=10de device=00ed
  alloc irq_2_pin on cpu 0 node 0
pci 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
pdc202xx_new 0000:02:08.0: PLL input clock is 16640 kHz
pdc202xx_new 0000:02:08.0: 100% native mode on irq 19
    ide2: BM-DMA at 0xe400-0xe407
    ide3: BM-DMA at 0xe408-0xe40f
Probing IDE interface ide2...
Probing IDE interface ide3...
ide2 at 0xec00-0xec07,0xe882 on irq 19
ide3 at 0xe800-0xe807,0xe482 on irq 19
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 625142448 sectors (320072 MB) w/16384KiB Cache, CHS=38913/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 >
ide-cd driver 5.00
ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-cd: hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
ide-cd: hdd: ATAPI 63X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
  alloc irq_2_pin on cpu 0 node 0
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd000 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd008 irq 21
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST3640323AS, CC1F, max UDMA/133
ata2.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3640323AS      CC1F PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 1250263728 512-byte hardware sectors: (640 GB/596 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 1250263728 512-byte hardware sectors: (640 GB/596 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram
i2c /dev entries driver
cpuidle: using governor ladder
Advanced Linux Sound Architecture Driver Version 1.0.18a.
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 18
vendor=10de device=00ed
  alloc irq_2_pin on cpu 0 node 0
Yamaha DS-1 PCI 0000:02:07.0: PCI INT A -> Link[LNKD] -> GSI 18 (level, low) -> IRQ 18
Yamaha DS-1 PCI 0000:02:07.0: firmware: using built-in firmware yamaha/ds1_dsp.fw
Yamaha DS-1 PCI 0000:02:07.0: firmware: using built-in firmware yamaha/ds1e_ctrl.fw
input: AT Translated Set 2 keyboard as /class/input/input0
ALSA device list:
  #0: Yamaha DS-1 (YMF724F) at 0xfebf8000, irq 18
IPv4 over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) X2 Dual Core Processor BE-2400 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xf (2300 MHz), vid 0xe
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xf
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x11
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x13
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x16
Using IPI No-Shortcut mode
rtc_cmos 00:02: setting system clock to 2009-09-23 23:23:24 UTC (1253748204)
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
ReiserFS: sda5: found reiserfs format "3.6" with standard journal
ReiserFS: sda5: using ordered data mode
ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda5: checking transaction log (sda5)
ReiserFS: sda5: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 284k freed
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[18060 365508 0xf6c0ec14 UNKNOWN] not found
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[117144 365509 0xf6c58188 UNKNOWN] not found
ip_tables: (C) 2000-2006 Netfilter Core Team
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x3c/0x50()
Hardware name: To Be Filled By O.E.M.
sysfs: duplicate filename 'audio' can not be created
Modules linked in: sound(+) ipt_LOG ip_tables x_tables
Pid: 1666, comm: modprobe Not tainted 2.6.28-04986-g295f000 #13
Call Trace:
 [<c01406b2>] warn_slowpath+0x82/0xc0
 [<c050a91e>] schedule+0x21e/0x780
 [<c035ca84>] idr_get_empty_slot+0xe4/0x260
 [<c035cc79>] ida_get_new_above+0x79/0x1b0
 [<c01cfcd0>] sysfs_ilookup_test+0x0/0x10
 [<c01cfff1>] sysfs_find_dirent+0x21/0x30
 [<c01d012d>] __sysfs_add_one+0x1d/0xe0
 [<c019e8a6>] ilookup5+0x36/0x40
 [<c01d022c>] sysfs_add_one+0x3c/0x50
 [<c01d07d8>] create_dir+0x48/0x90
 [<c01d0849>] sysfs_create_dir+0x29/0x40
 [<c035d75f>] kobject_get+0xf/0x20
 [<c035d853>] kobject_add_internal+0x83/0x1d0
 [<c035da2a>] kobject_set_name_vargs+0x3a/0x50
 [<c035da5e>] kobject_add_varg+0x1e/0x60
 [<c035dafd>] kobject_add+0x2d/0x60
 [<c035d75f>] kobject_get+0xf/0x20
 [<c03c9a0a>] device_add+0xca/0x600
 [<c035d515>] kobject_init+0x25/0xa0
 [<c03c9fdb>] device_create_vargs+0x8b/0xd0
 [<c03ca04b>] device_create+0x2b/0x30
 [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
 [<c0101123>] do_one_initcall+0x33/0x170
 [<f85ff000>] oss_init+0x0/0x149 [sound]
 [<c016345b>] sys_init_module+0x8b/0x1b0
 [<c018b688>] sys_close+0x58/0x90
 [<c011c26e>] syscall_call+0x7/0xb
---[ end trace 706eab727743e4b1 ]---
kobject_add_internal failed for audio with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1666, comm: modprobe Tainted: G        W  2.6.28-04986-g295f000 #13
Call Trace:
 [<c035d902>] kobject_add_internal+0x132/0x1d0
 [<c035dafd>] kobject_add+0x2d/0x60
 [<c035d75f>] kobject_get+0xf/0x20
 [<c03c9a0a>] device_add+0xca/0x600
 [<c035d515>] kobject_init+0x25/0xa0
 [<c03c9fdb>] device_create_vargs+0x8b/0xd0
 [<c03ca04b>] device_create+0x2b/0x30
 [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
 [<c0101123>] do_one_initcall+0x33/0x170
 [<f85ff000>] oss_init+0x0/0x149 [sound]
 [<c016345b>] sys_init_module+0x8b/0x1b0
 [<c018b688>] sys_close+0x58/0x90
 [<c011c26e>] syscall_call+0x7/0xb
hdb: UDMA/33 mode selected
Driver 'sr' needs updating - please use bus_type methods
hdc: UDMA/33 mode selected
hdd: UDMA/66 mode selected
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: warning: vs-500: unknown uniqueness -1071672013
ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[117144 365512 0xf6c19e28 UNKNOWN] not found
w83627ehf: Found W83627EHG chip at 0x290
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?
warning: process `update' used the obsolete bdflush system call
Fix your initscripts?
 
