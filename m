Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZD1VYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZD1VYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZD1VYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:24:09 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:38468 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZD1VYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:24:06 -0400
Message-ID: <49F773EC.1000106@uni-koeln.de>
Date: Tue, 28 Apr 2009 23:23:56 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Oops with linux 2.6.29.1 in radeon_do_cp_idle
References: <49F64B48.9050109@uni-koeln.de>
In-Reply-To: <49F64B48.9050109@uni-koeln.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berthold Cogel schrieb:
> Hello!
> 

It seems that my mouse has a problem (cable?). I don't know if both 
problems are connected. Today I got a frozen system during startup:

Apr 28 21:46:26 acer01 kernel: [   37.364048] usb 2-2: new low speed USB 
device using uhci_hcd and address 8
Apr 28 21:46:26 acer01 kernel: [   37.513722] ADDRCONF(NETDEV_UP): eth1: 
link is not ready
Apr 28 21:46:27 acer01 kernel: [   37.934042] usb 2-2: device not 
accepting address 8, error -71
Apr 28 21:46:27 acer01 kernel: [   38.036030] usb 2-2: new low speed USB 
device using uhci_hcd and address 9
Apr 28 21:46:27 acer01 kernel: [   38.150031] usb 2-2: device descriptor 
read/64, error -71
Apr 28 21:46:27 acer01 kernel: [   38.364044] usb 2-2: device descriptor 
read/64, error -71
Apr 28 21:46:27 acer01 kernel: [   38.567617] usb 2-2: new low speed USB 
device using uhci_hcd and address 10
Apr 28 21:46:28 acer01 kernel: [   38.984043] usb 2-2: device not 
accepting address 10, error -84
Apr 28 21:46:28 acer01 kernel: [   39.086030] usb 2-2: new low speed USB 
device using uhci_hcd and address 11
Apr 28 21:46:28 acer01 kernel: [   39.500030] usb 2-2: device not 
accepting address 11, error -84
Apr 28 21:46:28 acer01 kernel: [   39.500103] hub 2-0:1.0: unable to 
enumerate USB device on port 2
Apr 28 21:46:29 acer01 kernel: [   40.334841] [drm] Initialized drm 
1.1.0 20060810
Apr 28 21:46:29 acer01 kernel: [   40.394785] pci 0000:01:00.0: power 
state changed by ACPI to D0
Apr 28 21:46:29 acer01 kernel: [   40.394799] pci 0000:01:00.0: PCI INT 
A -> Link[LNKA] -> GSI 6 (level, low) -> IRQ 6
Apr 28 21:46:29 acer01 kernel: [   40.395892] [drm] Initialized radeon 
1.29.0 20080528 on minor 0
Apr 28 21:46:31 acer01 kernel: [   42.325091] agpgart-intel 
0000:00:00.0: AGP 2.0 bridge
Apr 28 21:46:31 acer01 kernel: [   42.325110] agpgart-intel 
0000:00:00.0: putting AGP V2 device into 4x mode
Apr 28 21:46:31 acer01 kernel: [   42.325147] pci 0000:01:00.0: putting 
AGP V2 device into 4x mode
Apr 28 21:46:32 acer01 kernel: [   43.681233] [drm] Setting GART 
location based on new memory map
Apr 28 21:46:32 acer01 kernel: [   43.681244] [drm] Loading R300 Microcode
Apr 28 21:46:32 acer01 kernel: [   43.681292] [drm] Num pipes: 1
Apr 28 21:46:32 acer01 kernel: [   43.681299] [drm] writeback test 
succeeded in 1 usecs
Apr 28 21:46:33 acer01 kernel: [   44.326074] usbcore: registered new 
interface driver wacom
Apr 28 21:46:33 acer01 kernel: [   44.326079] wacom: v1.49:USB Wacom 
Graphire and Wacom Intuos tablet driver
Apr 28 21:46:40 acer01 kernel: [   51.694236] eth0: no IPv6 routers present
Apr 28 21:46:54 acer01 kernel: [   65.408935] irq 6: nobody cared (try 
booting with the "irqpoll" option)
Apr 28 21:46:54 acer01 kernel: [   65.408942] Pid: 3182, comm: Xorg Not 
tainted 2.6.29.1 #1
Apr 28 21:46:54 acer01 kernel: [   65.408945] Call Trace:
Apr 28 21:46:54 acer01 kernel: [   65.408955]  [<c0159aec>] 
__report_bad_irq+0x24/0x69
Apr 28 21:46:54 acer01 kernel: [   65.408960]  [<c0159af3>] 
__report_bad_irq+0x2b/0x69
Apr 28 21:46:54 acer01 kernel: [   65.408965]  [<c0159c18>] 
note_interrupt+0xe7/0x13f
Apr 28 21:46:54 acer01 kernel: [   65.408969]  [<c015a1ab>] 
handle_level_irq+0x77/0xa7
Apr 28 21:46:54 acer01 kernel: [   65.408975]  [<c01052f8>] do_IRQ+0x63/0x7b
Apr 28 21:46:54 acer01 kernel: [   65.408979]  [<c0103ba7>] 
common_interrupt+0x27/0x2c
Apr 28 21:46:54 acer01 kernel: [   65.408985]  [<c012b285>] 
__do_softirq+0x56/0x10d
Apr 28 21:46:54 acer01 kernel: [   65.408989]  [<c012b380>] 
do_softirq+0x44/0x53
Apr 28 21:46:54 acer01 kernel: [   65.408993]  [<c012b527>] 
irq_exit+0x37/0x73
Apr 28 21:46:54 acer01 kernel: [   65.408997]  [<c01052fd>] do_IRQ+0x68/0x7b
Apr 28 21:46:54 acer01 kernel: [   65.409001]  [<c0103ba7>] 
common_interrupt+0x27/0x2c
Apr 28 21:46:54 acer01 kernel: [   65.409004] handlers:
Apr 28 21:46:54 acer01 kernel: [   65.409006] [<f80d70da>] 
(usb_hcd_irq+0x0/0x78 [usbcore])
Apr 28 21:46:54 acer01 kernel: [   65.409010] [<f80d70da>] 
(usb_hcd_irq+0x0/0x78 [usbcore])
Apr 28 21:46:54 acer01 kernel: [   65.409010] [<f80d70da>] 
(usb_hcd_irq+0x0/0x78 [usbcore])
Apr 28 21:46:54 acer01 kernel: [   65.409010] [<f8346880>] 
(b44_interrupt+0x0/0xcc [b44])
Apr 28 21:46:54 acer01 kernel: [   65.409010] [<f851aeac>] 
(radeon_driver_irq_handler+0x0/0x11c [radeon])
Apr 28 21:46:54 acer01 kernel: [   65.409010] Disabling IRQ #6


