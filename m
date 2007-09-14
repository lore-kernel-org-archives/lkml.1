Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXINV2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXINV2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbXINV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:28:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbXINV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:28:29 -0400
Message-ID: <46EAFCF7.1030907@cv-sv.de>
Date: Fri, 14 Sep 2007 23:28:23 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070803 SUSE/1.1.4-3.1 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: haveaniceday@cv-sv.de
Subject: 2.6.23-rc6: usb 1-1: device not accepting address 2, error -62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+L/9qugIDjrkgHWXfVMb4Bfx7LTmwAFI8Qx+K
 eOfRoSVi6VOZEsgHGhSfDQh+e8nrJb4RwilPzBI8Mnhs2DFjlo
 6KDKxVbJLczHq0fdIsaqA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I have an error message with 2.6.23-rc6.
This did not happen with 2.6.22.

The kernel reports message like this:
 <3>usb 1-1: device not accepting address 2, error -62
 <3>hub 2-2.1:1.0: hub_port_status failed (err = -71)

Does this message harm or is something broken in 2.6.23-rc6 ?
I get this kind of messages also with 2.6.23-rc3

Best regards,

Christian


Please see below for:

grep -e hub -e usb boot.msg for a 2.6.23-rc6 boot. (that boot was without (err = -71)
grep -e hub -e usb boot.msg for a 2.6.22 boot.
lspci -vnn (2.6.22)
lsusb -v (2.6.22)


2.6.23-rc6 boot.msg extract ( hub/usb )

<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>usb usb1: configuration #1 chosen from 1 choice
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<6>usb usb2: configuration #1 chosen from 1 choice
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<6>usb 1-1: new low speed USB device using ohci_hcd and address 2
<6>usb usb3: configuration #1 chosen from 1 choice
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 2 ports detected
<6>usb usb4: configuration #1 chosen from 1 choice
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 6 ports detected
<6>usb usb5: configuration #1 chosen from 1 choice
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 2 ports detected
<3>usb 1-1: device not accepting address 2, error -62
<6>usb 5-2: new full speed USB device using uhci_hcd and address 2
<6>usb usb6: configuration #1 chosen from 1 choice
<6>hub 6-0:1.0: USB hub found
<6>hub 6-0:1.0: 4 ports detected
<6>usb usb7: configuration #1 chosen from 1 choice
<6>hub 7-0:1.0: USB hub found
<6>hub 7-0:1.0: 2 ports detected
<6>usb 1-1: new low speed USB device using ohci_hcd and address 4
<6>usb 1-1: configuration #1 chosen from 1 choice
<6>usb 2-1: new full speed USB device using ohci_hcd and address 2
<6>usb 2-1: configuration #1 chosen from 1 choice
<6>usb 6-2: new high speed USB device using ehci_hcd and address 2
<6>usb 6-2: configuration #1 chosen from 1 choice
<6>hub 6-2:1.0: USB hub found
<6>hub 6-2:1.0: 2 ports detected
<6>usbcore: registered new interface driver hiddev
<6>input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
<6>usbcore: registered new interface driver usbhid
<6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<7>usb-storage: device found at 2
<7>usb-storage: waiting for device to settle before scanning
<6>usb 6-2.1: new high speed USB device using ehci_hcd and address 3
<6>usb 6-2.1: configuration #1 chosen from 1 choice
<6>hub 6-2.1:1.0: USB hub found
<6>hub 6-2.1:1.0: 4 ports detected
<6>usb 6-2.1.1: new high speed USB device using ehci_hcd and address 4
<6>usb 6-2.1.1: configuration #1 chosen from 1 choice
<7>usb-storage: device found at 4
<7>usb-storage: waiting for device to settle before scanning
<6>usbcore: registered new interface driver usb-storage
<7>usb-storage: device scan complete
<7>usb-storage: device scan complete

2.6.22 boot.msg extract ( hub/usb )

<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>usb usb1: configuration #1 chosen from 1 choice
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<6>usb usb2: configuration #1 chosen from 1 choice
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<6>usb 1-1: new low speed USB device using ohci_hcd and address 2
<6>usb usb3: configuration #1 chosen from 1 choice
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 2 ports detected
<6>usb 1-1: configuration #1 chosen from 1 choice
<6>usb usb4: configuration #1 chosen from 1 choice
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 6 ports detected
<6>usb 1-1: USB disconnect, address 2
<6>usb usb5: configuration #1 chosen from 1 choice
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 4 ports detected
<6>usb usb6: configuration #1 chosen from 1 choice
<6>hub 6-0:1.0: USB hub found
<6>hub 6-0:1.0: 2 ports detected
<6>usb usb7: configuration #1 chosen from 1 choice
<6>hub 7-0:1.0: USB hub found
<6>hub 7-0:1.0: 2 ports detected
<6>usb 5-2: new high speed USB device using ehci_hcd and address 2
<6>usb 5-2: configuration #1 chosen from 1 choice
<6>hub 5-2:1.0: USB hub found
<6>hub 5-2:1.0: 2 ports detected
<6>usb 1-1: new low speed USB device using ohci_hcd and address 3
<6>usb 1-1: configuration #1 chosen from 1 choice
<6>usbcore: registered new interface driver hiddev
<6>usb 2-1: new full speed USB device using ohci_hcd and address 2
<6>usb 2-1: configuration #1 chosen from 1 choice
<6>usb 5-2.1: new high speed USB device using ehci_hcd and address 3
<6>usb 5-2.1: configuration #1 chosen from 1 choice
<6>hub 5-2.1:1.0: USB hub found
<6>hub 5-2.1:1.0: 4 ports detected
<6>input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
<7>usb-storage: device found at 2
<7>usb-storage: waiting for device to settle before scanning
<6>usb 5-2.1.1: new high speed USB device using ehci_hcd and address 4
<6>usb 5-2.1.1: configuration #1 chosen from 1 choice
<6>usbcore: registered new interface driver usbhid
<7>usb-storage: device found at 4
<7>usb-storage: waiting for device to settle before scanning
<6>usbcore: registered new interface driver usb-storage
<6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<7>usb-storage: device scan complete
<7>usb-storage: device scan complete



lspci -vnn:

/var/log # lspci -vnn
00:00.0 Host bridge [Class 0600]: Silicon Integrated Systems [SiS] 645xx [1039:0648] (rev 02)
        Subsystem: Silicon Integrated Systems [SiS] 645xx [1039:0648]
        Flags: bus master, medium devsel, latency 32
        Memory at d0000000 (32-bit, non-prefetchable) [size=128M]
        Capabilities: [c0] AGP version 3.0

00:01.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge (AGP) [1039:0001] (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        Memory behind bridge: e0000000-e1ffffff
        Prefetchable memory behind bridge: d8000000-dfffffff

00:02.0 ISA bridge [Class 0601]: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media IO] [1039:0963] (rev 04)
        Flags: bus master, medium devsel, latency 0

00:02.1 SMBus [Class 0c05]: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller [1039:0016]
        Flags: medium devsel
        I/O ports at 10c0 [size=32]

00:02.3 FireWire (IEEE 1394) [Class 0c00]: Silicon Integrated Systems [SiS] FireWire Controller [1039:7007] (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:701d]
        Flags: bus master, medium devsel, latency 32, IRQ 17
        Memory at e2020000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 70000000 [disabled] [size=128K]
        Capabilities: [64] Power Management version 2

00:02.5 IDE interface [Class 0101]: Silicon Integrated Systems [SiS] 5513 [IDE] [1039:5513] (prog-if 80 [Master])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 128, IRQ 16
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at 4000 [size=16]
        Capabilities: [58] Power Management version 2

00:02.7 Multimedia audio controller [Class 0401]: Silicon Integrated Systems [SiS] AC'97 Sound Controller [1039:7012] (rev a0)
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 32, IRQ 22
        I/O ports at d400 [size=256]
        I/O ports at d800 [size=128]
        Capabilities: [48] Power Management version 2

00:03.0 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at e2021000 (32-bit, non-prefetchable) [size=4K]

00:03.1 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at e2022000 (32-bit, non-prefetchable) [size=4K]

00:03.2 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at e2023000 (32-bit, non-prefetchable) [size=4K]

00:03.3 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 2.0 Controller [1039:7002] (prog-if 20 [EHCI])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:7010]
        Flags: bus master, medium devsel, latency 32, IRQ 21
        Memory at e2024000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 2

