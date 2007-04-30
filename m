Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXD3M3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXD3M3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXD3M3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:29:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:55569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755148AbXD3M3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:29:17 -0400
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX1+6RwZJENK6P+JJvJjqt+EVPMmNG1g8Ukr5Xe9z7R
	v5AeUnsxRBjWW6
Date: Mon, 30 Apr 2007 14:29:41 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: sebastian_ml@gmx.net
Subject: 2.6.21: ACPI related kernel panic
Message-ID: <20070430122940.GA25848@anna.darkstar.lan>
Mail-Followup-To: Sebastian Kemper <sebastian_ml@gmx.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello all,

I have updated some different boxes to 2.6.21 with success. One laptop,
though, has some issue with it.

It's an Acer TravelMate 4002WLMi. Sometimes it boots fine and sometimes
not. Thanks to netconsole you can see what happens when it boots fine in
the attached bootsie.out.good. bootsie.out shows what happens on the
screen when things get out of hand (kernel panic).

Also attached you'll find the output of lspci, lsusb, ver_linux and the
kernel configuration.

If there's more you need (git bisection or more info in general,
testing ...) just say so.

Thanks in advance!

Regards
Sebastian

P.S.: Please CC.

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bootsie.out.good"

Linux version 2.6.21.1 (root@raven) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #2 Mon Apr 30 14:01:38 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000dc000 size: 0000000000024000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fde0000 end: 000000001fee0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fee0000 size: 000000000000c000 end: 000000001feec000 type: 3
copy_e820_map() start: 000000001feec000 size: 0000000000014000 end: 000000001ff00000 type: 4
copy_e820_map() start: 000000001ff00000 size: 0000000000100000 end: 0000000020000000 type: 2
copy_e820_map() start: 00000000fec10000 size: 0000000000010000 end: 00000000fec20000 type: 2
copy_e820_map() start: 00000000ff800000 size: 0000000000400000 end: 00000000ffc00000 type: 2
copy_e820_map() start: 00000000fffffc00 size: 0000000000000400 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fee0000 (usable)
 BIOS-e820: 000000001fee0000 - 000000001feec000 (ACPI data)
 BIOS-e820: 000000001feec000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
510MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130784
early_node_map[1] active PFN ranges
    0:        0 ->   130784
DMI present.
ACPI: RSDP 000F62C0, 0014 (r0 ACER  )
ACPI: RSDT 1FEE6205, 0030 (r1 ACER   Kestrel  20021012  LTP        0)
ACPI: FACP 1FEEBF2C, 0074 (r1 ACER   Kestrel  20021012 PTL        50)
ACPI: DSDT 1FEE6235, 5CF7 (r1 ACER   Kestrel  20021012 MSFT  100000E)
ACPI: FACS 1FEFCFC0, 0040
ACPI: HPET 1FEEBFA0, 0038 (r1 ACER   Kestrel  20021012 PTL         0)
ACPI: BOOT 1FEEBFD8, 0028 (r1 ACER   Kestrel  20021012  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: HPET id: 0x8086a201 base: 0x0
Allocating PCI resources starting at 30000000 (gap: 20000000:dec10000)
Built 1 zonelists.  Total pages: 129763
Kernel command line: BOOT_IMAGE=test ro root=302 snd-ac97-codec.power_save=1 pci=assign-busses netconsole=6665@192.168.0.2/eth0,6666@192.168.0.1/00:0A:E6:80:9F:18
netconsole: local port 6665
netconsole: local IP 192.168.0.2
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 192.168.0.1
netconsole: remote ethernet address 00:0a:e6:80:9f:18
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1598.701 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515628k/523136k available (1635k kernel code, 7020k reserved, 617k data, 120k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff9000 - 0xfffff000   (  24 kB)
    vmalloc : 0xe0800000 - 0xffff7000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfee0000   ( 510 MB)
      .init : 0xc0336000 - 0xc0354000   ( 120 kB)
      .data : 0xc0298d8b - 0xc0333514   ( 617 kB)
      .text : 0xc0100000 - 0xc0298d8b   (1635 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3199.70 BogoMIPS (lpj=5330725)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0440)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs *6)
ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
ACPI: PCI Interrupt Link [LNKD] (IRQs *6)
ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 6) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 8 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:04: ioport range 0x164e-0x164f has been reserved
pnp: 00:04: iomem range 0xfec10000-0xfec1ffff could not be reserved
pnp: 00:04: iomem range 0xff800000-0xffbfffff could not be reserved
pnp: 00:04: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:04: iomem range 0x0-0x9ffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: d0100000-d01fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 00004000-000040ff
  IO window: 00004400-000044ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 38000000-3bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-4fff
  MEM window: d0200000-d05fffff
  PREFETCH window: 30000000-35ffffff
PCI: Enabling device 0000:02:06.0 (0104 -> 0107)
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKE] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Simple Boot Flag at 0x37 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 6
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 6 (level, low) -> IRQ 6
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=6) Memory=450.00 Mhz, System=210.00 MHz
radeonfb: PLL min 20000 max 35000
Non-DDC laptop panel detected
radeonfb: Monitor 1 type LCD found
radeonfb: Monitor 2 type no found
radeonfb: panel ID string: QDS                     
radeonfb: detected LVDS panel size from BIOS: 1280x800
radeondb: BIOS provided dividers will be used
radeonfb: Dynamic Clock Power Management enabled
Console: switching to colour frame buffer device 160x50
radeonfb (0000:01:00.0): ATI Radeon NP 
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: Transitioning device [FAN0] to D3
ACPI: Transitioning device [FAN0] to D3
ACPI: Fan [FAN0] (off)
ACPI: Transitioning device [FAN1] to D3
ACPI: Transitioning device [FAN1] to D3
ACPI: Fan [FAN1] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (56 C)
ACPI: EC HC smbus [SMBC]
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
ACPI: Smart Battery System [SBS0]
b44.c:v1.01 (Jun 16, 2006)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 6
ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 6 (level, low) -> IRQ 6
eth0: Broadcom 4400 10/100BaseT Ethernet 00:c0:9f:6f:cd:09
netconsole: device eth0 not up yet, forcing it
Clocksource tsc unstable (delta = -203585472 ns)
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 6
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 6 (level, low) -> IRQ 6
ICH4: chipset revision 3
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1860-0x1867, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1868-0x186f, BIOS settings: hdc:DMA, hdd:pio
hda: TOSHIBA MK8025GAS, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: Slimtype DVDRW SOSW-833S, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB), CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xd0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 6 (level, low) -> IRQ 6
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 6, io base 0x00001800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 6 (level, low) -> IRQ 6
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 6, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 6 (level, low) -> IRQ 6
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 6, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
intel8x0_measure_ac97_clock: measured 53230 usecs
intel8x0: clocking to 48000
ALSA device list:
  #0: Intel 82801DB-ICH4 with unknown codec at irq 10
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Using IPI Shortcut mode
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x126eb1, caps: 0xa04713/0x4000
input: SynPS/2 Synaptics TouchPad as /class/input/input3
input: AT Translated Set 2 keyboard as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 120k freed

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bootsie.out"

