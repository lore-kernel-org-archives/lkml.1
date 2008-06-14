Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYFNW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYFNW45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYFNW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:56:48 -0400
Received: from daemonizer.de ([87.230.16.230]:52481 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbYFNW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:56:44 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 18:56:43 EDT
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [regression] display dimming is slow and laggy
Date: Sun, 15 Jun 2008 00:31:36 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1505619.tW779LsU5C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806150031.39971.maxi@daemonizer.de>
X-Spam-Score: -4.3 (----)
X-Spam-Report: No, hits=-4.3 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.2.3 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.1 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1505619.tW779LsU5C
Content-Type: multipart/mixed;
  boundary="Boundary-01=_IbEVIiQTpWNJr7y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_IbEVIiQTpWNJr7y
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I'm using kernel 2.6.26-rc6 at the moment and with it dimming the display i=
s=20
slow and laggy. Using kernel 2.6.25 doesn't show this problem.

Here is a more detailed explanation:

I'm dimming my display with the appropriate keys on my laptop (Fn +=20
right/left). Till kernel 2.6.25 this has worked without any problems. Now I=
'm=20
using 2.6.26-rc6 and using the keys the display is dimming much slower and=
=20
also laggy. By laggy I mean if I hit the keys for increasing/decreasing=20
brightness it starts dimming and when I release the keys after some time it=
=20
still continues dimming for some steps.

My laptop is a Acer Travelmate 661lci and has an Intel 855 chipset.

I'll attach my dmesg output, please tell me if you need any further=20
information.

Maxi

--Boundary-01=_IbEVIiQTpWNJr7y
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.26-rc6 (root@koala) (gcc version 4.3.1 (Debian 4.3.1-2) )=
 #1 PREEMPT Sat Jun 14 23:41:54 CEST 2008
PAT disabled. Not yet verified on this CPU type.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000004dee0000 (usable)
 BIOS-e820: 000000004dee0000 - 000000004deec000 (ACPI data)
 BIOS-e820: 000000004deec000 - 000000004df00000 (ACPI NVS)
 BIOS-e820: 000000004df00000 - 0000000050000000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
350MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 319200) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   319200
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   319200
On node 0 totalpages: 319200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 702 pages used for memmap
  HighMem zone: 89122 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F6050, 0014 (r0 ACER  )
