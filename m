Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJFVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJFVTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYJFVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:19:15 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:47089 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752453AbYJFVTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:19:13 -0400
Date: Mon, 6 Oct 2008 23:19:06 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081006211906.GA31148@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E899F9.9040206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-10-05 19:42 +0900 schrieb Tejun Heo:

> Right, the commit fixes generic and CK804 while break nf2/3.  Can you
> also try the following patch?
> 
>   http://article.gmane.org/gmane.linux.ide/34942/raw

Hm, sadly doesn't look so well:

Linux version 2.6.27-rc8 (root@zappa) (gcc version 4.3.1 (Gentoo 4.3.1-r1 p
2 CEST 2008
Command line: auto BOOT_IMAGE=linux ro root=801 netconsole=6665@10.10.0.1/e
5:68:2c:eb loglevel=8 debug
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
 BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
 BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
last_pfn = 0x3ffb0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ffb0000 page 4k
kernel direct mapping tables up to 3ffb0000 @ 8000-b000
last_map_addr: 3ffb0000 end: 3ffb0000
DMI 2.3 present.
ACPI: RSDP 000F8710, 0014 (r0 ACPIAM)
ACPI: RSDT 3FFB0000, 0030 (r1 A M I  OEMRSDT   8000607 MSFT       97)
ACPI: FACP 3FFB0200, 0084 (r2 A M I  OEMFACP   8000607 MSFT       97)
ACPI: DSDT 3FFB03F0, 3F26 (r1  K8UNF K8UNF201      201 INTL  2002026)
ACPI: FACS 3FFC0000, 0040
ACPI: APIC 3FFB0390, 005C (r1 A M I  OEMAPIC   8000607 MSFT       97)
ACPI: OEMB 3FFC0040, 0056 (r1 A M I  AMI_OEM   8000607 MSFT       97)
(4 early reservations) ==> bootmem [0000000000 - 003ffb0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 000000100
  #1 [0000200000 - 000058a730]    TEXT DATA BSS ==> [0000200000 - 000058a73
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 000010000
  #3 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 000000900
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff880001200000-ffff880001fff
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003ffb0
On node 0 totalpages: 261967
  DMA zone: 2939 pages, LIFO batch:0
  DMA32 zone: 254441 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bf7c0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257380
Kernel command line: auto BOOT_IMAGE=linux ro root=801 netconsole=6665@10.1
00:22:15:68:2c:eb loglevel=8 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1607.798 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
AGP bridge at 00:00:00
Aperture from AGP @ f8000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
Node 0: aperture @ 94f8000000 size 64 MB
Aperture beyond 4GB. Ignoring.
Memory: 1027656k/1048256k available (2338k kernel code, 19716k reserved, 81
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer frequency..
92)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
tseg: 0000000000
CPU: AMD Sempron(tm) Processor 2800+ stepping 02
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
Using local APIC timer interrupts.
APIC timer calibration result 12560917
Detected 12.560 MHz APIC timer.
net_namespace: 1136 bytes
NET: Registered protocol family 16
No dock devices found.
node 0 link 0: io port [1000, ffffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [40000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:00.0 reg 10 32bit mmio: [f8000000, fbffffff]
PCI: 0000:00:01.1 reg 10 io port: [5080, 509f]
PCI: 0000:00:01.1 reg 20 io port: [5000, 503f]
PCI: 0000:00:01.1 reg 24 io port: [5040, 507f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
PCI: 0000:00:02.0 reg 10 32bit mmio: [febff000, febfffff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
PCI: 0000:00:02.1 reg 10 32bit mmio: [febfe000, febfefff]
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
PCI: 0000:00:02.2 reg 10 32bit mmio: [febfdc00, febfdcff]
pci 0000:00:02.2: supports D1
pci 0000:00:02.2: supports D2
pci 0000:00:02.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.2: PME# disabled
PCI: 0000:00:05.0 reg 10 32bit mmio: [febfc000, febfcfff]
PCI: 0000:00:05.0 reg 14 io port: [ec00, ec07]
pci 0000:00:05.0: supports D1
pci 0000:00:05.0: supports D2
pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:05.0: PME# disabled
PCI: 0000:00:06.0 reg 10 io port: [e800, e8ff]
PCI: 0000:00:06.0 reg 14 io port: [e480, e4ff]
PCI: 0000:00:06.0 reg 18 32bit mmio: [febfb000, febfbfff]
pci 0000:00:06.0: supports D1
pci 0000:00:06.0: supports D2
PCI: 0000:00:08.0 reg 20 io port: [ffa0, ffaf]
PCI: 0000:00:0a.0 reg 10 io port: [f80, f87]
PCI: 0000:00:0a.0 reg 14 io port: [f00, f03]
PCI: 0000:00:0a.0 reg 18 io port: [e80, e87]
PCI: 0000:00:0a.0 reg 1c io port: [e00, e03]
PCI: 0000:00:0a.0 reg 20 io port: [d800, d80f]
PCI: 0000:00:0a.0 reg 24 io port: [d400, d47f]
PCI: 0000:01:00.0 reg 10 32bit mmio: [fd000000, fdffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [e8000000, efffffff]
PCI: 0000:01:00.0 reg 30 32bit mmio: [fe9e0000, fe9fffff]
PCI: bridge 0000:00:0b.0 32bit mmio: [fc900000, fe9fffff]
PCI: bridge 0000:00:0b.0 32bit mmio pref: [e4800000, f47fffff]
PCI: 0000:02:06.0 reg 10 io port: [c800, c8ff]
PCI: 0000:02:06.0 reg 14 32bit mmio: [feaffc00, feaffcff]
PCI: 0000:02:06.0 reg 30 32bit mmio: [fffe0000, ffffffff]
pci 0000:02:06.0: supports D1
pci 0000:02:06.0: supports D2
pci 0000:02:06.0: PME# supported from D1 D2 D3hot
pci 0000:02:06.0: PME# disabled
PCI: bridge 0000:00:0e.0 io port: [c000, cfff]
PCI: bridge 0000:00:0e.0 32bit mmio: [fea00000, feafffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 22) *14
ACPI: Power Resource [ISAV] (on)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - E0, shoul
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
agpgart-amd64 0000:00:00.0: AGP bridge [10de/00e1]
agpgart-amd64 0000:00:00.0: setting up Nforce3 AGP
agpgart-amd64 0000:00:00.0: AGP aperture is 32M @ 0xf8000000
ACPI: RTC can wake from S4
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x4000-0x407f has been reserved
system 00:09: ioport range 0x4080-0x40ff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:0a: iomem range 0xff7c0000-0xffffffff could not be reserved
system 00:0c: ioport range 0x290-0x29f has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xfc900000-0xfe9fffff
pci 0000:00:0b.0:   PREFETCH window: 0x000000e4800000-0x000000f47fffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0xc000-0xcfff
pci 0000:00:0e.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:0e.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [fc900000, fe9fffff]
bus: 01 index 2 mmio: [e4800000, f47fffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [c000, cfff]
bus: 02 index 1 mmio: [fea00000, feafffff]
bus: 02 index 2 mmio: [50000000, 500fffff]
bus: 02 index 3 mmio: [0, 0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers
SGI XFS Quota Management subsystem
msgmni has been set to 2008
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Linux agpgart interface v0.103
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
forcedeth 0000:00:05.0: PCI INT A -> Link[LKLN] -> GSI 22 (level, low) -> I
forcedeth 0000:00:05.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
Switched to high resolution mode on CPU 0
forcedeth 0000:00:05.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:13:8f:fd:f9
forcedeth 0000:00:05.0: csum timirq lnktim desc-v2
netconsole: local port 6665
netconsole: local IP 10.10.0.1
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 10.10.0.18
netconsole: remote ethernet address 00:22:15:68:2c:eb
netconsole: device eth0 not up yet, forcing it
eth0: no link during initialization.
eth0: link up.
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: link online but device misclassified, retrying
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: link online but device misclassified, retrying
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI:
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
TCP cubic registered
NET: Registered protocol family 17
XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
Ending XFS recovery on filesystem: sda1 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 220k freed
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
processor ACPI0007:00: registered as cooling_device0
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input
ACPI: Power Button (CM) [PWRB]
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EP
parport0: Printer, Kyocera Mita FS-1000+
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 20 (level, low) -> IR
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 20, io mem 0xfebff000
sd 0:0:0:0: Attached scsi generic sg0 type 0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 22
ohci_hcd 0000:00:02.1: PCI INT B -> Link[LUS1] -> GSI 22 (level, low) -> IR
ohci_hcd 0000:00:02.1: setting latency timer to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.1: irq 22, io mem 0xfebfe000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 21
ehci_hcd 0000:00:02.2: PCI INT C -> Link[LUS2] -> GSI 21 (level, low) -> IR
ehci_hcd 0000:00:02.2: setting latency timer to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.2: debug port 0
ehci_hcd 0000:00:02.2: cache line size of 64 is not supported
ehci_hcd 0000:00:02.2: irq 21, io mem 0xfebfdc00
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 8 ports detected
pata_amd 0000:00:08.0: version 0.3.10
pata_amd 0000:00:08.0: power state changed by ACPI to D0
pata_amd 0000:00:08.0: setting latency timer to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata4.00: ATAPI: HL-DT-ST CD-ROM GCR-8520B, 1.00, max MWDMA2
ata4: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=0x0 (0x0) ACPI=0x39f (120:60
ata4.00: configured for MWDMA2
scsi 3:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8520B 1.00 PQ: 0 ANSI:
scsi 3:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
8139too 0000:02:06.0: PCI INT A -> Link[LNKC] -> GSI 19 (level, low) -> IRQ
eth1: RealTek RTL8139 at 0xffffc20000066c00, 00:a1:b0:f0:2b:d1, IRQ 19
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
usb 2-2: new full speed USB device using ohci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0
usbcore: registered new interface driver usblp
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
lp0: using parport0 (interrupt-driven).
XFS mounting filesystem sda3
Ending clean XFS mount for filesystem: sda3
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
XFS mounting filesystem sda9
Ending clean XFS mount for filesystem: sda9
XFS mounting filesystem sda7
Starting XFS recovery on filesystem: sda7 (logdev: internal)
Ending XFS recovery on filesystem: sda7 (logdev: internal)
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sda6, internal journal
EXT4-fs: mounted filesystem with journal data mode.
EXT4-fs: Ignoring delalloc option - requested data journaling mode
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
PPP generic driver version 2.4.2
NET: Registered protocol family 24
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period

May be my engine has a problem with the disk itself additionaly?

ata1: link online but device misclassified, retrying

Regards, Konsti



-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
