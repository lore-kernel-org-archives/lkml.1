Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXBXLvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXBXLvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXBXLvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:51:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXBXLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:51:52 -0500
Date: Sat, 24 Feb 2007 12:51:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       marcel@holtmann.org
Subject: 2.6.20-almost-rc1: usb oops during resume
Message-ID: <20070224115137.GA8658@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...is it "use after free"?

Greg, could we reduce verbosity of driver model? "PM: Adding info for
No Bus:vcs*" is not very useful.

I have some patches in bluetooth, but nothing that should really
matter.

								Pavel

Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Starting balanced_irq
Using IPI No-Shortcut mode
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
Time: acpi_pm clocksource has been installed.
PM: Resume from disk failed.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 280k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs23
PM: Adding info for No Bus:vcsa23
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Adding info for No Bus:vcs12
PM: Adding info for No Bus:vcsa12
pcmcia: Detected deprecated PCMCIA ioctl usage from process: cardmgr.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
cs: IO port probe 0x310-0x380: clean.
cs: IO port probe 0xa00-0xaff: clean.
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
Clocksource tsc unstable (delta = -299687739 ns)
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcsa8
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:vcsa2
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.080519b0.00000000)
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
coda_upcall: Venus dead on (op,un) (7.2) flags 10
Failure of coda_cnode_make for root: error -19
usb 5-1: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:5-1
PM: Adding info for No Bus:usbdev5.3_ep00
usb 5-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-1:1.0
PM: Adding info for No Bus:hci0
PM: Adding info for No Bus:usbdev5.3_ep81
PM: Adding info for No Bus:usbdev5.3_ep82
PM: Adding info for No Bus:usbdev5.3_ep02
PM: Adding info for usb:5-1:1.1
PM: Adding info for No Bus:usbdev5.3_ep83
PM: Adding info for No Bus:usbdev5.3_ep03
PM: Adding info for usb:5-1:1.2
PM: Adding info for No Bus:usbdev5.3_ep84
PM: Adding info for No Bus:usbdev5.3_ep04
PM: Adding info for usb:5-1:1.3
PM: Adding info for No Bus:usbdev5.3
hci_cmd_task: hci0 command tx timeout
PM: Adding info for No Bus:rfcomm0
PM: Adding info for bluetooth:acl00E0033C043E
PM: Adding info for No Bus:ppp0
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
PM: Removing info for No Bus:ppp0
PM: Preparing system for mem sleep
Stopping tasks ... done.
Suspending console(s)
usb 5-1:1.3: suspend
usb 5-1:1.2: suspend
hci_usb 5-1:1.1: suspend
hci_usb 5-1:1.0: suspend
usb 5-1: suspend, may wakeup
mmcblk mmc0:cc53: suspend
psmouse serio1: suspend
atkbd serio0: suspend
__tx_submit: hci0 tx submit failed urb f7ef661c type 1 err -113
i8042 i8042: suspend
 usbdev5.2: PM: suspend 0->2, parent 5-2 already 2
 usbdev5.2_ep83: PM: suspend 0->2, parent 5-2:1.0 already 2
 usbdev5.2_ep02: PM: suspend 0->2, parent 5-2:1.0 already 2
 usbdev5.2_ep81: PM: suspend 0->2, parent 5-2:1.0 already 2
usb 5-2:1.0: PM: suspend 2-->2
usb 5-2:1.0: PM: suspend 2->2, parent 5-2 already 2
 usbdev5.2_ep00: PM: suspend 0->2, parent 5-2 already 2
usb 5-2: PM: suspend 2-->2
hub 5-0:1.0: suspend
usb usb5: suspend, may wakeup
 usbdev4.1: PM: suspend 0->2, parent usb4 already 2
 usbdev4.1_ep81: PM: suspend 0->2, parent 4-0:1.0 already 2