Linux version 2.6.21.1 (root@raven) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #2 Mon Apr 30 14:01:38 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000dc000 size: 0000000000024000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fde0000 end: 000000001fee0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fee0000 size: 000000000000c000 end: 000000001feec000 type: 3
copy_e820_map() start: 000000001feec000 size: 0000000000014000 end: 000000001ff00000 type: 4
copy_e820_map() start: 000000001ff00000 size: 0000000000100000 end: 0000000020000000 type: 2
copy_e820_map() start: 00000000fec10000 size: 0000000000010000 end: 00000000fec20000 type: 2
copy_e820_map() start: 00000000ff800000 size: 0000000000400000 end: 00000000ffc00000 type: 2
copy_e820_map() start: 00000000fffffc00 size: 0000000000000400 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fee0000 (usable)
 BIOS-e820: 000000001fee0000 - 000000001feec000 (ACPI data)
 BIOS-e820: 000000001feec000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
510MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130784
early_node_map[1] active PFN ranges
    0:        0 ->   130784
DMI present.
ACPI: RSDP 000F62C0, 0014 (r0 ACER  )
ACPI: RSDT 1FEE6205, 0030 (r1 ACER   Kestrel  20021012  LTP        0)
ACPI: FACP 1FEEBF2C, 0074 (r1 ACER   Kestrel  20021012 PTL        50)
ACPI: DSDT 1FEE6235, 5CF7 (r1 ACER   Kestrel  20021012 MSFT  100000E)
ACPI: FACS 1FEFCFC0, 0040
ACPI: HPET 1FEEBFA0, 0038 (r1 ACER   Kestrel  20021012 PTL         0)
ACPI: BOOT 1FEEBFD8, 0028 (r1 ACER   Kestrel  20021012  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
ACPI: HPET id: 0x8086a201 base: 0x0
Allocating PCI resources starting at 30000000 (gap: 20000000:dec10000)
Built 1 zonelists.  Total pages: 129763
Kernel command line: BOOT_IMAGE=test ro root=302 snd-ac97-codec.power_save=1 pci=assign-busses netconsole=6665@192.168.0.2/eth0,6666@192.168.0.1/00:0A:E6:80:9F:18
netconsole: local port 6665
netconsole: local IP 192.168.0.2
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 192.168.0.1
netconsole: remote ethernet address 00:0a:e6:80:9f:18
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1598.695 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515628k/523136k available (1635k kernel code, 7020k reserved, 617k data, 120k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff9000 - 0xfffff000   (  24 kB)
    vmalloc : 0xe0800000 - 0xffff7000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfee0000   ( 510 MB)
      .init : 0xc0336000 - 0xc0354000   ( 120 kB)
      .data : 0xc0298d8b - 0xc0333514   ( 617 kB)
      .text : 0xc0100000 - 0xc0298d8b   (1635 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3199.70 BogoMIPS (lpj=5330733)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0440)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs *6)
ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
ACPI: PCI Interrupt Link [LNKD] (IRQs *6)
ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 6) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 8 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:04: ioport range 0x164e-0x164f has been reserved
pnp: 00:04: iomem range 0xfec10000-0xfec1ffff could not be reserved
pnp: 00:04: iomem range 0xff800000-0xffbfffff could not be reserved
pnp: 00:04: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:04: iomem range 0x0-0x9ffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: d0100000-d01fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 00004000-000040ff
  IO window: 00004400-000044ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 38000000-3bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-4fff
  MEM window: d0200000-d05fffff
  PREFETCH window: 30000000-35ffffff