This was the last in the logs. I had to remove the battery and the power 
  plug to reboot the system.

The USB device is the mouse. You can see it in some logs:


Apr 28 01:56:41 acer01 kernel: [ 2059.934519] usb 2-2: input irq status 
-75  received
Apr 28 01:56:41 acer01 kernel: [ 2060.000181] hub 2-0:1.0: port 2 
disabled by hub (EMI?), re-enabling...
Apr 28 01:56:41 acer01 kernel: [ 2060.000188] usb 2-2: USB disconnect, 
address 12
Apr 28 01:56:41 acer01 kernel: [ 2060.208043] usb 2-2: new low speed USB 
device using uhci_hcd and address 13
Apr 28 01:56:41 acer01 kernel: [ 2060.373551] usb 2-2: New USB device 
found, idVendor=0458, idProduct=0036
Apr 28 01:56:41 acer01 kernel: [ 2060.373555] usb 2-2: New USB device 
strings: Mfr=2, Product=1, SerialNumber=0
Apr 28 01:56:41 acer01 kernel: [ 2060.373559] usb 2-2: Product: 
NetScroll+Mini Traveler
Apr 28 01:56:41 acer01 kernel: [ 2060.373561] usb 2-2: Manufacturer: 
Genius
Apr 28 01:56:41 acer01 kernel: [ 2060.373664] usb 2-2: configuration #1 
chosen from 1 choice
Apr 28 01:56:42 acer01 kernel: [ 2060.392372] input: Genius 
NetScroll+Mini Traveler as 
/devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input12
Apr 28 01:56:42 acer01 kernel: [ 2060.392485] generic-usb 
0003:0458:0036.0006: input,hidraw0: USB HID v1.10 Mouse [Genius 
NetScroll+Mini Traveler] on usb-0000:00:1d.1-2/input0
Apr 28 02:00:04 acer01 kernel: [ 2262.750064] usb 2-2: USB disconnect, 
address 13
Apr 28 02:00:04 acer01 kernel: [ 2262.959042] usb 2-2: new low speed USB 
device using uhci_hcd and address 14
Apr 28 02:00:04 acer01 kernel: [ 2263.125181] usb 2-2: New USB device 
found, idVendor=0458, idProduct=0036
Apr 28 02:00:04 acer01 kernel: [ 2263.125185] usb 2-2: New USB device 
strings: Mfr=2, Product=1, SerialNumber=0
Apr 28 02:00:04 acer01 kernel: [ 2263.125188] usb 2-2: Product: 
NetScroll+Mini Traveler
Apr 28 02:00:04 acer01 kernel: [ 2263.125191] usb 2-2: Manufacturer: 
Genius
Apr 28 02:00:04 acer01 kernel: [ 2263.125289] usb 2-2: configuration #1 
chosen from 1 choice
Apr 28 02:00:04 acer01 kernel: [ 2263.143931] input: Genius 
NetScroll+Mini Traveler as 
/devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input13
Apr 28 02:00:04 acer01 kernel: [ 2263.144477] generic-usb 
0003:0458:0036.0007: input,hidraw0: USB HID v1.10 Mouse [Genius 
NetScroll+Mini Traveler] on usb-0000:00:1d.1-2/input0
Apr 28 02:00:20 acer01 kernel: [ 2279.105044] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:00:21 acer01 kernel: [ 2279.780039] usb 2-2: device not 
accepting address 14, error -71
Apr 28 02:00:21 acer01 kernel: [ 2280.032041] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:00:24 acer01 kernel: [ 2282.833043] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:00:24 acer01 kernel: [ 2283.096029] usb 2-2: device descriptor 
read/64, error -71
Apr 28 02:01:25 acer01 kernel: [ 2343.883043] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:01:26 acer01 kernel: [ 2344.567039] usb 2-2: device not 
accepting address 14, error -84
Apr 28 02:01:26 acer01 kernel: [ 2344.819041] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:01:26 acer01 kernel: [ 2345.082041] usb 2-2: device descriptor 
read/64, error -71
Apr 28 02:01:27 acer01 kernel: [ 2345.448041] usb 2-2: device descriptor 
read/64, error -84
Apr 28 02:01:27 acer01 kernel: [ 2345.801041] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:01:27 acer01 kernel: [ 2346.209041] usb 2-2: device not 
accepting address 14, error -71
Apr 28 02:01:28 acer01 kernel: [ 2346.461045] usb 2-2: reset low speed 
USB device using uhci_hcd and address 14
Apr 28 02:01:28 acer01 kernel: [ 2346.869040] usb 2-2: device not 
accepting address 14, error -71
Apr 28 02:01:28 acer01 kernel: [ 2346.869114] usb 2-2: USB disconnect, 
address 14
Apr 28 02:01:28 acer01 kernel: [ 2346.973045] usb 2-2: new low speed USB 
device using uhci_hcd and address 15
Apr 28 02:01:28 acer01 kernel: [ 2347.086041] usb 2-2: device descriptor 
read/64, error -71
Apr 28 02:01:28 acer01 kernel: [ 2347.303041] usb 2-2: device descriptor 
read/64, error -84
Apr 28 02:01:29 acer01 kernel: [ 2347.506040] usb 2-2: new low speed USB 
device using uhci_hcd and address 16
Apr 28 02:01:29 acer01 kernel: [ 2347.620040] usb 2-2: device descriptor 
read/64, error -84
Apr 28 02:01:29 acer01 kernel: [ 2347.834041] usb 2-2: device descriptor 
read/64, error -71
Apr 28 02:01:29 acer01 kernel: [ 2348.037040] usb 2-2: new low speed USB 
device using uhci_hcd and address 17
Apr 28 02:01:30 acer01 kernel: [ 2348.445040] usb 2-2: device not 
accepting address 17, error -71
Apr 28 02:01:30 acer01 kernel: [ 2348.547041] usb 2-2: new low speed USB 
device using uhci_hcd and address 18
Apr 28 02:01:30 acer01 kernel: [ 2348.955040] usb 2-2: device not 
accepting address 18, error -71
Apr 28 02:01:30 acer01 kernel: [ 2348.955050] hub 2-0:1.0: unable to 
enumerate USB device on port 2