hub 4-0:1.0: PM: suspend 2-->2
hub 4-0:1.0: PM: suspend 2->2, parent usb4 already 2
 usbdev4.1_ep00: PM: suspend 0->2, parent usb4 already 2
usb usb4: PM: suspend 2-->2
 usbdev3.1: PM: suspend 0->2, parent usb3 already 2
 usbdev3.1_ep81: PM: suspend 0->2, parent 3-0:1.0 already 2
hub 3-0:1.0: PM: suspend 2-->2
hub 3-0:1.0: PM: suspend 2->2, parent usb3 already 2
 usbdev3.1_ep00: PM: suspend 0->2, parent usb3 already 2
usb usb3: PM: suspend 2-->2
 usbdev2.1: PM: suspend 0->2, parent usb2 already 2
 usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
hub 2-0:1.0: PM: suspend 2-->2
hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
 usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
usb usb2: PM: suspend 2-->2
 usbdev1.1: PM: suspend 0->2, parent usb1 already 2
 usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
hub 1-0:1.0: PM: suspend 2-->2
hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
 usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
usb usb1: PM: suspend 2-->2
sd 0:0:0:0: suspend
serial8250 serial8250: suspend
vesafb vesafb.0: suspend
pcspkr pcspkr: suspend
platform bluetooth: suspend
pnp 00:0b: suspend
pnp 00:0a: suspend
i8042 aux 00:09: suspend
i8042 kbd 00:08: suspend
rtc_cmos 00:07: suspend, may wakeup
pnp 00:06: suspend
pnp 00:05: suspend
pnp 00:04: suspend
pnp 00:03: suspend
system 00:02: suspend
pnp 00:01: suspend
system 00:00: suspend
sdhci 0000:15:00.2: suspend
ACPI: PCI interrupt for device 0000:15:00.2 disabled
ohci1394 0000:15:00.1: suspend
yenta_cardbus 0000:15:00.0: suspend
pci 0000:03:00.0: suspend
e1000 0000:02:00.0: suspend
ACPI: PCI interrupt for device 0000:02:00.0 disabled
pci 0000:00:1f.3: suspend
ahci 0000:00:1f.2: suspend
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
PIIX_IDE 0000:00:1f.1: suspend
pci 0000:00:1f.0: suspend
pci 0000:00:1e.0: suspend
ehci_hcd 0000:00:1d.7: suspend, may wakeup
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
uhci_hcd 0000:00:1d.3: suspend
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
uhci_hcd 0000:00:1d.2: suspend
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
uhci_hcd 0000:00:1d.1: suspend
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
uhci_hcd 0000:00:1d.0: suspend
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
pci 0000:00:1c.3: suspend
pci 0000:00:1c.2: suspend
pci 0000:00:1c.1: suspend
pci 0000:00:1c.0: suspend
HDA Intel 0000:00:1b.0: suspend
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
pci 0000:00:02.1: suspend
pci 0000:00:02.0: suspend
agpgart-intel 0000:00:00.0: suspend
thermal thermal:02: suspend
thermal thermal:01: suspend
acpi thermal:00: suspend
acpi device:20: suspend
acpi device:1f: suspend
acpi device:1e: suspend
acpi device:1d: suspend
acpi device:1c: suspend
acpi device:1b: suspend
acpi device:1a: suspend
acpi device:19: suspend
acpi device:18: suspend
acpi device:17: suspend
acpi device:16: suspend
acpi device:15: suspend
acpi device:14: suspend
acpi device:13: suspend
acpi device:12: suspend
acpi device:11: suspend
acpi device:10: suspend
acpi device:0f: suspend
acpi device:0e: suspend
acpi device:0d: suspend
acpi device:0c: suspend
acpi device:0b: suspend
acpi device:0a: suspend
acpi device:09: suspend
acpi device:08: suspend
acpi device:07: suspend
acpi device:06: suspend
acpi device:05: suspend
video video:01: suspend
acpi device:04: suspend
acpi device:03: suspend
acpi device:02: suspend
video video:00: suspend
ibm_hotkey IBM0068:00: suspend
ac ACPI0003:00: suspend
battery PNP0C0A:00: suspend
power power_resource:00: suspend
ec PNP0C09:00: suspend
acpi ATM1200:00: suspend
acpi IBM0071:00: suspend
acpi IBM3780:00: suspend
acpi PNP0303:00: suspend
acpi PNP0B00:00: suspend
acpi PNP0C04:00: suspend
acpi PNP0800:00: suspend
acpi PNP0200:00: suspend
acpi PNP0103:00: suspend
acpi PNP0100:00: suspend
acpi PNP0000:00: suspend
acpi PNP0C02:00: suspend
acpi device:01: suspend
pci_root PNP0A08:00: suspend
button PNP0C0E:00: suspend
button PNP0C0D:00: suspend
acpi PNP0C01:00: suspend
pci_link PNP0C0F:07: suspend
pci_link PNP0C0F:06: suspend
pci_link PNP0C0F:05: suspend
pci_link PNP0C0F:04: suspend
pci_link PNP0C0F:03: suspend
pci_link PNP0C0F:02: suspend
pci_link PNP0C0F:01: suspend
pci_link PNP0C0F:00: suspend
acpi device:00: suspend
processor ACPI0007:01: suspend
processor ACPI0007:00: suspend
button button_power:00: suspend
acpi acpi_system:00: suspend
platform bay.0: suspend
platform dock.0: suspend
Disabling non-boot CPUs ...
Breaking affinity for irq 22
CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Removing info for No Bus:msr1
CPU1 is down
PM: Entering mem sleep
serial8250 serial8250: LATE suspend
vesafb vesafb.0: LATE suspend
pcspkr pcspkr: LATE suspend
platform bluetooth: LATE suspend
sdhci 0000:15:00.2: LATE suspend
ohci1394 0000:15:00.1: LATE suspend
yenta_cardbus 0000:15:00.0: LATE suspend
pci 0000:03:00.0: LATE suspend
e1000 0000:02:00.0: LATE suspend
pci 0000:00:1f.3: LATE suspend
PIIX_IDE 0000:00:1f.1: LATE suspend
pci 0000:00:1f.0: LATE suspend
pci 0000:00:1e.0: LATE suspend
pci 0000:00:1c.3: LATE suspend
pci 0000:00:1c.2: LATE suspend
pci 0000:00:1c.1: LATE suspend
pci 0000:00:1c.0: LATE suspend
HDA Intel 0000:00:1b.0: LATE suspend
pci 0000:00:02.1: LATE suspend
pci 0000:00:02.0: LATE suspend
agpgart-intel 0000:00:00.0: LATE suspend
platform bay.0: LATE suspend
platform dock.0: LATE suspend
 hwsleep-0318 [-1267] enter_sleep_state     : Entering sleep state [S3]
