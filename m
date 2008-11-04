Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYKDBNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYKDBNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYKDBNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:13:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:56986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYKDBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JwfLPYvMnJirBvP1H6nbpvZahG3hfOjzFe6oSh4a9Z4zfP2RTo+vGQeBr9EwoEBSry
         I1O1wS8gG50Y+gYCzAenva9cqcEDGNCBx/S0908+7rqh126UmP1zEFSAMpuQZI2eoG3B
         oKWsDCH0+bCje+EsKJzd7BsnM2A+IsiYiaQvM=
Message-ID: <14a58f0b0811031713x3cececb6x670a61eceffb8561@mail.gmail.com>
Date: Tue, 4 Nov 2008 02:13:39 +0100
From: "=?ISO-8859-2?Q?Piotr_=A3obacz?=" <kocur666@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: latest kernel 2.6.27 and error message 'pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff]'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have strange error message when I boot my linux with latest kerner
just like in the subject.

I give you my /proc/iomem:
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cdfff : Video ROM
000ce000-000cf9ff : Adapter ROM
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3fecffff : System RAM
  00100000-0048a7c2 : Kernel code
  0048a7c3-00595e97 : Kernel data
  005e4000-0062e767 : Kernel bss
3fed0000-3fee2fff : ACPI Non-volatile Storage
3fee3000-3fffffff : reserved
50000000-500000ff : 0000:00:1f.3
c6000000-c7ffffff : PCI Bus 0000:06
  c6000000-c600ffff : 0000:06:00.0
    c6000000-c600ffff : tg3
c9000000-caffffff : PCI Bus 0000:01
  c9000000-c9ffffff : 0000:01:00.0
    c9000000-c9ffffff : nvidia
  ca000000-caffffff : 0000:01:00.0
cc000000-cdffffff : PCI Bus 0000:06
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
    d0000000-d09fffff : uvesafb
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : reserved
f0000000-f1ffffff : PCI Bus 0000:02
f2000000-f3ffffff : PCI Bus 0000:04
f4000000-f5ffffff : PCI Bus 0000:05
f6000000-f7ffffff : PCI Bus 0000:02
f8000000-f9ffffff : PCI Bus 0000:04
  f8000000-f8001fff : 0000:04:00.0
    f8000000-f8001fff : iwlagn
fa000000-fbffffff : PCI Bus 0000:05
fc000000-fc0fffff : PCI Bus 0000:08
  fc000000-fc0007ff : 0000:08:06.0
    fc000000-fc0007ff : ohci1394
  fc000800-fc0008ff : 0000:08:06.1
    fc000800-fc0008ff : mmc0
  fc000c00-fc000cff : 0000:08:06.2
  fc001000-fc0010ff : 0000:08:06.3
fc300000-fc303fff : 0000:00:1b.0
  fc300000-fc303fff : ICH HD audio
fc304000-fc3043ff : 0000:00:1a.7
  fc304000-fc3043ff : ehci_hcd
fc304400-fc3047ff : 0000:00:1d.7
  fc304400-fc3047ff : ehci_hcd
fec00000-fec0ffff : reserved
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
fed1c000-fed8ffff : reserved
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved

and all information from dmesg:
HighMem  0x00038000 -> 0x0003fed0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fed0
On node 0 totalpages: 261743
free_area_init_node: node 0, pgdat c0584000, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 32210 pages, LIFO batch:7
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 37148 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259697
Kernel command line: root=/dev/ram0 init=/linuxrc ramdisk=8192
real_root=/dev/sda3 udev acpi_osi=Linux acpi_sleep=s3_bios,s3_mode
video=uvesafb:ywrap,mtrr,1280x1024-32@75
splash=silent,theme:livecd-2007.0,profile console=tty1 quiet
ACPI: Added _OSI(Linux)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2094.726 MHz processor.
Console: colour VGA+ 80x25
console [tty1] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1030192k/1047360k available (3625k kernel code, 16464k
reserved, 1069k data, 288k init, 129856k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc059c000 - 0xc05e4000   ( 288 kB)
      .data : 0xc048a7c3 - 0xc0595e98   (1069 kB)
      .text : 0xc0100000 - 0xc048a7c3   (3625 kB)
Checking if this processor honours the WP bit even in supervisor
mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4189.45 BogoMIPS (lpj=2094726)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz stepping 06
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4440.64 BogoMIPS
(lpj=2220321)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (8630.09 BogoMIPS).
net_namespace: 596 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query honored via cmdline
ACPI: DMI System Vendor: LENOVO
ACPI: DMI Product Name: 0769K2G
ACPI: DMI Product Version: 3000 N200
ACPI: DMI Board Name: IEL10
ACPI: DMI BIOS Vendor: LENOVO
ACPI: DMI BIOS Date: 01/03/2008
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE storm detected, disabling EC GPE
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
PCI: 0000:00:1a.0 reg 20 io port: [1800, 181f]
PCI: 0000:00:1a.1 reg 20 io port: [1820, 183f]
PCI: 0000:00:1a.7 reg 10 32bit mmio: [fc304000, fc3043ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [fc300000, fc303fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1840, 185f]
PCI: 0000:00:1d.1 reg 20 io port: [1860, 187f]
PCI: 0000:00:1d.2 reg 20 io port: [1880, 189f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [fc304400, fc3047ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6
ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
PCI: 0000:00:1f.1 reg 20 io port: [18a0, 18af]
PCI: 0000:00:1f.2 reg 10 io port: [18f8, 18ff]
PCI: 0000:00:1f.2 reg 14 io port: [18cc, 18cf]
PCI: 0000:00:1f.2 reg 18 io port: [18f0, 18f7]
PCI: 0000:00:1f.2 reg 1c io port: [18c8, 18cb]
PCI: 0000:00:1f.2 reg 20 io port: [18e0, 18ef]
PCI: 0000:00:1f.2 reg 24 io port: [18d0, 18df]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 10 32bit mmio: [0, ff]
PCI: 0000:00:1f.3 reg 20 io port: [1c00, 1c1f]
PCI: 0000:01:00.0 reg 10 32bit mmio: [c9000000, c9ffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [d0000000, dfffffff]
PCI: 0000:01:00.0 reg 1c 64bit mmio: [ca000000, caffffff]
PCI: 0000:01:00.0 reg 30 32bit mmio: [0, 1ffff]
PCI: bridge 0000:00:01.0 32bit mmio: [c9000000, caffffff]
PCI: bridge 0000:00:01.0 64bit mmio pref: [d0000000, dfffffff]
PCI: bridge 0000:00:1c.0 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [f6000000, f7ffffff]
PCI: bridge 0000:00:1c.0 64bit mmio pref: [f0000000, f1ffffff]
PCI: 0000:04:00.0 reg 10 64bit mmio: [f8000000, f8001fff]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [f8000000, f9ffffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [f2000000, f3ffffff]
PCI: bridge 0000:00:1c.2 io port: [4000, 4fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [fa000000, fbffffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [f4000000, f5ffffff]
PCI: 0000:06:00.0 reg 10 64bit mmio: [c6000000, c600ffff]
pci 0000:06:00.0: PME# supported from D3hot D3cold
pci 0000:06:00.0: PME# disabled
PCI: bridge 0000:00:1c.3 io port: [5000, 5fff]
PCI: bridge 0000:00:1c.3 32bit mmio: [c6000000, c7ffffff]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [cc000000, cdffffff]
PCI: 0000:08:06.0 reg 10 32bit mmio: [fc000000, fc0007ff]
pci 0000:08:06.0: supports D1
pci 0000:08:06.0: supports D2
pci 0000:08:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:06.0: PME# disabled
PCI: 0000:08:06.1 reg 10 32bit mmio: [fc000800, fc0008ff]
pci 0000:08:06.1: supports D1
pci 0000:08:06.1: supports D2
pci 0000:08:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:06.1: PME# disabled
PCI: 0000:08:06.2 reg 10 32bit mmio: [fc000c00, fc000cff]
pci 0000:08:06.2: supports D1
pci 0000:08:06.2: supports D2
pci 0000:08:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:06.2: PME# disabled
PCI: 0000:08:06.3 reg 10 32bit mmio: [fc001000, fc0010ff]
pci 0000:08:06.3: supports D1
pci 0000:08:06.3: supports D2
pci 0000:08:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:06.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [fc000000, fc0fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0xfe00-0xfe00 has been reserved
system 00:06: ioport range 0xff00-0xff7f has been reserved
pci 0000:01:00.0: BAR 6: can't allocate mem resource
[0xe0000000-0xdfffffff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xc9000000-0xcaffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x000000f1ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f2000000-0x000000f3ffffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
pci 0000:00:1c.2:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000f4000000-0x000000f5ffffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
pci 0000:00:1c.3:   MEM window: 0xc6000000-0xc7ffffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000cc000000-0x000000cdffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xfc000000-0xfc0fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [c9000000, caffffff]
bus: 01 index 2 mmio: [d0000000, dfffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [2000, 2fff]
bus: 02 index 1 mmio: [f6000000, f7ffffff]
bus: 02 index 2 mmio: [f0000000, f1ffffff]
bus: 02 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [3000, 3fff]
bus: 04 index 1 mmio: [f8000000, f9ffffff]
bus: 04 index 2 mmio: [f2000000, f3ffffff]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 io port: [4000, 4fff]
bus: 05 index 1 mmio: [fa000000, fbffffff]
bus: 05 index 2 mmio: [f4000000, f5ffffff]
bus: 05 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [5000, 5fff]
bus: 06 index 1 mmio: [c6000000, c7ffffff]
bus: 06 index 2 mmio: [cc000000, cdffffff]
bus: 06 index 3 mmio: [0, 0]
bus: 08 index 0 mmio: [0, 0]
bus: 08 index 1 mmio: [fc000000, fc0fffff]
bus: 08 index 2 mmio: [0, 0]
bus: 08 index 3 io port: [0, ffff]
bus: 08 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2030k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS not found.
highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
JFS: nTxBlock = 8066, nTxLock = 64533
SGI XFS with security attributes, large block numbers, no debug
enabled
msgmni has been set to 1763
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie02: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
uvesafb: unrecognized option mtrr
uvesafb: NVIDIA Corporation, G72 Board - e463h0v , Chip Rev   , OEM:
NVIDIA, VBE v3.0
uvesafb: protected mode interface info at c000:c600
uvesafb: pmi: set display start = c00cc636, set palette = c00cc6a0
uvesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc
3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
uvesafb: VBIOS/hardware doesn't support DDC transfers
uvesafb: no monitor limits have been set, default refresh rate will be
used
uvesafb: scrolling: ywrap using protected mode interface,
yres_virtual=2048
Console: switching to colour frame buffer device 160x64
fbcondecor: console 0 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 0
uvesafb: framebuffer at 0xd0000000, mapped to 0xf8d00000, using
10240k, total 262144k
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT 3FED8B28, 027A (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3FED84B9, 05EA (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FED8DA2, 00C8 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3FED8AA3, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x2850 rev 0x03)
pci 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x18a0-0x18a7
    ide1: BM-DMA at 0x18a8-0x18af
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x18f8 ctl 0x18cc bmdma 0x18e0 irq 19
ata2: SATA max UDMA/133 cmd 0x18f0 ctl 0x18c8 bmdma 0x18e8 irq 19
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: WDC WD1600BEVS-08RST2, 08.01G08, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 08.0 PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
cpuidle: using governor ladder
Marking TSC unstable due to TSC halts in idle
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Starting balanced_irq
Using IPI No-Shortcut mode
Freeing unused kernel memory: 288k freed
ata1: hard resetting link
Clocksource tsc unstable (delta = -343675053 ns)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x25c0b1, caps:
0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input4
NCR53c406a: no available ports found
scsi: <fdomain> Detection failed (no card)
GDT-HA: Storage RAID Controller Driver. Version: 3.05
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
Adaptec aacraid driver 1.1-5[2456]-ms
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfc304000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfc304400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb 1-4: new high speed USB device using ehci_hcd and address 3
usb 1-4: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001820
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001840
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 4-1: new full speed USB device using uhci_hcd and address 2
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001860
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 4-1: configuration #1 chosen from 1 choice
usb 5-1: new low speed USB device using uhci_hcd and address 2
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001880
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 5-1: configuration #1 chosen from 1 choice
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
usb 6-2: new full speed USB device using uhci_hcd and address 2
usb 6-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: USB Optical Mouse as /class/input/input5
input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ohci1394 0000:08:06.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]
MMIO=[fc000000-fc0007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
tg3.c:v3.94 (August 14, 2008)
tg3 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
tg3 0000:06:00.0: setting latency timer to 64
eth0: Tigon3 [partno(BCM95906) rev c002 PHY(5906)] (PCI Express)
10/100Base-TX Ethernet 00:1b:38:0e:2a:26
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f81ac4034b0]
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts with ACPI
region SMBI [0x1c00-0x1c0f]
ACPI: Device needs an ACPI driver
sdhci-pci 0000:08:06.1: SDHCI controller found [1180:0822] (rev 19)
sdhci-pci 0000:08:06.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
Registered led device: mmc0
mmc0: SDHCI controller on PCI [0000:08:06.1] using PIO
Linux video capture interface: v2.00
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.3
usbcore: registered new interface driver btusb
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:04:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:04:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (04f2:b013)
input: USB 2.0 Camera as /class/input/input6
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
Linux agpgart interface v0.103
acpi device:05: registered as cooling_device2
input: Video Bus as /class/input/input7
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input8
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:01:00.0: power state changed by ACPI to D0
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct  1
14:38:10 PDT 2008
EXT3 FS on sda3, internal journal
Adding 1992052k swap on /dev/sda2.  Priority:-1 extents:1
across:1992052k
iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:04:00.0: restoring config space at offset 0x1 (was
0x40100102, writing 0x40100106)
firmware: requesting iwlwifi-4965-2.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
fbcondecor: console 1 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 1
fbcondecor: console 2 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 2
fbcondecor: console 3 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 3
fbcondecor: console 4 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 4
fbcondecor: console 5 using theme 'livecd-2007.0'
fbcondecor: switched decor state to 'on' on console 5
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
wlan0: authenticate with AP 00:1d:7e:bc:3d:bd
wlan0: authenticated
wlan0: associate with AP 00:1d:7e:bc:3d:bd
wlan0: RX AssocResp from 00:1d:7e:bc:3d:bd (capab=0x411 status=0
aid=1)
wlan0: associated

I haven' occured any immediately-obvious problems. Maybe just with my
suspend2ram that it doesn' work but I don' think if that has anything
to do with this error.
