Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXLNE5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXLNE5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762617AbXLNE53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:57:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:52753 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762253AbXLNE51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=N85AzcrtceLFBaCeSnYUJSUaeUaf/xOIHh3TcSno2ZwCyChplpYAzfIMPKOTJ45TuoG0PlYjsAunK4xIEkhxIuzZxzNhfSuxiJwa43k6q3SE0gz1fKTaPLDBpAsSnCw5Rm65JucCatL1YmjvAW/d76jWBYByvxx9QmYsAiG8SOE=
Message-ID: <32209efe0712132057x247219e0m602f24d1e3a2c20b@mail.gmail.com>
Date: Thu, 13 Dec 2007 20:57:24 -0800
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-dvb@linuxtv.org, linux-acpi@vger.kernel.org
Subject: [BUG] Kernel Bugs Weekly (maybe bi-weekly)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the listing of open bugs that are not new time wise, mostly
over a month old, which is a long time for current rate of
development.
Most bugs need initial response, and all need attention (tlc).
It would be appreciated if the corresponding maintenance team could
take a look at the bugs, close off any which are fixed and see if they
can fix any which aren't.

It would be best to make a note to the reporter and others who are
searching for answers in bugzillas that bug is being worked on. (After
all, bugzilla is not just a tracking tool, it is a knowledge base for
many grateful users.) It is also encouraged setting status to
"assigned" in those bugs that are "taken".

Thanks.


FILESYSTEMS=========================================================

reiserfs NET=n build error
http://bugzilla.kernel.org/show_bug.cgi?id=9205
Kernel: >2.6.19, believed to still exist with current kernel

unlink broken in hfsplus - hard links
http://bugzilla.kernel.org/show_bug.cgi?id=9204
Kernel: 2.6.22

possible recursive locking near reiserfs_xattr_set
http://bugzilla.kernel.org/show_bug.cgi?id=9136
Kernel: 2.6.23-rc8-mm2
Asus A7V133-C desktop AMD Athlon XP 1600+

Assertion failure in journal_stop() (ext3)
http://bugzilla.kernel.org/show_bug.cgi?id=9109
Kernel: 2.6.23-rc3
...
Oct  1 17:19:09 wiga kernel: kernel BUG at fs/jbd/transaction.c:1335!
Oct  1 17:19:09 wiga kernel: invalid opcode: 0000 [#1]
...
Oct  1 17:19:09 wiga kernel: EIP is at journal_stop+0x91/0x1b8
...

recent reiserfs bugs
http://bugzilla.kernel.org/show_bug.cgi?id=9108
Kernel: 2.6.23-rc8-git2
(opened by Randy Dunlap)


MEMORY MANAGEMENT==================================================================

Dysfunctional applications consume all the system memory, system freezes.
http://bugzilla.kernel.org/show_bug.cgi?id=9202
Kernel: 2.6.22+


ACPI======================================================================

ACPI several problems on ACER 5050-4697
http://bugzilla.kernel.org/show_bug.cgi?id=9175
Kernel: 2.6.22
ACER aspire 5050-4872 (AMD64 laptop)

kernel acpi reads wrong temperature - critical shutdown
http://bugzilla.kernel.org/show_bug.cgi?id=9041
Kernel: 2.6.18+
(Reporter asked to test with recent kernel)

NETWORKING===============================================================

(net forcedeth) frequent network ups and downs
http://bugzilla.kernel.org/show_bug.cgi?id=9200
Kernel: 2.6.23
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)

rtl8187 very unreliable (wireless)
http://bugzilla.kernel.org/show_bug.cgi?id=9143
Kernel: 2.6.23
John Linville started looking in it

Unable to associate rt25xx USB key with a WPA AP (wireless)
http://bugzilla.kernel.org/show_bug.cgi?id=9388
Kernel: 2.6.24-rc2
D-Link DWL-G122 Wifi 11b/g USB key

USB===========================================================================

usb 1-2: clear tt 2 (90b1) error -32
http://bugzilla.kernel.org/show_bug.cgi?id=9199
Kernel: 2.6.23
usblp0: USB Bidirectional printer dev 11 if 0 alt 1 proto 2 vid 0x03F0
pid 0x0417
David Brownell started looking in it

BUG on USB disconnect
http://bugzilla.kernel.org/show_bug.cgi?id=9196
Kernel: 2.6.23
IBM TP42p. Connected (through dock) are USB mouse and Plantronics 400 headset

usb_id: segfault and abnormal exit msgs upon boot
http://bugzilla.kernel.org/show_bug.cgi?id=9176
Kernel: 2.6.23
Athlon XP 2.4+, VT82C686 UHCI USB 1.1 Controller

Entire system freezes randomly with USB modem in full swing
http://bugzilla.kernel.org/show_bug.cgi?id=9154
Kernel: 2.6.23
HUAWEI E220 USB modem

sysfs latency_timer for FT232RL chip
http://bugzilla.kernel.org/show_bug.cgi?id=9120
Kernel: 2.6.22.9
FTDI FT232RL based dongle for serial communication

VT6212L fails with Empia EM2820 on MIPS
http://bugzilla.kernel.org/show_bug.cgi?id=9114
Kernel: 2.6.22
Asus WL-500g Premium Broadcom BCM3302 V0.6 32MB RAM
USB host: VIA VT6212L
Video grabber: Empia EM2820 with SAA7113H