00:04.0 Ethernet controller [Class 0200]: Silicon Integrated Systems [SiS] SiS900 PCI Fast Ethernet [1039:0900] (rev 91)
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:0900]
        Flags: bus master, medium devsel, latency 32, IRQ 23
        I/O ports at dc00 [size=256]
        Memory at e2025000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 70020000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2

00:07.0 USB Controller [Class 0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038]
        Flags: bus master, medium devsel, latency 32, IRQ 22
        I/O ports at e000 [size=32]
        Capabilities: [80] Power Management version 2

00:07.1 USB Controller [Class 0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038]
        Flags: bus master, medium devsel, latency 32, IRQ 23
        I/O ports at e400 [size=32]
        Capabilities: [80] Power Management version 2

00:07.2 USB Controller [Class 0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 65) (prog-if 20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0 [1106:3104]
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at e2026000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

00:08.0 Multimedia controller [Class 0480]: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder [1131:7134] (rev 01)
        Subsystem: Creatix Polymedia GmbH Medion 7134 [16be:0003]
        Flags: bus master, medium devsel, latency 32, IRQ 23
        Memory at e2027000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1

00:0a.0 Network controller [Class 0280]: Cologne Chip Designs GmbH ISDN network controller [HFC-PCI] [1397:2bd0] (rev 02)
        Subsystem: Cologne Chip Designs GmbH ISDN Board [1397:2bd0]
        Flags: bus master, medium devsel, latency 16, IRQ 5
        I/O ports at e800 [size=8]
        Memory at e2028000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [40] Power Management version 1

01:00.0 VGA compatible controller [Class 0300]: nVidia Corporation NV28 [GeForce4 Ti 4200 AGP 8x] [10de:0281] (rev a1) (prog-if 00 [VGA])
        Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:8890]
        Flags: bus master, 66MHz, medium devsel, latency 248, IRQ 16
        Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d8000000 (32-bit, prefetchable) [size=128M]
        [virtual] Expansion ROM at e1000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [44] AGP version 3.0


