Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbYDCHm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbYDCHm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbYDCHmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:42:51 -0400
Received: from main.gmane.org ([80.91.229.2]:50434 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759535AbYDCHmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:42:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: suspend
Followup-To: gmane.linux.usb.general
Date: Thu, 03 Apr 2008 09:42:00 +0200
Message-ID: <ft21pb$oc3$1@ger.gmane.org>
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <ft13p5$h64$1@ger.gmane.org> <200804030155.33888.rjw@sisk.pl> <200804030932.27993.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-62-245-163-229.dynamic.mnet-online.de
User-Agent: KNode/0.10.9
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Please load the appletouch module with the parameter "debug=1" and
> post dmesg of a suspend/resume and the chvt thing.

I found out the appletouch issue was already discused here:
http://lkml.org/lkml/2007/3/28/172

Unfortunately there seems to be no workaround and X-input still has more
issues than it solves..

Attached is the dmesg excerpt

Best regards,
Stefan

usbcore: deregistering interface driver appletouch
input: appletouch disconnected
appletouch: Geyser mode initialized.
input: appletouch
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.1/input/input19
usbcore: registered new interface driver appletouch
PM: Syncing filesystems ... done.
Stopping fuse filesystems.
Freezing user space processes ... (elapsed 0.00 seconds) <6>done.
Stopping normal filesystems.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) <6>done.
ACPI: Preparing to enter system sleep state S3
Suspending console(s)
sd 2:0:1:0: [sda] Synchronizing SCSI cache
sd 2:0:1:0: [sda] Stopping disk
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:02:00.0 disabled
sky2 eth0: disabling interface
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Back to C!
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3995.35 BogoMIPS
(lpj=1997676)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000
0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9
00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Genuine Intel(R) CPU           T2500  @ 2.00GHz stepping 08
CPU1 is up
Switched to high resolution mode on CPU 1
PM: Writing back config space on device 0000:00:02.0 at offset f (was 100,
writing 10a)
PM: Writing back config space on device 0000:00:02.0 at offset 7 (was 0,
writing 90400000)
PM: Writing back config space on device 0000:00:02.0 at offset 6 (was 8,
writing 80000008)
PM: Writing back config space on device 0000:00:02.0 at offset 5 (was 1,
writing 20f1)
PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0,
writing 90380000)
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was
900000, writing 900007)
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:02.0 to 64
PM: Writing back config space on device 0000:00:02.1 at offset 4 (was 0,
writing 90300000)
PM: Writing back config space on device 0000:00:02.1 at offset 1 (was
900000, writing 900007)
PM: Writing back config space on device 0000:00:07.0 at offset f (was 100,
writing 10a)
PM: Writing back config space on device 0000:00:07.0 at offset 4 (was 0,
writing 90444000)
PM: Writing back config space on device 0000:00:07.0 at offset 1 (was
b00000, writing b00002)
PM: Writing back config space on device 0000:00:1b.0 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:00:1b.0 at offset 4 (was 4,
writing 90440004)
PM: Writing back config space on device 0000:00:1b.0 at offset 3 (was 0,
writing 40)
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was
100000, writing 100002)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PM: Writing back config space on device 0000:00:1c.0 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:00:1c.0 at offset 9 (was 10001,
writing 50015001)
PM: Writing back config space on device 0000:00:1c.0 at offset 8 (was 0,
writing 90209020)
PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was
20000000, writing 20001010)
PM: Writing back config space on device 0000:00:1c.0 at offset 6 (was 0,
writing 10100)
PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was
810000, writing 810040)
PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was
100000, writing 100007)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PM: Writing back config space on device 0000:00:1c.1 at offset f (was 200,
writing 20a)
PM: Writing back config space on device 0000:00:1c.1 at offset 9 (was 10001,
writing 1fff1)
PM: Writing back config space on device 0000:00:1c.1 at offset 8 (was 0,
writing 90109010)
PM: Writing back config space on device 0000:00:1c.1 at offset 7 (was
20000000, writing f0)
PM: Writing back config space on device 0000:00:1c.1 at offset 6 (was 0,
writing 20200)
PM: Writing back config space on device 0000:00:1c.1 at offset 3 (was
810000, writing 810040)
PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was
100000, writing 100007)
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Enabling device 0000:00:1d.0 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:00:1d.0 at offset 8 (was 1,
writing 20a1)
usb usb1: root hub lost power or was reset
PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200,
writing 20b)
PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1,
writing 2081)
usb usb2: root hub lost power or was reset
PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300,
writing 30b)
PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1,
writing 2061)
usb usb3: root hub lost power or was reset
PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.3 to 64
PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400,
writing 40a)
PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1,
writing 2041)
usb usb4: root hub lost power or was reset
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1d.7 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0,
writing 90445400)
PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001,
writing 1fff1)
PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0,
writing 90009000)
PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was
22800000, writing 228000f0)
PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 0,
writing 20030300)
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was
100000, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PM: Writing back config space on device 0000:00:1f.1 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was
2800001, writing 2800005)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200,
writing 20b)
PM: Writing back config space on device 0000:00:1f.2 at offset 8 (was 1,
writing 2021)
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was
2b00002, writing 2b00007)
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200,
writing 20b)
PM: Writing back config space on device 0000:01:00.0 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:01:00.0 at offset c (was 0,
writing fffe0000)
PM: Writing back config space on device 0000:01:00.0 at offset 6 (was 1,
writing 1001)
PM: Writing back config space on device 0000:01:00.0 at offset 4 (was 4,
writing 90200004)
PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0,
writing 40)
PM: Writing back config space on device 0000:01:00.0 at offset 1 (was
40100000, writing 100007)
sky2 eth0: enabling interface
PM: Writing back config space on device 0000:02:00.0 at offset f (was 100,
writing 10b)
PM: Writing back config space on device 0000:02:00.0 at offset 4 (was 4,
writing 90100004)
PM: Writing back config space on device 0000:02:00.0 at offset 3 (was 0,
writing 40)
PM: Writing back config space on device 0000:02:00.0 at offset 1 (was
100000, writing 100007)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
PM: Writing back config space on device 0000:03:03.0 at offset f (was
180c0100, writing 180c010b)
PM: Writing back config space on device 0000:03:03.0 at offset 4 (was 0,
writing 90000000)
PM: Writing back config space on device 0000:03:03.0 at offset 3 (was 0,
writing f810)
PM: Writing back config space on device 0000:03:03.0 at offset 1 (was
2900000, writing 2900216)
sd 2:0:1:0: [sda] Starting disk
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
ata3.01: configured for UDMA/100
sd 2:0:1:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
ata1.00: configured for UDMA/66
restoring control 00000000-0000-0000-0000-000000000101/0/2
restoring control 00000000-0000-0000-0000-000000000101/3/7
restoring control 00000000-0000-0000-0000-000000000101/5/9
applesmc: received a shock interrupt
applesmc: cannot setup irq handler
applesmc: accelerometer successfully initialized.
Restarting all filesystems ...
Restarting tasks ... <6>usb 1-1: USB disconnect, address 6
done.
usb 1-1: new low speed USB device using uhci_hcd and address 8
usb 1-1: configuration #1 chosen from 1 choice
input: HID 0461:4d03
as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input20
input: USB HID v1.10 Mouse [HID 0461:4d03] on usb-0000:00:1d.0-1
usb 1-2: USB disconnect, address 7
input: appletouch disconnected
usb 1-2: new full speed USB device using uhci_hcd and address 9
usb 1-2: configuration #1 chosen from 1 choice
input: Apple Computer Apple Internal Keyboard / Trackpad
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input21
input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
appletouch: Geyser mode initialized.
input: appletouch
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.1/input/input22
appletouch: incomplete data package (first byte: 2, length: 4).
input: Apple Computer Apple Internal Keyboard / Trackpad
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.2/input/input23
input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard /
Trackpad] on usb-0000:00:1d.0-2
usb 3-2: USB disconnect, address 3
usb 3-2: new full speed USB device using uhci_hcd and address 4
usb 3-2: configuration #1 chosen from 1 choice
hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on
usb-0000:00:1d.2-2
usb 4-1: USB disconnect, address 3
usb 4-1: new full speed USB device using uhci_hcd and address 4
usb 4-1: configuration #1 chosen from 1 choice
input: HID 05ac:1000
as /devices/pci0000:00/0000:00:1d.3/usb4/4-1/4-1:1.0/input/input24
input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
input: HID 05ac:1000
as /devices/pci0000:00/0000:00:1d.3/usb4/4-1/4-1:1.1/input/input25
input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1