Some additional informations:

acer01:/var/log# lspci
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to AGP Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 
EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface 
Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE 
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
SMBus Controller (rev 03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
AC'97 Modem Controller (rev 03)
01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility 
Radeon 9600 M10]
02:02.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
02:04.0 Network controller: Intel Corporation PRO/Wireless 2200BG 
[Calexico2] Network Connection (rev 05)
02:06.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
02:06.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 
Host Controller
02:06.3 Mass storage controller: Texas Instruments PCIxx21 Integrated 
FlashMedia Controller


acer01:/var/log# lspci -v
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, fast devsel, latency 0
	Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [40] Vendor Specific Information <?>
	Capabilities: [a0] AGP version 2.0
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, fast devsel, latency 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, fast devsel, latency 0

00:01.0 PCI bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to AGP Controller (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, fast devsel, latency 96
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: d8000000-dfffffff

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 6
	I/O ports at 1800 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 6
	I/O ports at 1820 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 6
	I/O ports at 1840 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 
EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 10
	Memory at d0000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=0080
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83) 
(prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=06, sec-latency=64
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d0200000-d05fffff
	Prefetchable memory behind bridge: 88000000-8dffffff

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface 
Bridge (rev 03)
	Flags: bus master, medium devsel, latency 0
	Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 6
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 1860 [size=16]
	Memory at 8e000000 (32-bit, non-prefetchable) [size=1K]
	Kernel driver in use: PIIX_IDE
	Kernel modules: ata_piix, piix

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
SMBus Controller (rev 03)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: medium devsel, IRQ 10
	I/O ports at 1880 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 10
	I/O ports at 1c00 [size=256]
	I/O ports at 18c0 [size=64]
	Memory at d0000c00 (32-bit, non-prefetchable) [size=512]
	Memory at d0000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 0, IRQ 10
	I/O ports at 2400 [size=256]
	I/O ports at 2000 [size=128]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: Intel ICH Modem
	Kernel modules: snd-intel8x0m

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility 
Radeon 9600 M10] (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, fast Back2Back, 66MHz, medium devsel, latency 66, IRQ 6
	Memory at d8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 3000 [size=256]
	Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2
	Kernel modules: radeonfb

02:02.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, fast devsel, latency 64, IRQ 6
	Memory at d0204000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at 8c000000 [disabled] [size=16K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: b44
	Kernel modules: b44

02:04.0 Network controller: Intel Corporation PRO/Wireless 2200BG 
[Calexico2] Network Connection (rev 05)
	Subsystem: Intel Corporation Device 2701
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at d0208000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: ipw2200
	Kernel modules: ipw2200

02:06.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 168, IRQ 10
	Memory at d0209000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: 88000000-8bfff000 (prefetchable)
	Memory window 1: 90000000-93fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

02:06.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 
Host Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at d020a000 (32-bit, non-prefetchable) [size=2K]
	Memory at d0200000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

02:06.3 Mass storage controller: Texas Instruments PCIxx21 Integrated 
FlashMedia Controller
	Subsystem: Acer Incorporated [ALI] Device 0064
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at d0206000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: tifm_7xx1
	Kernel modules: tifm_7xx1



Regards
Berthold Cogel