PCI: Enabling device 0000:02:06.0 (0104 -> 0107)
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKE] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Simple Boot Flag at 0x37 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 6
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 6 (level, low) -> IRQ 6
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=6) Memory=450.00 Mhz, System=210.00 MHz
radeonfb: PLL min 20000 max 35000
Non-DDC laptop panel detected
radeonfb: Monitor 1 type LCD found
radeonfb: Monitor 2 type no found
radeonfb: panel ID string: QDS                     
radeonfb: detected LVDS panel size from BIOS: 1280x800
radeondb: BIOS provided dividers will be used
radeonfb: Dynamic Clock Power Management enabled
Console: switching to colour frame buffer device 160x50
radeonfb (0000:01:00.0): ATI Radeon NP 
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: Transitioning device [FAN0] to D3
ACPI: Transitioning device [FAN0] to D3
ACPI: Fan [FAN0] (off)
ACPI: Transitioning device [FAN1] to D3
ACPI: Transitioning device [FAN1] to D3
ACPI: Fan [FAN1] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (57 C)
ACPI: EC HC smbus [SMBC]
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
ACPI: Smart Battery System [SBS0]
b44.c:v1.01 (Jun 16, 2006)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 6
ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 6 (level, low) -> IRQ 6
eth0: Broadcom 4400 10/100BaseT Ethernet 00:c0:9f:6f:cd:09
netconsole: device eth0 not up yet, forcing it
Clocksource tsc unstable (delta = -204463490 ns)
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 6
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 6 (level, low) -> IRQ 6
ICH4: chipset revision 3
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1860-0x1867, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1868-0x186f, BIOS settings: hdc:DMA, hdd:pio
hda: TOSHIBA MK8025GAS, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: EC: acpi_ec_wait timeout, status = 40, expect_event = -1052188880
ACPI: EC: acpi_ec_wait timeout, status = 40, expect_event = 10786
hdc: Slimtype DVDRW SOSW-833S, ATAPI CD/DVD-ROM drive
ACPI: EC: acpi_ec_wait timeout, status = 40, expect_event = 10855
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB), CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xd0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: EC: acpi_ec_wait timeout, status = 40, expect_event = 10981
ACPI: EC: write_cmd timeout, command = 128
ACPI Exception (evregion-0424): AE_TIME, Returned by Handler for [EmbeddedControl] [20070126]
ACPI Exception (dswexec-0462): AE_TIME, While resolving operands for [OpcodeName unavailable] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_TZ_.THRM._TMP] (Node dfecd414), AE_TIME
BUG: workqueue leaked lock or atomic: kacpid/0xffffffff/38
    last function: acpi_os_execute_deferred+0x0/0x2b
 [<c011af2b>] run_workqueue+0xc8/0x101
 [<c011b414>] worker_thread+0x105/0x12e
 [<c010d5ab>] default_wake_function+0x0/0xc
 [<c011b30f>] worker_thread+0x0/0x12e
 [<c011d59c>] kthread+0xa0/0xc8
 [<c011d4fc>] kthread+0x0/0xc8
 [<c01025cf>] kernel_thread_helper+0x7/0x10
 [<c01a8b41>] radeon_get_pllinfo+0x830/0xbe3
 [<c01a8b4a>] radeon_get_pllinfo+0x839/0xbe3
 [<c01a8b54>] radeon_get_pllinfo+0x843/0xbe3
 [<c01a8b5e>] radeon_get_pllinfo+0x84d/0xbe3
 [<c01a8b8f>] radeon_get_pllinfo+0x87e/0xbe3
 [<c01a8b6f>] radeon_get_pllinfo+0x85e/0xbe3
 [<c01a8b80>] radeon_get_pllinfo+0x86f/0xbe3
 [<c01b7e9b>] radeon_probe_screens+0x482/0x54f
 [<c01b7ea2>] radeon_probe_screens+0x489/0x54f
 [<c01b7eb0>] radeon_probe_screens+0x497/0x54f
 [<c01b7ea9>] radeon_probe_screens+0x490/0x54f
 [<c01b7eb7>] radeon_probe_screens+0x49e/0x54f
 [<c01b7e94>] radeon_probe_screens+0x47b/0x54f
 [<c01b7f05>] radeon_probe_screens+0x4ec/0x54f
 [<c01b7f0c>] radeon_probe_screens+0x4f3/0x54f
 [<c01b7f1a>] radeon_probe_screens+0x501/0x54f
 [<c01b7f13>] radeon_probe_screens+0x4fa/0x54f
 [<c01b7f21>] radeon_probe_screens+0x508/0x54f
 [<c01b7efe>] radeon_probe_screens+0x4e5/0x54f
 [<c01b8c22>] acpi_table_print_madt_entry+0x22/0x228
 [<c01b8c50>] acpi_table_print_madt_entry+0x50/0x228
 [<c01b8c77>] acpi_table_print_madt_entry+0x77/0x228
 [<c01b8cda>] acpi_table_print_madt_entry+0xda/0x228
 [<c01b8d0e>] acpi_table_print_madt_entry+0x10e/0x228
 [<c01b8d48>] acpi_table_print_madt_entry+0x148/0x228
 [<c01b8d5b>] acpi_table_print_madt_entry+0x15b/0x228
 [<c01b8d7d>] acpi_table_print_madt_entry+0x17d/0x228
 [<c01b8db8>] acpi_table_print_madt_entry+0x1b8/0x228
 [<c01b9d88>] acpi_ds_create_bank_field+0xb4/0x126
 [<c01b9d92>] acpi_ds_create_bank_field+0xbe/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01bb2a0>] acpi_ds_exec_end_op+0x19b/0x3cf
 [<c01bb305>] acpi_ds_exec_end_op+0x200/0x3cf
 [<c01bb324>] acpi_ds_exec_end_op+0x21f/0x3cf
 [<c01bb262>] acpi_ds_exec_end_op+0x15d/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb3f9>] acpi_ds_exec_end_op+0x2f4/0x3cf
 [<c01bb3ce>] acpi_ds_exec_end_op+0x2c9/0x3cf
 [<c01bb434>] acpi_ds_exec_end_op+0x32f/0x3cf
 [<c01c2c7b>] acpi_ex_opcode_0A_0T_1R+0x0/0x95
 [<c01c2bdf>] acpi_ex_opcode_1A_0T_0R+0x0/0x9c
 [<c01c2138>] acpi_ex_opcode_1A_0T_1R+0x0/0x4fb
 [<c01c2b91>] acpi_ex_opcode_1A_1T_0R+0x0/0x4e
 [<c01c2633>] acpi_ex_opcode_1A_1T_1R+0x0/0x55e
 [<c01c4714>] acpi_ex_opcode_2A_0T_0R+0x0/0x98
 [<c01c412c>] acpi_ex_opcode_2A_0T_1R+0x0/0x13a
 [<c01c4266>] acpi_ex_opcode_2A_1T_1R+0x0/0x385
 [<c01c45eb>] acpi_ex_opcode_2A_2T_1R+0x0/0x129
 [<c01c5324>] acpi_ex_opcode_3A_0T_0R+0x0/0x9b
 [<c01c53bf>] acpi_ex_opcode_3A_1T_1R+0x0/0x1bd
 [<c01c0a98>] acpi_ex_opcode_6A_0T_1R+0x0/0x1f4
 [<c01bc696>] acpi_ds_load2_end_op+0x25e/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4af>] acpi_ds_load2_end_op+0x77/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4ba>] acpi_ds_load2_end_op+0x82/0x2d5
 [<c01bc51b>] acpi_ds_load2_end_op+0xe3/0x2d5
 [<c01bc5c4>] acpi_ds_load2_end_op+0x18c/0x2d5
 [<c01bd6bb>] acpi_ev_install_space_handler+0x59/0x1e2
 [<c01bd6ca>] acpi_ev_install_space_handler+0x68/0x1e2
 [<c01bd6d9>] acpi_ev_install_space_handler+0x77/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd6e8>] acpi_ev_install_space_handler+0x86/0x1e2
 [<c01bd821>] acpi_ev_install_space_handler+0x1bf/0x1e2
 [<c01bd6af>] acpi_ev_install_space_handler+0x4d/0x1e2
 [<c01c0a8b>] acpi_ex_do_match+0x8f/0x9c
 [<c01c0a17>] acpi_ex_do_match+0x1b/0x9c
 [<c01c0a29>] acpi_ex_do_match+0x2d/0x9c
 [<c01c0a3b>] acpi_ex_do_match+0x3f/0x9c
 [<c01c0a4d>] acpi_ex_do_match+0x51/0x9c
 [<c01c0a72>] acpi_ex_do_match+0x76/0x9c
 [<c01c1059>] acpi_ex_resolve_to_value+0x1c6/0x245
 [<c01c1062>] acpi_ex_resolve_to_value+0x1cf/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c0ee6>] acpi_ex_resolve_to_value+0x53/0x245
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1662>] acpi_ex_convert_to_target_type+0x2d/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c2c37>] acpi_ex_opcode_1A_0T_0R+0x58/0x9c
 [<c01c2c26>] acpi_ex_opcode_1A_0T_0R+0x47/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c1b>] acpi_ex_opcode_1A_0T_0R+0x3c/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c10>] acpi_ex_opcode_1A_0T_0R+0x31/0x9c
 [<c01c2c05>] acpi_ex_opcode_1A_0T_0R+0x26/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c45>] acpi_ex_opcode_1A_0T_0R+0x66/0x9c
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d42>] acpi_ex_prep_common_field_object+0x32/0xcf
 [<c01c2d4e>] acpi_ex_prep_common_field_object+0x3e/0xcf
 [<c01c2d36>] acpi_ex_prep_common_field_object+0x26/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c324f>] acpi_ex_resolve_operands+0x24e/0x55b
 [<c01c3245>] acpi_ex_resolve_operands+0x244/0x55b
 [<c01c323b>] acpi_ex_resolve_operands+0x23a/0x55b
 [<c01c3231>] acpi_ex_resolve_operands+0x230/0x55b
 [<c01c34ea>] acpi_ex_resolve_operands+0x4e9/0x55b
 [<c01c3256>] acpi_ex_resolve_operands+0x255/0x55b
 [<c01c32e9>] acpi_ex_resolve_operands+0x2e8/0x55b
 [<c01c3298>] acpi_ex_resolve_operands+0x297/0x55b
 [<c01c335c>] acpi_ex_resolve_operands+0x35b/0x55b
 [<c01c332b>] acpi_ex_resolve_operands+0x32a/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c33ba>] acpi_ex_resolve_operands+0x3b9/0x55b
 [<c01c33fa>] acpi_ex_resolve_operands+0x3f9/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c342b>] acpi_ex_resolve_operands+0x42a/0x55b
 [<c01c345f>] acpi_ex_resolve_operands+0x45e/0x55b
 [<c01c3b1e>] acpi_ex_do_math_op+0x22/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c05>] acpi_ex_do_math_op+0x109/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3b89>] acpi_ex_do_math_op+0x8d/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3ba7>] acpi_ex_do_math_op+0xab/0x124
 [<c01c3bd4>] acpi_ex_do_math_op+0xd8/0x124
 [<c01c3b2f>] acpi_ex_do_math_op+0x33/0x124
 [<c01c3b40>] acpi_ex_do_math_op+0x44/0x124
 [<c01c3b4e>] acpi_ex_do_math_op+0x52/0x124
 [<c01c3b5f>] acpi_ex_do_math_op+0x63/0x124
 [<c01c3b78>] acpi_ex_do_math_op+0x7c/0x124
 [<c01c56fd>] acpi_ex_resolve_node_to_value+0x181/0x21c
 [<c01c56c6>] acpi_ex_resolve_node_to_value+0x14a/0x21c
 [<c01c56a3>] acpi_ex_resolve_node_to_value+0x127/0x21c
 [<c01c564a>] acpi_ex_resolve_node_to_value+0xce/0x21c
 [<c01c561e>] acpi_ex_resolve_node_to_value+0xa2/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5716>] acpi_ex_resolve_node_to_value+0x19a/0x21c
 [<c01c5d54>] acpi_hw_register_read+0x43/0x156
 [<c01c5d7c>] acpi_hw_register_read+0x6b/0x156
 [<c01c5dbb>] acpi_hw_register_read+0xaa/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5ddf>] acpi_hw_register_read+0xce/0x156
 [<c01c5def>] acpi_hw_register_read+0xde/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e04>] acpi_hw_register_read+0xf3/0x156
 [<c01c5ea0>] acpi_hw_register_write+0x39/0x14b
 [<c01c5eec>] acpi_hw_register_write+0x85/0x14b
 [<c01c5f15>] acpi_hw_register_write+0xae/0x14b
 [<c01c5f55>] acpi_hw_register_write+0xee/0x14b
 [<c01c5f5c>] acpi_hw_register_write+0xf5/0x14b
 [<c01c5f63>] acpi_hw_register_write+0xfc/0x14b
 [<c01c5f71>] acpi_hw_register_write+0x10a/0x14b
 [<c01c5e96>] acpi_hw_register_write+0x2f/0x14b
 [<c01c5f84>] acpi_hw_register_write+0x11d/0x14b
 [<c01c8eb9>] acpi_ps_get_next_simple_arg+0x20/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f20>] acpi_ps_get_next_simple_arg+0x87/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ef1>] acpi_ps_get_next_simple_arg+0x58/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ed5>] acpi_ps_get_next_simple_arg+0x3c/0xea
 [<c01c8f09>] acpi_ps_get_next_simple_arg+0x70/0xea
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9276>] acpi_ps_get_next_arg+0x140/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9189>] acpi_ps_get_next_arg+0x53/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c917a>] acpi_ps_get_next_arg+0x44/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9314>] acpi_ps_get_next_arg+0x1de/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c9635>] acpi_ps_next_parse_state+0x82/0x10d
 [<c01c95d3>] acpi_ps_next_parse_state+0x20/0x10d
 [<c01c9645>] acpi_ps_next_parse_state+0x92/0x10d
 [<c01c9662>] acpi_ps_next_parse_state+0xaf/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c967e>] acpi_ps_next_parse_state+0xcb/0x10d
 [<c01c95e3>] acpi_ps_next_parse_state+0x30/0x10d
 [<c01c9612>] acpi_ps_next_parse_state+0x5f/0x10d
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000606
 printing eip:
c0102886
*pde = 00000000
Oops: 0000 [#1]
Modules linked in:
CPU:    0
EIP:    0060:[<c0102886>]    Not tainted VLI
EFLAGS: 00010297   (2.6.21.1 #2)
EIP is at dump_trace+0x5c/0x8e
eax: 00001ffd   ebx: 00000606   ecx: 00000606   edx: c02d4fed
esi: 00000014   edi: 00000000   ebp: c02efe7c   esp: dfe55f38
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kacpid (pid: 38, ti=dfe54000 task=dfe2d520 task.ti=dfe54000)
Stack: c01d1b5d c02efe7c 00000246 c14744c0 c01b8fb1 c01028d0 c0318550 c02efe7c 
       dfe66708 c0102e9b c02efe7c c0102f0d c14744c0 c011af2b c02d8c36 dfe2d6ac 
       ffffffff 00000026 c14744c0 dfe81ef8 dfe55fbc 00000000 c011b414 00000001 
Call Trace:
 [<c01d1b5d>] acpi_ec_gpe_query+0x71/0x77
 [<c01b8fb1>] acpi_os_execute_deferred+0x0/0x2b
 [<c01028d0>] show_trace_log_lvl+0x18/0x2c
 [<c0102e9b>] show_trace+0xf/0x11
 [<c0102f0d>] dump_stack+0x12/0x14
 [<c011af2b>] run_workqueue+0xc8/0x101
 [<c011b414>] worker_thread+0x105/0x12e
 [<c010d5ab>] default_wake_function+0x0/0xc
 [<c011b30f>] worker_thread+0x0/0x12e
 [<c011d59c>] kthread+0xa0/0xc8
 [<c011d4fc>] kthread+0x0/0xc8
 [<c01025cf>] kernel_thread_helper+0x7/0x10
 [<c01a8b41>] radeon_get_pllinfo+0x830/0xbe3
 [<c01a8b4a>] radeon_get_pllinfo+0x839/0xbe3
 [<c01a8b54>] radeon_get_pllinfo+0x843/0xbe3
 [<c01a8b5e>] radeon_get_pllinfo+0x84d/0xbe3
 [<c01a8b8f>] radeon_get_pllinfo+0x87e/0xbe3
 [<c01a8b6f>] radeon_get_pllinfo+0x85e/0xbe3
 [<c01a8b80>] radeon_get_pllinfo+0x86f/0xbe3
 [<c01b7e9b>] radeon_probe_screens+0x482/0x54f
 [<c01b7ea2>] radeon_probe_screens+0x489/0x54f
 [<c01b7eb0>] radeon_probe_screens+0x497/0x54f
 [<c01b7ea9>] radeon_probe_screens+0x490/0x54f
 [<c01b7eb7>] radeon_probe_screens+0x49e/0x54f
 [<c01b7e94>] radeon_probe_screens+0x47b/0x54f
 [<c01b7f05>] radeon_probe_screens+0x4ec/0x54f
 [<c01b7f0c>] radeon_probe_screens+0x4f3/0x54f
 [<c01b7f1a>] radeon_probe_screens+0x501/0x54f
 [<c01b7f13>] radeon_probe_screens+0x4fa/0x54f
 [<c01b7f21>] radeon_probe_screens+0x508/0x54f
 [<c01b7efe>] radeon_probe_screens+0x4e5/0x54f
 [<c01b8c22>] acpi_table_print_madt_entry+0x22/0x228
 [<c01b8c50>] acpi_table_print_madt_entry+0x50/0x228
 [<c01b8c77>] acpi_table_print_madt_entry+0x77/0x228
 [<c01b8cda>] acpi_table_print_madt_entry+0xda/0x228
 [<c01b8d0e>] acpi_table_print_madt_entry+0x10e/0x228
 [<c01b8d48>] acpi_table_print_madt_entry+0x148/0x228
 [<c01b8d5b>] acpi_table_print_madt_entry+0x15b/0x228
 [<c01b8d7d>] acpi_table_print_madt_entry+0x17d/0x228
 [<c01b8db8>] acpi_table_print_madt_entry+0x1b8/0x228
 [<c01b9d88>] acpi_ds_create_bank_field+0xb4/0x126
 [<c01b9d92>] acpi_ds_create_bank_field+0xbe/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01bb2a0>] acpi_ds_exec_end_op+0x19b/0x3cf
 [<c01bb305>] acpi_ds_exec_end_op+0x200/0x3cf
 [<c01bb324>] acpi_ds_exec_end_op+0x21f/0x3cf
 [<c01bb262>] acpi_ds_exec_end_op+0x15d/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb3f9>] acpi_ds_exec_end_op+0x2f4/0x3cf
 [<c01bb3ce>] acpi_ds_exec_end_op+0x2c9/0x3cf
 [<c01bb434>] acpi_ds_exec_end_op+0x32f/0x3cf
 [<c01c2c7b>] acpi_ex_opcode_0A_0T_1R+0x0/0x95
 [<c01c2bdf>] acpi_ex_opcode_1A_0T_0R+0x0/0x9c
 [<c01c2138>] acpi_ex_opcode_1A_0T_1R+0x0/0x4fb
 [<c01c2b91>] acpi_ex_opcode_1A_1T_0R+0x0/0x4e
 [<c01c2633>] acpi_ex_opcode_1A_1T_1R+0x0/0x55e
 [<c01c4714>] acpi_ex_opcode_2A_0T_0R+0x0/0x98
 [<c01c412c>] acpi_ex_opcode_2A_0T_1R+0x0/0x13a
 [<c01c4266>] acpi_ex_opcode_2A_1T_1R+0x0/0x385
 [<c01c45eb>] acpi_ex_opcode_2A_2T_1R+0x0/0x129
 [<c01c5324>] acpi_ex_opcode_3A_0T_0R+0x0/0x9b
 [<c01c53bf>] acpi_ex_opcode_3A_1T_1R+0x0/0x1bd
 [<c01c0a98>] acpi_ex_opcode_6A_0T_1R+0x0/0x1f4
 [<c01bc696>] acpi_ds_load2_end_op+0x25e/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4af>] acpi_ds_load2_end_op+0x77/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4ba>] acpi_ds_load2_end_op+0x82/0x2d5
 [<c01bc51b>] acpi_ds_load2_end_op+0xe3/0x2d5
 [<c01bc5c4>] acpi_ds_load2_end_op+0x18c/0x2d5
 [<c01bd6bb>] acpi_ev_install_space_handler+0x59/0x1e2
 [<c01bd6ca>] acpi_ev_install_space_handler+0x68/0x1e2
 [<c01bd6d9>] acpi_ev_install_space_handler+0x77/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd6e8>] acpi_ev_install_space_handler+0x86/0x1e2
 [<c01bd821>] acpi_ev_install_space_handler+0x1bf/0x1e2
 [<c01bd6af>] acpi_ev_install_space_handler+0x4d/0x1e2
 [<c01c0a8b>] acpi_ex_do_match+0x8f/0x9c
 [<c01c0a17>] acpi_ex_do_match+0x1b/0x9c
 [<c01c0a29>] acpi_ex_do_match+0x2d/0x9c
 [<c01c0a3b>] acpi_ex_do_match+0x3f/0x9c
 [<c01c0a4d>] acpi_ex_do_match+0x51/0x9c
 [<c01c0a72>] acpi_ex_do_match+0x76/0x9c
 [<c01c1059>] acpi_ex_resolve_to_value+0x1c6/0x245
 [<c01c1062>] acpi_ex_resolve_to_value+0x1cf/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c0ee6>] acpi_ex_resolve_to_value+0x53/0x245
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1662>] acpi_ex_convert_to_target_type+0x2d/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c2c37>] acpi_ex_opcode_1A_0T_0R+0x58/0x9c
 [<c01c2c26>] acpi_ex_opcode_1A_0T_0R+0x47/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c1b>] acpi_ex_opcode_1A_0T_0R+0x3c/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c10>] acpi_ex_opcode_1A_0T_0R+0x31/0x9c
 [<c01c2c05>] acpi_ex_opcode_1A_0T_0R+0x26/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c45>] acpi_ex_opcode_1A_0T_0R+0x66/0x9c
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d42>] acpi_ex_prep_common_field_object+0x32/0xcf
 [<c01c2d4e>] acpi_ex_prep_common_field_object+0x3e/0xcf
 [<c01c2d36>] acpi_ex_prep_common_field_object+0x26/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c324f>] acpi_ex_resolve_operands+0x24e/0x55b
 [<c01c3245>] acpi_ex_resolve_operands+0x244/0x55b
 [<c01c323b>] acpi_ex_resolve_operands+0x23a/0x55b
 [<c01c3231>] acpi_ex_resolve_operands+0x230/0x55b
 [<c01c34ea>] acpi_ex_resolve_operands+0x4e9/0x55b
 [<c01c3256>] acpi_ex_resolve_operands+0x255/0x55b
 [<c01c32e9>] acpi_ex_resolve_operands+0x2e8/0x55b
 [<c01c3298>] acpi_ex_resolve_operands+0x297/0x55b
 [<c01c335c>] acpi_ex_resolve_operands+0x35b/0x55b
 [<c01c332b>] acpi_ex_resolve_operands+0x32a/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c33ba>] acpi_ex_resolve_operands+0x3b9/0x55b
 [<c01c33fa>] acpi_ex_resolve_operands+0x3f9/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c342b>] acpi_ex_resolve_operands+0x42a/0x55b
 [<c01c345f>] acpi_ex_resolve_operands+0x45e/0x55b
 [<c01c3b1e>] acpi_ex_do_math_op+0x22/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c05>] acpi_ex_do_math_op+0x109/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3b89>] acpi_ex_do_math_op+0x8d/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3ba7>] acpi_ex_do_math_op+0xab/0x124
 [<c01c3bd4>] acpi_ex_do_math_op+0xd8/0x124
 [<c01c3b2f>] acpi_ex_do_math_op+0x33/0x124
 [<c01c3b40>] acpi_ex_do_math_op+0x44/0x124
 [<c01c3b4e>] acpi_ex_do_math_op+0x52/0x124
 [<c01c3b5f>] acpi_ex_do_math_op+0x63/0x124
 [<c01c3b78>] acpi_ex_do_math_op+0x7c/0x124
 [<c01c56fd>] acpi_ex_resolve_node_to_value+0x181/0x21c
 [<c01c56c6>] acpi_ex_resolve_node_to_value+0x14a/0x21c
 [<c01c56a3>] acpi_ex_resolve_node_to_value+0x127/0x21c
 [<c01c564a>] acpi_ex_resolve_node_to_value+0xce/0x21c
 [<c01c561e>] acpi_ex_resolve_node_to_value+0xa2/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5716>] acpi_ex_resolve_node_to_value+0x19a/0x21c
 [<c01c5d54>] acpi_hw_register_read+0x43/0x156
 [<c01c5d7c>] acpi_hw_register_read+0x6b/0x156
 [<c01c5dbb>] acpi_hw_register_read+0xaa/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5ddf>] acpi_hw_register_read+0xce/0x156
 [<c01c5def>] acpi_hw_register_read+0xde/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e04>] acpi_hw_register_read+0xf3/0x156
 [<c01c5ea0>] acpi_hw_register_write+0x39/0x14b
 [<c01c5eec>] acpi_hw_register_write+0x85/0x14b
 [<c01c5f15>] acpi_hw_register_write+0xae/0x14b
 [<c01c5f55>] acpi_hw_register_write+0xee/0x14b
 [<c01c5f5c>] acpi_hw_register_write+0xf5/0x14b
 [<c01c5f63>] acpi_hw_register_write+0xfc/0x14b
 [<c01c5f71>] acpi_hw_register_write+0x10a/0x14b
 [<c01c5e96>] acpi_hw_register_write+0x2f/0x14b
 [<c01c5f84>] acpi_hw_register_write+0x11d/0x14b
 [<c01c8eb9>] acpi_ps_get_next_simple_arg+0x20/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f20>] acpi_ps_get_next_simple_arg+0x87/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ef1>] acpi_ps_get_next_simple_arg+0x58/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ed5>] acpi_ps_get_next_simple_arg+0x3c/0xea
 [<c01c8f09>] acpi_ps_get_next_simple_arg+0x70/0xea
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9276>] acpi_ps_get_next_arg+0x140/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9189>] acpi_ps_get_next_arg+0x53/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c917a>] acpi_ps_get_next_arg+0x44/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9314>] acpi_ps_get_next_arg+0x1de/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c9635>] acpi_ps_next_parse_state+0x82/0x10d
 [<c01c95d3>] acpi_ps_next_parse_state+0x20/0x10d
 [<c01c9645>] acpi_ps_next_parse_state+0x92/0x10d
 [<c01c9662>] acpi_ps_next_parse_state+0xaf/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c967e>] acpi_ps_next_parse_state+0xcb/0x10d
 [<c01c95e3>] acpi_ps_next_parse_state+0x30/0x10d
 [<c01c9612>] acpi_ps_next_parse_state+0x5f/0x10d
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000606
 printing eip:
c0102886
*pde = 00000000
Oops: 0000 [#2]
Modules linked in:
CPU:    0
EIP:    0060:[<c0102886>]    Not tainted VLI
EFLAGS: 00010097   (2.6.21.1 #2)
EIP is at dump_trace+0x5c/0x8e
eax: 00001ffd   ebx: 00000606   ecx: 00000606   edx: c02d4fed
esi: 00000014   edi: 00000000   ebp: c02d5173   esp: dfe55df4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kacpid (pid: 38, ti=dfe54000 task=dfe2d520 task.ti=dfe54000)
Stack: dfe55e0c c02d5173 00000018 00000000 c02d5173 c01028d0 c0318550 c02d5173 
       dfe55f9b c0102981 c02d5173 c02d5173 dfe55f00 dfe55f38 00000002 00010297 
       dfe55f00 0000002b c0102b45 c02d5173 00000010 dfe2d6ac 00000026 dfe54000 
Call Trace:
 [<c01028d0>] show_trace_log_lvl+0x18/0x2c
 [<c0102981>] show_stack_log_lvl+0x9d/0xa5
 [<c0102b45>] show_registers+0x1bc/0x285
 [<c0102cf5>] die+0xe7/0x1a2
 [<c010c018>] do_page_fault+0x450/0x528
 [<c010bbc8>] do_page_fault+0x0/0x528
 [<c0298124>] error_code+0x74/0x7c
 [<c0102886>] dump_trace+0x5c/0x8e
 [<c01d1b5d>] acpi_ec_gpe_query+0x71/0x77
 [<c01b8fb1>] acpi_os_execute_deferred+0x0/0x2b
 [<c01028d0>] show_trace_log_lvl+0x18/0x2c
 [<c0102e9b>] show_trace+0xf/0x11
 [<c0102f0d>] dump_stack+0x12/0x14
 [<c011af2b>] run_workqueue+0xc8/0x101
 [<c011b414>] worker_thread+0x105/0x12e
 [<c010d5ab>] default_wake_function+0x0/0xc
 [<c011b30f>] worker_thread+0x0/0x12e
 [<c011d59c>] kthread+0xa0/0xc8
 [<c011d4fc>] kthread+0x0/0xc8
 [<c01025cf>] kernel_thread_helper+0x7/0x10
 [<c01a8b41>] radeon_get_pllinfo+0x830/0xbe3
 [<c01a8b4a>] radeon_get_pllinfo+0x839/0xbe3
 [<c01a8b54>] radeon_get_pllinfo+0x843/0xbe3
 [<c01a8b5e>] radeon_get_pllinfo+0x84d/0xbe3
 [<c01a8b8f>] radeon_get_pllinfo+0x87e/0xbe3
 [<c01a8b6f>] radeon_get_pllinfo+0x85e/0xbe3
 [<c01a8b80>] radeon_get_pllinfo+0x86f/0xbe3
 [<c01b7e9b>] radeon_probe_screens+0x482/0x54f
 [<c01b7ea2>] radeon_probe_screens+0x489/0x54f
 [<c01b7eb0>] radeon_probe_screens+0x497/0x54f
 [<c01b7ea9>] radeon_probe_screens+0x490/0x54f
 [<c01b7eb7>] radeon_probe_screens+0x49e/0x54f
 [<c01b7e94>] radeon_probe_screens+0x47b/0x54f
 [<c01b7f05>] radeon_probe_screens+0x4ec/0x54f
 [<c01b7f0c>] radeon_probe_screens+0x4f3/0x54f
 [<c01b7f1a>] radeon_probe_screens+0x501/0x54f
 [<c01b7f13>] radeon_probe_screens+0x4fa/0x54f
 [<c01b7f21>] radeon_probe_screens+0x508/0x54f
 [<c01b7efe>] radeon_probe_screens+0x4e5/0x54f
 [<c01b8c22>] acpi_table_print_madt_entry+0x22/0x228
 [<c01b8c50>] acpi_table_print_madt_entry+0x50/0x228
 [<c01b8c77>] acpi_table_print_madt_entry+0x77/0x228
 [<c01b8cda>] acpi_table_print_madt_entry+0xda/0x228
 [<c01b8d0e>] acpi_table_print_madt_entry+0x10e/0x228
 [<c01b8d48>] acpi_table_print_madt_entry+0x148/0x228
 [<c01b8d5b>] acpi_table_print_madt_entry+0x15b/0x228
 [<c01b8d7d>] acpi_table_print_madt_entry+0x17d/0x228
 [<c01b8db8>] acpi_table_print_madt_entry+0x1b8/0x228
 [<c01b9d88>] acpi_ds_create_bank_field+0xb4/0x126
 [<c01b9d92>] acpi_ds_create_bank_field+0xbe/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01b9da5>] acpi_ds_create_bank_field+0xd1/0x126
 [<c01b9d9c>] acpi_ds_create_bank_field+0xc8/0x126
 [<c01bb2a0>] acpi_ds_exec_end_op+0x19b/0x3cf
 [<c01bb305>] acpi_ds_exec_end_op+0x200/0x3cf
 [<c01bb324>] acpi_ds_exec_end_op+0x21f/0x3cf
 [<c01bb262>] acpi_ds_exec_end_op+0x15d/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb399>] acpi_ds_exec_end_op+0x294/0x3cf
 [<c01bb3f9>] acpi_ds_exec_end_op+0x2f4/0x3cf
 [<c01bb3ce>] acpi_ds_exec_end_op+0x2c9/0x3cf
 [<c01bb434>] acpi_ds_exec_end_op+0x32f/0x3cf
 [<c01c2c7b>] acpi_ex_opcode_0A_0T_1R+0x0/0x95
 [<c01c2bdf>] acpi_ex_opcode_1A_0T_0R+0x0/0x9c
 [<c01c2138>] acpi_ex_opcode_1A_0T_1R+0x0/0x4fb
 [<c01c2b91>] acpi_ex_opcode_1A_1T_0R+0x0/0x4e
 [<c01c2633>] acpi_ex_opcode_1A_1T_1R+0x0/0x55e
 [<c01c4714>] acpi_ex_opcode_2A_0T_0R+0x0/0x98
 [<c01c412c>] acpi_ex_opcode_2A_0T_1R+0x0/0x13a
 [<c01c4266>] acpi_ex_opcode_2A_1T_1R+0x0/0x385
 [<c01c45eb>] acpi_ex_opcode_2A_2T_1R+0x0/0x129
 [<c01c5324>] acpi_ex_opcode_3A_0T_0R+0x0/0x9b
 [<c01c53bf>] acpi_ex_opcode_3A_1T_1R+0x0/0x1bd
 [<c01c0a98>] acpi_ex_opcode_6A_0T_1R+0x0/0x1f4
 [<c01bc696>] acpi_ds_load2_end_op+0x25e/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4af>] acpi_ds_load2_end_op+0x77/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc6f3>] acpi_ds_load2_end_op+0x2bb/0x2d5
 [<c01bc4ba>] acpi_ds_load2_end_op+0x82/0x2d5
 [<c01bc51b>] acpi_ds_load2_end_op+0xe3/0x2d5
 [<c01bc5c4>] acpi_ds_load2_end_op+0x18c/0x2d5
 [<c01bd6bb>] acpi_ev_install_space_handler+0x59/0x1e2
 [<c01bd6ca>] acpi_ev_install_space_handler+0x68/0x1e2
 [<c01bd6d9>] acpi_ev_install_space_handler+0x77/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd813>] acpi_ev_install_space_handler+0x1b1/0x1e2
 [<c01bd6e8>] acpi_ev_install_space_handler+0x86/0x1e2
 [<c01bd821>] acpi_ev_install_space_handler+0x1bf/0x1e2
 [<c01bd6af>] acpi_ev_install_space_handler+0x4d/0x1e2
 [<c01c0a8b>] acpi_ex_do_match+0x8f/0x9c
 [<c01c0a17>] acpi_ex_do_match+0x1b/0x9c
 [<c01c0a29>] acpi_ex_do_match+0x2d/0x9c
 [<c01c0a3b>] acpi_ex_do_match+0x3f/0x9c
 [<c01c0a4d>] acpi_ex_do_match+0x51/0x9c
 [<c01c0a72>] acpi_ex_do_match+0x76/0x9c
 [<c01c1059>] acpi_ex_resolve_to_value+0x1c6/0x245
 [<c01c1062>] acpi_ex_resolve_to_value+0x1cf/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c108d>] acpi_ex_resolve_to_value+0x1fa/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c106d>] acpi_ex_resolve_to_value+0x1da/0x245
 [<c01c0ee6>] acpi_ex_resolve_to_value+0x53/0x245
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c16cc>] acpi_ex_convert_to_target_type+0x97/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1662>] acpi_ex_convert_to_target_type+0x2d/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c1718>] acpi_ex_convert_to_target_type+0xe3/0xef
 [<c01c2c37>] acpi_ex_opcode_1A_0T_0R+0x58/0x9c
 [<c01c2c26>] acpi_ex_opcode_1A_0T_0R+0x47/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c1b>] acpi_ex_opcode_1A_0T_0R+0x3c/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c10>] acpi_ex_opcode_1A_0T_0R+0x31/0x9c
 [<c01c2c05>] acpi_ex_opcode_1A_0T_0R+0x26/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c50>] acpi_ex_opcode_1A_0T_0R+0x71/0x9c
 [<c01c2c45>] acpi_ex_opcode_1A_0T_0R+0x66/0x9c
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c2d42>] acpi_ex_prep_common_field_object+0x32/0xcf
 [<c01c2d4e>] acpi_ex_prep_common_field_object+0x3e/0xcf
 [<c01c2d36>] acpi_ex_prep_common_field_object+0x26/0xcf
 [<c01c2d82>] acpi_ex_prep_common_field_object+0x72/0xcf
 [<c01c324f>] acpi_ex_resolve_operands+0x24e/0x55b
 [<c01c3245>] acpi_ex_resolve_operands+0x244/0x55b
 [<c01c323b>] acpi_ex_resolve_operands+0x23a/0x55b
 [<c01c3231>] acpi_ex_resolve_operands+0x230/0x55b
 [<c01c34ea>] acpi_ex_resolve_operands+0x4e9/0x55b
 [<c01c3256>] acpi_ex_resolve_operands+0x255/0x55b
 [<c01c32e9>] acpi_ex_resolve_operands+0x2e8/0x55b
 [<c01c3298>] acpi_ex_resolve_operands+0x297/0x55b
 [<c01c335c>] acpi_ex_resolve_operands+0x35b/0x55b
 [<c01c332b>] acpi_ex_resolve_operands+0x32a/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c33ba>] acpi_ex_resolve_operands+0x3b9/0x55b
 [<c01c33fa>] acpi_ex_resolve_operands+0x3f9/0x55b
 [<c01c34be>] acpi_ex_resolve_operands+0x4bd/0x55b
 [<c01c342b>] acpi_ex_resolve_operands+0x42a/0x55b
 [<c01c345f>] acpi_ex_resolve_operands+0x45e/0x55b
 [<c01c3b1e>] acpi_ex_do_math_op+0x22/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c05>] acpi_ex_do_math_op+0x109/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3b89>] acpi_ex_do_math_op+0x8d/0x124
 [<c01c3c13>] acpi_ex_do_math_op+0x117/0x124
 [<c01c3ba7>] acpi_ex_do_math_op+0xab/0x124
 [<c01c3bd4>] acpi_ex_do_math_op+0xd8/0x124
 [<c01c3b2f>] acpi_ex_do_math_op+0x33/0x124
 [<c01c3b40>] acpi_ex_do_math_op+0x44/0x124
 [<c01c3b4e>] acpi_ex_do_math_op+0x52/0x124
 [<c01c3b5f>] acpi_ex_do_math_op+0x63/0x124
 [<c01c3b78>] acpi_ex_do_math_op+0x7c/0x124
 [<c01c56fd>] acpi_ex_resolve_node_to_value+0x181/0x21c
 [<c01c56c6>] acpi_ex_resolve_node_to_value+0x14a/0x21c
 [<c01c56a3>] acpi_ex_resolve_node_to_value+0x127/0x21c
 [<c01c564a>] acpi_ex_resolve_node_to_value+0xce/0x21c
 [<c01c561e>] acpi_ex_resolve_node_to_value+0xa2/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5726>] acpi_ex_resolve_node_to_value+0x1aa/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c5758>] acpi_ex_resolve_node_to_value+0x1dc/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c56e9>] acpi_ex_resolve_node_to_value+0x16d/0x21c
 [<c01c5716>] acpi_ex_resolve_node_to_value+0x19a/0x21c
 [<c01c5d54>] acpi_hw_register_read+0x43/0x156
 [<c01c5d7c>] acpi_hw_register_read+0x6b/0x156
 [<c01c5dbb>] acpi_hw_register_read+0xaa/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5ddf>] acpi_hw_register_read+0xce/0x156
 [<c01c5def>] acpi_hw_register_read+0xde/0x156
 [<c01c5e1b>] acpi_hw_register_read+0x10a/0x156
 [<c01c5e04>] acpi_hw_register_read+0xf3/0x156
 [<c01c5ea0>] acpi_hw_register_write+0x39/0x14b
 [<c01c5eec>] acpi_hw_register_write+0x85/0x14b
 [<c01c5f15>] acpi_hw_register_write+0xae/0x14b
 [<c01c5f55>] acpi_hw_register_write+0xee/0x14b
 [<c01c5f5c>] acpi_hw_register_write+0xf5/0x14b
 [<c01c5f63>] acpi_hw_register_write+0xfc/0x14b
 [<c01c5f71>] acpi_hw_register_write+0x10a/0x14b
 [<c01c5e96>] acpi_hw_register_write+0x2f/0x14b
 [<c01c5f84>] acpi_hw_register_write+0x11d/0x14b
 [<c01c8eb9>] acpi_ps_get_next_simple_arg+0x20/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f20>] acpi_ps_get_next_simple_arg+0x87/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ef1>] acpi_ps_get_next_simple_arg+0x58/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f37>] acpi_ps_get_next_simple_arg+0x9e/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8f4f>] acpi_ps_get_next_simple_arg+0xb6/0xea
 [<c01c8ed5>] acpi_ps_get_next_simple_arg+0x3c/0xea
 [<c01c8f09>] acpi_ps_get_next_simple_arg+0x70/0xea
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9276>] acpi_ps_get_next_arg+0x140/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9189>] acpi_ps_get_next_arg+0x53/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c917a>] acpi_ps_get_next_arg+0x44/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c92fa>] acpi_ps_get_next_arg+0x1c4/0x226
 [<c01c9303>] acpi_ps_get_next_arg+0x1cd/0x226
 [<c01c9156>] acpi_ps_get_next_arg+0x20/0x226
 [<c01c9314>] acpi_ps_get_next_arg+0x1de/0x226
 [<c01c92b0>] acpi_ps_get_next_arg+0x17a/0x226
 [<c01c9635>] acpi_ps_next_parse_state+0x82/0x10d
 [<c01c95d3>] acpi_ps_next_parse_state+0x20/0x10d
 [<c01c9645>] acpi_ps_next_parse_state+0x92/0x10d
 [<c01c9662>] acpi_ps_next_parse_state+0xaf/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c96a9>] acpi_ps_next_parse_state+0xf6/0x10d
 [<c01c967e>] acpi_ps_next_parse_state+0xcb/0x10d
 [<c01c95e3>] acpi_ps_next_parse_state+0x30/0x10d
 [<c01c9612>] acpi_ps_next_parse_state+0x5f/0x10d
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000606
 printing eip:
c0102886
*pde = 00000000
Recursive die() failure, output suppressed
Kernel panic - not syncing: Fatal exception in interrupt

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci.out"

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort+ <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [40] Vendor Specific Information
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x1

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:01.0 PCI bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to AGP Controller (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 96
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: d8000000-dfffffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 6
	Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 6
	Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 6
	Region 4: I/O ports at 1840 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 10
	Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=06, sec-latency=64
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d0200000-d05fffff
	Prefetchable memory behind bridge: 30000000-35ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 6
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 1860 [size=16]
	Region 5: Memory at 36000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 10
	Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 10
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: I/O ports at 18c0 [size=64]
	Region 2: Memory at d0000c00 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at d0000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 10
	Region 0: I/O ports at 2400 [size=256]
	Region 1: I/O ports at 2000 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] (prog-if 00 [VGA])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 6
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:02.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 6
	Region 0: Memory at d0204000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at 34000000 [disabled] [size=16K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

02:04.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network Connection (rev 05)
	Subsystem: Intel Corporation Unknown device 2701
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 6000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0208000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

02:06.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0209000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: 30000000-33fff000 (prefetchable)
	Memory window 1: 38000000-3bfff000 (prefetchable)
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- PostWrite-
	16-bit legacy interface ports at 0001

02:06.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d020a000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d0200000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:06.3 Mass storage controller: Texas Instruments PCIxx21 Integrated FlashMedia Controller
	Subsystem: Acer Incorporated [ALI] Unknown device 0064
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0206000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lsusb.out"


Bus 004 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.20-gentoo-r7 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x6c
  PortPwrCtrlMask    0x39 
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power

Bus 003 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.20-gentoo-r7 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x6c
  PortPwrCtrlMask    0x39 
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power

Bus 002 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.20-gentoo-r7 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x6c
  PortPwrCtrlMask    0x39 
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power

Bus 001 Device 002: ID 183f:0101  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x183f 
  idProduct          0x0101 
  bcdDevice           10.01
  iManufacturer           1 TrekStor
  iProduct                2 i.Beat_organix. 
  iSerial                 3 0002F68CABEB4D95
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 USB/MSC LCD Player
    bmAttributes         0x80
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              5 Internal Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1

Bus 001 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.20-gentoo-r7 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x6c
  PortPwrCtrlMask    0x39 
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0503 highspeed power enable connect

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ver_linux.out"

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux raven 2.6.20-gentoo-r7 #2 Sun Apr 29 13:50:19 CEST 2007 i686 Intel(R) Pentium(R) M processor 1.60GHz GenuineIntel GNU/Linux
 
Gnu C                  4.1.1
Gnu make               3.81
binutils               2.16.1
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.7
udev                   104
wireless-tools         28
Modules Loaded         nls_iso8859_15 nls_cp850 vfat fat sd_mod usb_storage scsi_mod ipw2200

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel.config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21.1
# Mon Apr 30 13:58:10 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_HPET_TIMER=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
# CONFIG_SOFTWARE_SUSPEND is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
# CONFIG_ACPI_SLEEP is not set
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y

#
# APM (Advanced Power Management) BIOS Support
#
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK is not set
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK_SUPPORT=y
# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_IPRANGE is not set
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_OWNER is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_SAME is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
CONFIG_WIRELESS_EXT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
# CONFIG_ATA is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set

#
# Tulip family network device support
#
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
CONFIG_NET_RADIO=y
# CONFIG_NET_WIRELESS_RTNETLINK is not set

#
# Obsolete Wireless cards support (pre-802.11)
#
# CONFIG_STRIP is not set

#
# Wireless 802.11b ISA/PCI cards support
#
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set

#
# Prism GT/Duette 802.11(a/b/g) PCI/Cardbus support
#
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
CONFIG_NET_WIRELESS=y

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_RX is not set
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=800
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
# CONFIG_HWMON is not set
# CONFIG_HWMON_VID is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

#
# Logo configuration
#
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set

#
# SoC audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set
# CONFIG_USB_GTCO is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Auxiliary Display support
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_LOG_BUF_SHIFT=14
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

--wRRV7LY7NUeQGEoC--