PROBLEM: kernel hang in ohci init (pci-quirks)
http://bugzilla.kernel.org/show_bug.cgi?id=9026
Kernel: 2.6.22
Regression
nvidia MCP51-Chipset
(David Brownell started looking at it)

Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
connection handle 92" message
http://bugzilla.kernel.org/show_bug.cgi?id=9027
Kernel: 2.6.22
usb bluetooth dongle

usb/serial/pl2303: support for BenQ Siemens Mobile Phone S81
http://bugzilla.kernel.org/show_bug.cgi?id=9065
Kernel: 2.6.22


I/O STORAGE==================================================================

[pata_via probe]: CD-Rom devices are being recognized as DISKs when
using pata driver
http://bugzilla.kernel.org/show_bug.cgi?id=9178
Kernel: 2.6.23
chipset VIA VT8633 [Apollo Pro266]
IDE: VIA VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06

__bread and 2TiB problem
http://bugzilla.kernel.org/show_bug.cgi?id=9171
Kernel: 2.6.22

floppy device fails; floppy unexpected interrupt' and 'floppy timeout called'
http://bugzilla.kernel.org/show_bug.cgi?id=9119
Kernel: 2.6.22.9
Regression
(Ingo is looking at it?)

Strange file locking problems
http://bugzilla.kernel.org/show_bug.cgi?id=9017
Kernel: 2.6.22.6
kernel: smbfs: Unrecognized mount option noexec


DRIVERS/FLASH================================================================

Device nodes not created by tifm module so can't mount detected devices
http://bugzilla.kernel.org/show_bug.cgi?id=9024
Kernel: 2.6.23-rc6
Sony Vaio VGN-FZ19N


MEMSETOOBSEL mtd ioctl not implemented in the kernel
http://bugzilla.kernel.org/show_bug.cgi?id=9042
Kernel: 2.6.latest
commit ff268fb8791cf18df536113355d7184007c269d9 removed the
MEMSETOOBSEL ioctl() but the MTD tools (nandwrite) still use it

HID/Input=======================================================================

hid-input.c lacks key codes for microsoft presenter mouse 8000 in
presentation mode
http://bugzilla.kernel.org/show_bug.cgi?id=9107
Kernel: 2.6.20
microsoft wireless notebook presenter mouse 8000
(reporter submitted a patch to make it work)

SCSI============================================================================

Kernel oops when I insert pcmcia future domain scsi card
http://bugzilla.kernel.org/show_bug.cgi?id=9105
Kernel: 2.6.23-rc5
IBM Thinkpad T21

DVB=============================================================================

DVB-T: pluto2 overflow irq every 30 seconds
http://bugzilla.kernel.org/show_bug.cgi?id=9162
Kernel: 2.6.23

ioremap() failure should be handled
http://bugzilla.kernel.org/show_bug.cgi?id=9146
Kernel: 2.6.23
many cx88 devices present in a system

v4l Problem with dvb-usb and Hauppage USB Stick
http://bugzilla.kernel.org/show_bug.cgi?id=9001
Kernel: 2.6.23-rc5
dvb-usb: Hauppauge Nova-T Stick crashes during channel search with
Kaffeine 0.8.5


POWER MANAGEMENT==============================================================

/proc/cpuinfo reports incorrect information for Via C3
http://bugzilla.kernel.org/show_bug.cgi?id=9066
kernel: 2.6.20
Via C3 processor
Believed to work with 2.4.2X by the reporter

Something broke cpufreq on laptop with lid behavior
http://bugzilla.kernel.org/show_bug.cgi?id=9151
Kernel: 2.6.23
Dell Inspiron 600m laptop with a 2GHz Pentium-M

network does not work after resume from suspend-to-disk
http://bugzilla.kernel.org/show_bug.cgi?id=9144
Kernel: 2.6.23
MSI 875P Neo (Intel Corporation 82547EI Gigabit Ethernet Controller)


VIDEO==========================================================================

Cannot unload agpgart module
http://bugzilla.kernel.org/show_bug.cgi?id=9032
Kernel: 2.6.22.6
ASUS L3C/S laptop, P4, Radeon 7500M

PLATFORM======================================================================

s3c2440_clk_add disables inactive clocks _ARM_
http://bugzilla.kernel.org/show_bug.cgi?id=9040
Kernel: 2.6.22
ARM, assigned to Ben Dooks (question is if he knows this :)

PowerMacG5 is shutting down at high cpu usage _PPC-64_
http://bugzilla.kernel.org/show_bug.cgi?id=9055
Kernel: latest
Apple PowerMac G5 (Dual Core)

SOUND/ALSA=====================================================================

hp_only quirk needed for lifebook p7010
http://bugzilla.kernel.org/show_bug.cgi?id=9100
Kernel: 2.6.22.X
on lifebook p7010 I need to add options snd-intel8x0 ac97_quirk=hp_only
to have the master volume work properly

snd-au8830 has strange I/O problems
http://bugzilla.kernel.org/show_bug.cgi?id=9367
Kernel:2.6.22
jack only works in 'playback' mode, none 'duplex' or 'capture' works.


snd_hda_intel doesn't mute front speakers when headset is plugged in
http://bugzilla.kernel.org/show_bug.cgi?id=9338
Kernel: 2.6.23+
Vaio VGN-FZ19VN

PCMCIA=============================================================================

Kernel oops when I insert pcmcia future domain scsi card
http://bugzilla.kernel.org/show_bug.cgi?id=9105
Kernel: 2.6.23-rc5
IBM Thinkpad T21