Back to C!
platform dock.0: EARLY resume
platform bay.0: EARLY resume
agpgart-intel 0000:00:00.0: EARLY resume
pci 0000:00:02.0: EARLY resume
pci 0000:00:02.1: EARLY resume
HDA Intel 0000:00:1b.0: EARLY resume
pci 0000:00:1c.0: EARLY resume
pci 0000:00:1c.1: EARLY resume
pci 0000:00:1c.2: EARLY resume
pci 0000:00:1c.3: EARLY resume
uhci_hcd 0000:00:1d.0: EARLY resume
uhci_hcd 0000:00:1d.1: EARLY resume
uhci_hcd 0000:00:1d.2: EARLY resume
uhci_hcd 0000:00:1d.3: EARLY resume
ehci_hcd 0000:00:1d.7: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
PIIX_IDE 0000:00:1f.1: EARLY resume
ahci 0000:00:1f.2: EARLY resume
pci 0000:00:1f.3: EARLY resume
e1000 0000:02:00.0: EARLY resume
pci 0000:03:00.0: EARLY resume
yenta_cardbus 0000:15:00.0: EARLY resume
ohci1394 0000:15:00.1: EARLY resume
sdhci 0000:15:00.2: EARLY resume
platform bluetooth: EARLY resume
pcspkr pcspkr: EARLY resume
vesafb vesafb.0: EARLY resume
serial8250 serial8250: EARLY resume
i8042 i8042: EARLY resume
PM: Finishing wakeup.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 20089.03 BogoMIPS (lpj=100445195)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
PM: Adding info for No Bus:msr1
CPU1 is up
platform dock.0: resuming
platform bay.0: resuming
acpi acpi_system:00: resuming
button button_power:00: resuming
processor ACPI0007:00: resuming
processor ACPI0007:01: resuming
acpi device:00: resuming
pci_link PNP0C0F:00: resuming
pci_link PNP0C0F:01: resuming
pci_link PNP0C0F:02: resuming
pci_link PNP0C0F:03: resuming
pci_link PNP0C0F:04: resuming
pci_link PNP0C0F:05: resuming
pci_link PNP0C0F:06: resuming
pci_link PNP0C0F:07: resuming
acpi PNP0C01:00: resuming
button PNP0C0D:00: resuming
button PNP0C0E:00: resuming
pci_root PNP0A08:00: resuming
acpi device:01: resuming
acpi PNP0C02:00: resuming
acpi PNP0000:00: resuming
acpi PNP0100:00: resuming
acpi PNP0103:00: resuming
acpi PNP0200:00: resuming
acpi PNP0800:00: resuming
acpi PNP0C04:00: resuming
acpi PNP0B00:00: resuming
acpi PNP0303:00: resuming
acpi IBM3780:00: resuming
acpi IBM0071:00: resuming
acpi ATM1200:00: resuming
ec PNP0C09:00: resuming
power power_resource:00: resuming
battery PNP0C0A:00: resuming
ac ACPI0003:00: resuming
ibm_hotkey IBM0068:00: resuming
video video:00: resuming
acpi device:02: resuming
acpi device:03: resuming
acpi device:04: resuming
video video:01: resuming
acpi device:05: resuming
acpi device:06: resuming
acpi device:07: resuming
acpi device:08: resuming
acpi device:09: resuming
acpi device:0a: resuming
acpi device:0b: resuming
acpi device:0c: resuming
acpi device:0d: resuming
acpi device:0e: resuming
acpi device:0f: resuming
acpi device:10: resuming
acpi device:11: resuming
acpi device:12: resuming
acpi device:13: resuming
acpi device:14: resuming
acpi device:15: resuming
acpi device:16: resuming
acpi device:17: resuming
acpi device:18: resuming
acpi device:19: resuming
acpi device:1a: resuming
acpi device:1b: resuming
acpi device:1c: resuming
acpi device:1d: resuming
acpi device:1e: resuming
acpi device:1f: resuming
acpi device:20: resuming
acpi thermal:00: resuming
thermal thermal:01: resuming
thermal thermal:02: resuming
agpgart-intel 0000:00:00.0: resuming
pci 0000:00:02.0: resuming
pci 0000:00:02.1: resuming
PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900003)
HDA Intel 0000:00:1b.0: resuming
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
PCI: Setting latency timer of device 0000:00:1b.0 to 64
pci 0000:00:1c.0: resuming
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pci 0000:00:1c.1: resuming
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pci 0000:00:1c.2: resuming
PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20006050, writing 6050)
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pci 0000:00:1c.3: resuming
PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400, writing 4040b)
PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e421e421)
PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing ebf0ea00)
PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000000, writing 8070)
PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100107)
PCI: Setting latency timer of device 0000:00:1c.3 to 64
uhci_hcd 0000:00:1d.0: resuming
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: resuming
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: resuming
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: resuming
PCI: Setting latency timer of device 0000:00:1d.3 to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: resuming
PCI: Setting latency timer of device 0000:00:1d.7 to 64
pci 0000:00:1e.0: resuming
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
PIIX_IDE 0000:00:1f.1: resuming
ahci 0000:00:1f.2: resuming
PCI: Setting latency timer of device 0000:00:1f.2 to 64
pci 0000:00:1f.3: resuming
e1000 0000:02:00.0: resuming
PCI: Setting latency timer of device 0000:02:00.0 to 64
pci 0000:03:00.0: resuming
yenta_cardbus 0000:15:00.0: resuming
ohci1394 0000:15:00.1: resuming
PM: Writing back config space on device 0000:15:00.1 at offset 4 (was 0, writing e4301000)
PM: Writing back config space on device 0000:15:00.1 at offset 3 (was 800000, writing 804000)
PM: Writing back config space on device 0000:15:00.1 at offset 1 (was 2100000, writing 2100006)
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[16]  MMIO=[e4301000-e43017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
sdhci 0000:15:00.2: resuming
PM: Writing back config space on device 0000:15:00.2 at offset 4 (was 0, writing e4301800)
PM: Writing back config space on device 0000:15:00.2 at offset 3 (was 800000, writing 804000)
PM: Writing back config space on device 0000:15:00.2 at offset 1 (was 2100000, writing 2100006)
system 00:00: resuming
pnp 00:01: resuming
system 00:02: resuming
pnp 00:03: resuming
pnp 00:04: resuming
pnp 00:05: resuming
pnp 00:06: resuming
rtc_cmos 00:07: resuming
i8042 kbd 00:08: resuming
pnp: Device 00:08 does not support activation.
i8042 aux 00:09: resuming
pnp: Device 00:09 does not support activation.
pnp 00:0a: resuming
pnp 00:0b: resuming
platform bluetooth: resuming
pcspkr pcspkr: resuming
vesafb vesafb.0: resuming
serial8250 serial8250: resuming
sd 0:0:0:0: resuming
 usbdev1.1_ep00: PM: resume from 0, parent usb1 still 2
 usbdev1.1_ep81: PM: resume from 0, parent 1-0:1.0 still 2
 usbdev1.1: PM: resume from 0, parent usb1 still 2
usb usb2: resuming
usb usb3: resuming
usb usb4: resuming
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
usb usb5: resuming
hub 5-0:1.0: resuming
 usbdev5.2_ep00: PM: resume from 0, parent 5-2 still 2
 usbdev5.2_ep81: PM: resume from 0, parent 5-2:1.0 still 2
 usbdev5.2_ep02: PM: resume from 0, parent 5-2:1.0 still 2
 usbdev5.2_ep83: PM: resume from 0, parent 5-2:1.0 still 2
 usbdev5.2: PM: resume from 0, parent 5-2 still 2
i8042 i8042: resuming
atkbd serio0: resuming
psmouse serio1: resuming
mmcblk mmc0:cc53: resuming
usb 5-1: resuming
 usbdev5.3_ep00: PM: resume from 0, parent 5-1 still 2
hci_usb 5-1:1.0: PM: resume from 2, parent 5-1 still 2
hci_usb 5-1:1.0: resuming
 hci0: PM: resume from 0, parent 5-1:1.0 still 2
 usbdev5.3_ep81: PM: resume from 0, parent 5-1:1.0 still 2
 usbdev5.3_ep82: PM: resume from 0, parent 5-1:1.0 still 2
 usbdev5.3_ep02: PM: resume from 0, parent 5-1:1.0 still 2
hci_usb 5-1:1.1: PM: resume from 2, parent 5-1 still 2
hci_usb 5-1:1.1: resuming
 usbdev5.3_ep83: PM: resume from 0, parent 5-1:1.1 still 2
 usbdev5.3_ep03: PM: resume from 0, parent 5-1:1.1 still 2
usb 5-1:1.2: PM: resume from 2, parent 5-1 still 2
usb 5-1:1.2: resuming
 usbdev5.3_ep84: PM: resume from 0, parent 5-1:1.2 still 2
 usbdev5.3_ep04: PM: resume from 0, parent 5-1:1.2 still 2
usb 5-1:1.3: PM: resume from 2, parent 5-1 still 2
usb 5-1:1.3: resuming
 usbdev5.3: PM: resume from 0, parent 5-1 still 2
Restarting tasks ... <6>usb 5-1: USB disconnect, address 3
PM: Removing info for No Bus:usbdev5.3_ep81
done.
PM: Removing info for No Bus:usbdev5.3_ep82
PM: Removing info for No Bus:usbdev5.3_ep02
slab error in verify_redzone_free(): cache `size-512': memory outside object was overwritten
 [<c016d268>] cache_free_debugcheck+0x128/0x1d0
 [<c04ba1c3>] hci_usb_close+0xf3/0x160
 [<c016e5e0>] kfree+0x50/0xa0
 [<c04ba1c3>] hci_usb_close+0xf3/0x160
 [<c04ba29e>] hci_usb_disconnect+0x2e/0x90
 [<c0456483>] usb_disable_interface+0x53/0x70
 [<c0458f60>] usb_unbind_interface+0x50/0xa0
 [<c032ce78>] __device_release_driver+0x68/0xb0
 [<c032d21e>] device_release_driver+0x1e/0x40
 [<c032c74b>] bus_remove_device+0x8b/0xa0
 [<c032b079>] device_del+0x169/0x1d0
 [<c0456edd>] usb_disable_device+0x4d/0x100
 [<c0450f2a>] usb_disconnect+0x9a/0x120
 [<c04538f5>] hub_thread+0x3d5/0xe20
 [<c0121b61>] __activate_task+0x21/0x40
 [<c012494f>] try_to_wake_up+0x3f/0x420
 [<c013d170>] autoremove_wake_function+0x0/0x50
 [<c0453520>] hub_thread+0x0/0xe20
 [<c013d0bc>] kthread+0xec/0xf0
 [<c013cfd0>] kthread+0x0/0xf0
 [<c0104cab>] kernel_thread_helper+0x7/0x1c
 =======================
e9087b3c: redzone 1:0x5a5a5a5a, redzone 2:0x170fc2a5.
------------[ cut here ]------------
kernel BUG at mm/slab.c:2876!
invalid opcode: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c016d2f2>]    Not tainted VLI
EFLAGS: 00010002   (2.6.20 #402)
EIP is at cache_free_debugcheck+0x1b2/0x1d0
eax: e9087b34   ebx: e90870f8   ecx: 00052c00   edx: 0000020c
esi: c20df680   edi: e9087b3c   ebp: 5a5a5a5a   esp: c21abdec
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 271, ti=c21aa000 task=c22af0b0 task.ti=c21aa000)
Stack: c06c6d04 e9087b3c 5a5a5a5a 170fc2a5 c04ba1c3 e90870c0 c20df680 c23e3330 
       e9087b40 00000282 c016e5e0 f7ef661c f7ef6608 00000000 00000000 c04ba1c3 
       e945172c e945175c e9068448 e94516a0 00000000 e94516a0 e9068448 c07c2960 
Call Trace:
 [<c04ba1c3>] hci_usb_close+0xf3/0x160
 [<c016e5e0>] kfree+0x50/0xa0
 [<c04ba1c3>] hci_usb_close+0xf3/0x160
 [<c04ba29e>] hci_usb_disconnect+0x2e/0x90
 [<c0456483>] usb_disable_interface+0x53/0x70
 [<c0458f60>] usb_unbind_interface+0x50/0xa0
 [<c032ce78>] __device_release_driver+0x68/0xb0
 [<c032d21e>] device_release_driver+0x1e/0x40
 [<c032c74b>] bus_remove_device+0x8b/0xa0
 [<c032b079>] device_del+0x169/0x1d0
 [<c0456edd>] usb_disable_device+0x4d/0x100
 [<c0450f2a>] usb_disconnect+0x9a/0x120
 [<c04538f5>] hub_thread+0x3d5/0xe20
 [<c0121b61>] __activate_task+0x21/0x40
 [<c012494f>] try_to_wake_up+0x3f/0x420
 [<c013d170>] autoremove_wake_function+0x0/0x50
 [<c0453520>] hub_thread+0x0/0xe20
 [<c013d0bc>] kthread+0xec/0xf0
 [<c013cfd0>] kthread+0x0/0xf0
 [<c0104cab>] kernel_thread_helper+0x7/0x1c
 =======================
Code: f0 2c 5a 75 8b b9 5e 5e 6c c0 89 f2 b8 6c 9a 62 c0 e8 a3 f4 ff ff eb 89 81 fb a5 c2 0f 17 0f 85 6c ff ff ff 90 8d 74 26 00 eb 8e <0f> 0b eb fe 0f 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 8b 52 0c 
EIP: [<c016d2f2>] cache_free_debugcheck+0x1b2/0x1d0 SS:ESP 0068:c21abdec
ata1: waiting for device to spin up (7 secs)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
SCSI device sda: 117210240 512-byte hdwr sectors (60012 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index d66064c..2ebbf07 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -45,11 +45,6 @@ #include <net/bluetooth/hci_core.h>
 
 #include "hci_uart.h"
 
-#ifndef CONFIG_BT_HCIUART_DEBUG
-#undef  BT_DBG
-#define BT_DBG( A... )
-#endif
-
 #define VERSION "0.3"
 
 static int txcrc = 1;
@@ -286,6 +281,7 @@ static struct sk_buff *bcsp_prepare_pkt(
 	}
 
 	/* Put payload */
+	/* FIXME: this is really ineffective */
 	for (i = 0; i < len; i++) {
 		bcsp_slip_one_byte(nskb, data[i]);
 
@@ -440,6 +436,7 @@ static void bcsp_handle_le_pkt(struct hc
 	else if (bcsp->rx_skb->data[1] >> 4 == 4 && bcsp->rx_skb->data[2] == 0 &&
 			!memcmp(&bcsp->rx_skb->data[4], sync_pkt, 4)) {
 		BT_ERR("Found a LE sync pkt, card has reset");
+		/* FIXME! */
 	}
 }
 
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 0f4203b..12dee0d 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -46,11 +46,6 @@ #include <net/bluetooth/hci_core.h>
 
 #include "hci_uart.h"
 
-#ifndef CONFIG_BT_HCIUART_DEBUG
-#undef  BT_DBG
-#define BT_DBG( A... )
-#endif
-
 #define VERSION "2.2"
 
 static int reset = 0;
@@ -184,9 +179,9 @@ static int hci_uart_flush(struct hci_dev
 
 	BT_DBG("hdev %p tty %p", hdev, tty);
 
-	if (hu->tx_skb) {
-		kfree_skb(hu->tx_skb); hu->tx_skb = NULL;
-	}
+	if (hu->tx_skb)
+		kfree_skb(hu->tx_skb);
+	hu->tx_skb = NULL;
 
 	/* Flush any pending characters in the driver and discipline. */
 	tty_ldisc_flush(tty);
@@ -366,6 +361,7 @@ static void hci_uart_tty_receive(struct 
 		return;
 
 	spin_lock(&hu->rx_lock);
+	/* FIXME: what about some error handling? */
 	hu->proto->recv(hu, (void *) data, count);
 	hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
@@ -480,11 +476,8 @@ static int hci_uart_tty_ioctl(struct tty
 		return -EUNATCH;
 
 	default:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-	};
-
-	return err;
+		return n_tty_ioctl(tty, file, cmd, arg);
+	}
 }
 
 /*

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