lsusb -v:


Bus 006 Device 001: ID 0000:0000
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
  iManufacturer           3 Linux 2.6.22-speedy uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:07.0
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
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 007 Device 001: ID 0000:0000
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
  iManufacturer           3 Linux 2.6.22-speedy uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:07.1
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
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 005 Device 004: ID 0424:2228 Standard Microsystems Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0424 Standard Microsystems Corp.
  idProduct          0x2228
  bcdDevice            4.44
  iManufacturer           1 Generic
  iProduct                2 Flash Card Reader
  iSerial                 3 26020128B005
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
        UNRECOGNIZED:  07 21 07 e8 03 fe ff
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Bus 005 Device 003: ID 0424:2602 Standard Microsystems Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         2 TT per port
  bMaxPacketSize0        64
  idVendor           0x0424 Standard Microsystems Corp.
  idProduct          0x2602
  bcdDevice            0.00
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      1 Single TT
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              12
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      2 TT per port
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x0004
    Ganged power switching
    Compound device
    Ganged overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent      1 milli Ampere
  DeviceRemovable    0x02
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Bus 005 Device 002: ID 0424:2502 Standard Microsystems Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0424 Standard Microsystems Corp.
  idProduct          0x2502
  bcdDevice            0.01
  iManufacturer           0
  iProduct                0
  iSerial                 0
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
    MaxPower                2mA
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
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0004
    Ganged power switching
    Compound device
    Ganged overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent      1 milli Ampere
  DeviceRemovable    0x02
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Bus 005 Device 001: ID 0000:0000
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
  iManufacturer           3 Linux 2.6.22-speedy ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:07.2
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
  nNbrPorts             4
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0503 highspeed power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

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
  iManufacturer           3 Linux 2.6.22-speedy ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.2
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
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 002 Device 002: ID 0db0:6982 Micro Star International Medion Flash XL V2.7A Card Reader
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0db0 Micro Star International
  idProduct          0x6982 Medion Flash XL V2.7A Card Reader
  bcdDevice            3.0c
  iManufacturer           1 MEDION
  iProduct                2 Medion Flash XL V3.0C
  iSerial                 3 2003-02
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 CONFIGURATION
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              5 INTERFACE 0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

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
  iManufacturer           3 Linux 2.6.22-speedy ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.1
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
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 004 Device 001: ID 0000:0000
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
  iManufacturer           3 Linux 2.6.22-speedy ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:03.3
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
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 003: ID 0461:4d16 Primax Electronics, Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0461 Primax Electronics, Ltd
  idProduct          0x4d16
  bcdDevice            2.00
  iManufacturer           0
  iProduct                2 USB Optical Mouse
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      52
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 001: ID 0000:0000
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
  iManufacturer           3 Linux 2.6.22-speedy ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.0
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
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0303 lowspeed power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled
speedy:/var/log #