ACPI: RSDT 4DEE5A39, 0030 (r1 ACER   Wagtail  20020114  LTP        0)
ACPI: FACP 4DEEBF2C, 0074 (r1 ACER   Wagtail  20020114 PTL        50)
ACPI: DSDT 4DEE5A69, 64C3 (r1 ACER   Wagtail  20020114 MSFT  100000E)
ACPI: FACS 4DEFCFC0, 0040
ACPI: HPET 4DEEBFA0, 0038 (r1 ACER   Wagtail  20020114 PTL         0)
ACPI: BOOT 4DEEBFD8, 0028 (r1 ACER   Wagtail  20020114  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: HPET id: 0x8086a201 base: 0x0 is invalid
Allocating PCI resources starting at 60000000 (gap: 50000000:aec10000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
PM: Registered nosave memory: 00000000000ce000 - 00000000000d0000
PM: Registered nosave memory: 00000000000d0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 316706
Kernel command line: root=3D/dev/sda1 ro vga=3D0x31b resume=3D/dev/sda2 mac=
80211.ieee80211_regdom=3D64
Unknown boot option `mac80211.ieee80211_regdom=3D64': ignoring
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1395.499 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1259088k/1276800k available (3895k kernel code, 16916k reserved, 14=
74k data, 220k init, 359296k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe9000 - 0xfffff000   (  88 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0642000 - 0xc0679000   ( 220 kB)
      .data : 0xc04cdfb0 - 0xc063e9f0   (1474 kB)
      .text : 0xc0100000 - 0xc04cdfb0   (3895 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
Calibrating delay using timer specific routine.. 2792.83 BogoMIPS (lpj=3D55=
85660)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) M processor 1400MHz stepping 05
Checking 'hlt' instruction... OK.
=46reeing SMP alternatives: 0k freed
ACPI: Core revision 20080321
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 628 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: \_SB_.PCI0.IDE0.SECN.BAY1: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.SECN.BAY1: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.SECN.BAY1] Added
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=3D2
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Device [SECN] status [00000008]: functional but not present; setting =
present
ACPI: Device [BAY1] status [00000008]: functional but not present; setting =
present
ACPI: EC: GPE =3D 0x1d, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:04: ioport range 0x600-0x60f has been reserved
system 00:04: ioport range 0x700-0x70f has been reserved
system 00:04: ioport range 0x800-0x80f has been reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1180-0x11bf has been reserved
system 00:04: ioport range 0x1c0-0x1cf has been reserved
system 00:04: ioport range 0xfe00-0xfe00 has been reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
system 00:04: ioport range 0x610-0x61f has been reserved
system 00:04: iomem range 0xfec10000-0xfec1ffff could not be reserved
system 00:04: iomem range 0xff800000-0xffbfffff could not be reserved
system 00:04: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:04: iomem range 0x0-0x9ffff could not be reserved
system 00:04: iomem range 0xe0000-0xfffff could not be reserved
PCI: region 0000:02:06.0/9 too large: 0x0000000000000000-0x0000000003ffffff
PCI: region 0000:02:06.1/9 too large: 0x0000000000000000-0x0000000003ffffff
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 0x00003000-0x000030ff
  IO window: 0x00003400-0x000034ff
  MEM window: 0x64000000-0x67ffffff
PCI: Bus 7, cardbus bridge: 0000:02:06.1
  IO window: 0x00003800-0x000038ff
  IO window: 0x00003c00-0x00003cff
  MEM window: 0x68000000-0x6bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: 0xe0200000-0xe07fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x37 set to 0x1
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
msgmni has been set to 1758
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
vesafb: framebuffer at 0xe8000000, mapped to 0xf8880000, using 10240k, tota=
l 32576k
vesafb: mode is 1280x1024x32, linelength=3D5120, pages=3D5
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (on-line)
ACPI: EC: GPE storm detected, disabling EC GPE
Switched to high resolution mode on CPU 0
ACPI: Battery Slot [BAT1] (battery present)
ACPI: Battery Slot [BAT2] (battery absent)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input=
/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: Transitioning device [FAN0] to D3
ACPI: PNP0C0B:00 is registered as cooling_device0
ACPI: Fan [FAN0] (off)
ACPI: Transitioning device [FAN1] to D3
ACPI: PNP0C0B:01 is registered as cooling_device1
ACPI: Fan [FAN1] (off)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/inp=
ut/input3
ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: no)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device2
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (53 C)
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
ppdev: user-space parallel port driver
Linux agpgart interface v0.103
agpgart: Detected an Intel 855GM Chipset.
agpgart: Detected 32636K stolen memory.
agpgart: AGP aperture is 128M @ 0xe8000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
PCI: Setting latency timer of device 0000:00:02.1 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a NS16550A
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EP=
P,ECP,DMA]
lp0: using parport0 (interrupt-driven).
loop: module loaded
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low) -=
> IRQ 10
ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
b44.c:v2.0
eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:29:99:a7
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata1.00: ATA-6: TOSHIBA MK8026GAX, PA001G, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA=20
ata1.00: configured for UDMA/100
ata2: port disabled. ignoring.
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8026GA PA00 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[10]  MMIO=3D[e020a000-e020a=
7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
ieee1394: raw1394: /dev/raw1394 device initialized
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
Yenta: CardBus bridge found at 0000:02:06.0 [1025:0035]
yenta 0000:02:06.0: Preassigned resource 2 busy or not available, reconfigu=
ring...
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 0x00003000-0x000030ff
  IO window: 0x00003400-0x000034ff
  PREFETCH window: 0xe0400000-0xe07fffff
  MEM window: 0x64000000-0x67ffffff
Yenta O2: res at 0x94/0xD4: 00/ea
Yenta O2: enabling read prefetch/write burst
Yenta: ISA IRQ mask 0x0038, PCI irq 10
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe0200000 - 0xe07fffff
Yenta: CardBus bridge found at 0000:02:06.1 [1025:0035]
yenta 0000:02:06.1: Preassigned resource 2 busy or not available, reconfigu=
ring...
PCI: Bus 7, cardbus bridge: 0000:02:06.1
  IO window: 0x00003800-0x000038ff
  IO window: 0x00003c00-0x00003cff
  PREFETCH window: 0x60400000-0x607fffff
  MEM window: 0x68000000-0x6bffffff
Yenta: ISA IRQ mask 0x0038, PCI irq 10
Socket status: 30000410
Yenta: Raising subordinate bus# of parent bus (#02) from #06 to #0a
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe0200000 - 0xe07fffff
usbmon: debugfs is not available
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00c09f00000d5d2d]
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
pccard: PCMCIA card inserted into slot 1
cs: memory probe 0xe0200000-0xe07fffff: excluding 0xe0200000-0xe025ffff 0xe=
03e0000-0xe07fffff
pcmcia: registering new device pcmcia1.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
hub 4-2:1.0: USB hub found
hub 4-2:1.0: 3 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usb 4-2.3: new full speed USB device using uhci_hcd and address 3
usb 4-2.3: configuration #1 chosen from 1 choice
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input4
input: PC Speaker as /devices/platform/pcspkr/input/input5
Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/i=
nput6
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to: TSC halts in idle.
input: Logitech USB Trackball as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/=
2-1:1.0/input/input7
input: USB HID v1.10 Mouse [Logitech USB Trackball] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16.
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 55881 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.6 to 64
ALSA device list:
  #0: Intel 82801DB-ICH4 with ALC202 at irq 10
  #1: Intel 82801DB-ICH4 Modem at irq 10
GACT probability on
Mirror/redirect action on
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on=20
    Actions configured=20
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
ip6tnl0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
=46reeing unused kernel memory: 220k freed
Clocksource tsc unstable (delta =3D -244803632 ns)
scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0 ANSI: 2
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [LNKE] -> GSI 10 (level, low) -=
> IRQ 10
firmware: requesting isl3886
p54: LM86 firmware
p54: FW rev 2.7.0.0 - Softmac protocol 4.1
p54: unknown eeprom code : 0x1
p54: unknown eeprom code : 0x1007
p54: unknown eeprom code : 0x1008
p54: unknown eeprom code : 0x1100
p54: unknown eeprom code : 0x3
p54: unknown eeprom code : 0x1905
phy0: Selected rate control algorithm 'pid'
phy0: hwaddr 00:60:b3:91:45:5b, isl3890
udev: renamed network interface wlan0 to eth1
Adding 2001880k swap on /dev/sda2.  Priority:-1 extents:1 across:2001880k
EXT3 FS on sda1, internal journal
ADDRCONF(NETDEV_UP): eth0: link is not ready
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)

--Boundary-01=_IbEVIiQTpWNJr7y--

--nextPart1505619.tW779LsU5C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhURsgACgkQOimwv528XGEl9ACgu9UQxf8OLYQmvhH65WKiqI7j
YZQAoK7gNolIR8RoMsvOf1OxWktyad67
=we0Z
-----END PGP SIGNATURE-----

--nextPart1505619.tW779LsU5C--
