Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbZIXKNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbZIXKNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZIXKNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:13:41 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42710 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZIXKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=xNldignkKcWCqq5w2kgLG832BFdUIRo1PdElYmlyzZUsTIv0ihonZNQ08GNl0r/2DS
         IfB5U6VWClVORFVr9KnUK/svFDe5/bCZI3nZfK8TFb+leon3Z+HVQjy5mpc9jmxM+Ct4
         T9Kqb8sIlqYNXdg+8MoeEiVamIN2GMdweUZ/k=
Date: Thu, 24 Sep 2009 12:16:17 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Disassociating atheros wlan with 2.6.31
Message-Id: <20090924121617.c0c7222d.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

When moving from vanilla 2.6.30->2.6.31 I noticed that I get dissasociated from
my wlan hub with regular intervalls. This did not happen on 2.6.30.
I cant see any pattern aside from that it happens at regular intervalls
(around 10-15mins). It works again when I re-identifies myself.

Got an Asus 1000HE with Atheros chipset.
Havent had time to bisect it, just wanted to check
if this is an known issue. Ive ruled out faulty wlan hub
since everything works fine when going back to 2.6.30.

nothing much on dmesg:
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input7
usb 1-4: new high speed USB device using ehci_hcd and address 3
usb 1-4: configuration #1 chosen from 1 choice
hub 1-4:1.0: USB hub found
hub 1-4:1.0: 4 ports detected
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb 1-5: configuration #1 chosen from 1 choice
usb 1-8: new high speed USB device using ehci_hcd and address 6
usb 1-8: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi4 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
usb 2-2: new full speed USB device using uhci_hcd and address 2
ath9k 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ath9k 0000:01:00.0: setting latency timer to 64
usb 2-2: configuration #1 chosen from 1 choice
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
usb 1-4.1: new full speed USB device using ehci_hcd and address 7
ath: EEPROM regdomain: 0x60
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x60
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.5
usb 1-4.1: configuration #1 chosen from 1 choice
usb 1-4.2: new low speed USB device using ehci_hcd and address 8
usb 1-4.2: configuration #1 chosen from 1 choice
usb 1-4.4: new low speed USB device using ehci_hcd and address 9
usbcore: registered new interface driver hiddev
input: HID 04d9:1203 as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.2/1-4.2:1.0/input/input9
generic-usb 0003:04D9:1203.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 04d9:1203] on usb-0000:00:1d.7-4.2/input0
input: HID 04d9:1203 as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.2/1-4.2:1.1/input/input10
generic-usb 0003:04D9:1203.0002: input,hidraw1: USB HID v1.11 Device [HID 04d9:1203] on usb-0000:00:1d.7-4.2/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 1-4.4: configuration #1 chosen from 1 choice
input: B16_b_02 USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.4/1-4.4:1.0/input/input11
generic-usb 0003:046D:C025.0003: input,hidraw2: USB HID v1.10 Mouse [B16_b_02 USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-4.4/input0
usbcore: registered new interface driver btusb
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for GSM modem (1-port)
option 2-2:1.0: GSM modem (1-port) converter detected
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
option 2-2:1.1: GSM modem (1-port) converter detected
usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
USB Serial support registered for pl2303
pl2303 1-4.1:1.0: pl2303 converter detected
usb 1-4.1: pl2303 converter now attached to ttyUSB2
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xf8880000, irq=19
scsi 4:0:0:0: Direct-Access     Single   Flash Reader     1.00 PQ: 0 ANSI: 0
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: [sdb] 15954944 512-byte logical blocks: (8.16 GB/7.60 GiB)
usb-storage: device scan complete
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] Attached SCSI removable disk
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda1, internal journal
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bridge firewalling registered
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
ATL1E 0000:03:00.0: irq 27 for MSI/MSI-X
fuse init (API version 7.12)
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
wlan0: authenticate with AP 00:14:7c:ae:d1:90
wlan0: authenticated
wlan0: associate with AP 00:14:7c:ae:d1:90
wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=0x431 status=0 aid=5)
wlan0: associated
PPP generic driver version 2.4.2
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
PPP BSD Compression module registered
PPP Deflate Compression module registered
wlan0: no IPv6 routers present
CE: hpet increasing min_delta_ns to 15000 nsec
wlan0: no probe response from AP 00:14:7c:ae:d1:90 - disassociating
wlan0: authenticate with AP 00:14:7c:ae:d1:90
wlan0: authenticated
wlan0: associate with AP 00:14:7c:ae:d1:90
wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=0x431 status=0 aid=5)
wlan0: associated
wlan0: authenticate with AP 00:14:7c:ae:d1:90
wlan0: authenticated
wlan0: associate with AP 00:14:7c:ae:d1:90
wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=0x431 status=0 aid=5)
wlan0: associated
[kristoffer@boggieman wine.git]$


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
