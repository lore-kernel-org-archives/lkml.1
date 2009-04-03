Return-Path: <linux-kernel-owner+w=401wt.eu-S1765706AbZDCNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765706AbZDCNvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762593AbZDCNu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:50:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40895 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761515AbZDCNuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:50:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] LANANA: Change of management and resync
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Apr 2009 14:50:52 +0100
Message-ID: <20090403135051.19177.23019.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring the devices.txt back into some relationship with reality. Update the
documentation a bit.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 Documentation/devices.txt |  121 ++++++++++++++++++++++-----------------------
 1 files changed, 58 insertions(+), 63 deletions(-)


diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 62254d4..85a6a6d 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1,7 +1,7 @@
 
 		    LINUX ALLOCATED DEVICES (2.6+ version)
 
-	     Maintained by Torben Mathiasen <device@lanana.org>
+	     Maintained by Alan Cox <device@lanana.org>
 
 		      Last revised: 29 November 2006
 
@@ -67,6 +67,11 @@ up to date.  Due to the number of registrations I have to maintain it
 in "batch mode", so there is likely additional registrations that
 haven't been listed yet.
 
+Fourth, remember that Linux now has extensive support for dynamic allocation
+of device numbering and can use sysfs and udev to handle the naming needs.
+There are still some exceptions in the serial and boot device area. Before
+asking for a device number make sure you actually need one.
+
 Finally, sometimes I have to play "namespace police."  Please don't be
 offended.  I often get submissions for /dev names that would be bound
 to cause conflicts down the road.  I am trying to avoid getting in a
@@ -101,7 +106,7 @@ Your cooperation is appreciated.
 		  0 = /dev/ram0		First RAM disk
 		  1 = /dev/ram1		Second RAM disk
 		    ...
-		250 = /dev/initrd	Initial RAM disk {2.6}
+		250 = /dev/initrd	Initial RAM disk
 
 		Older kernels had /dev/ramdisk (1, 1) here.
 		/dev/initrd refers to a RAM disk which was preloaded
@@ -340,7 +345,7 @@ Your cooperation is appreciated.
 		 14 = /dev/touchscreen/ucb1x00  UCB 1x00 touchscreen
 		 15 = /dev/touchscreen/mk712	MK712 touchscreen
 		128 = /dev/beep		Fancy beep device
-		129 = /dev/modreq	Kernel module load request {2.6}
+		129 = 
 		130 = /dev/watchdog	Watchdog timer port
 		131 = /dev/temperature	Machine internal temperature
 		132 = /dev/hwtrap	Hardware fault trap
@@ -350,10 +355,10 @@ Your cooperation is appreciated.
 		139 = /dev/openprom	SPARC OpenBoot PROM
 		140 = /dev/relay8	Berkshire Products Octal relay card
 		141 = /dev/relay16	Berkshire Products ISO-16 relay card
-		142 = /dev/msr		x86 model-specific registers {2.6}
+		142 =
 		143 = /dev/pciconf	PCI configuration space
 		144 = /dev/nvram	Non-volatile configuration RAM
-		145 = /dev/hfmodem	Soundcard shortwave modem control {2.6}
+		145 = /dev/hfmodem	Soundcard shortwave modem control
 		146 = /dev/graphics	Linux/SGI graphics device
 		147 = /dev/opengl	Linux/SGI OpenGL pipe
 		148 = /dev/gfx		Linux/SGI graphics effects device
@@ -435,6 +440,9 @@ Your cooperation is appreciated.
 		228 = /dev/hpet		HPET driver
 		229 = /dev/fuse		Fuse (virtual filesystem in user-space)
 		230 = /dev/midishare	MidiShare driver
+		231 = /dev/snapshot	System memory snapshot device
+		232 = /dev/kvm		Kernel-based virtual machine (hardware virtualization extensions)
+		233 = /dev/kmview	View-OS A process with a view
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
@@ -466,10 +474,7 @@ Your cooperation is appreciated.
 		The device names specified are proposed -- if there
 		are "standard" names for these devices, please let me know.
 
- 12 block	MSCDEX CD-ROM callback support {2.6}
-		  0 = /dev/dos_cd0	First MSCDEX CD-ROM
-		  1 = /dev/dos_cd1	Second MSCDEX CD-ROM
-		    ...
+ 12 block
 
  13 char	Input core
 		  0 = /dev/input/js0	First joystick
@@ -498,7 +503,7 @@ Your cooperation is appreciated.
 		  2 = /dev/midi00	First MIDI port
 		  3 = /dev/dsp		Digital audio
 		  4 = /dev/audio	Sun-compatible digital audio
-		  6 = /dev/sndstat	Sound card status information {2.6}
+		  6 = 
 		  7 = /dev/audioctl	SPARC audio control device
 		  8 = /dev/sequencer2	Sequencer -- alternate device
 		 16 = /dev/mixer1	Second soundcard mixer control
@@ -510,14 +515,7 @@ Your cooperation is appreciated.
 		 34 = /dev/midi02	Third MIDI port
 		 50 = /dev/midi03	Fourth MIDI port
 
- 14 block	BIOS harddrive callback support {2.6}
-		  0 = /dev/dos_hda	First BIOS harddrive whole disk
-		 64 = /dev/dos_hdb	Second BIOS harddrive whole disk
-		128 = /dev/dos_hdc	Third BIOS harddrive whole disk
-		192 = /dev/dos_hdd	Fourth BIOS harddrive whole disk
-
-		Partitions are handled in the same way as IDE disks
-		(see major number 3).
+ 14 block
 
  15 char	Joystick
 		  0 = /dev/js0		First analog joystick
@@ -535,14 +533,14 @@ Your cooperation is appreciated.
  16 block	GoldStar CD-ROM
 		  0 = /dev/gscd		GoldStar CD-ROM
 
- 17 char	Chase serial card
+ 17 char	OBSOLETE (was Chase serial card)
 		  0 = /dev/ttyH0	First Chase port
 		  1 = /dev/ttyH1	Second Chase port
 		    ...
  17 block	Optics Storage CD-ROM
 		  0 = /dev/optcd	Optics Storage CD-ROM
 
- 18 char	Chase serial card - alternate devices
+ 18 char	OBSOLETE (was Chase serial card - alternate devices)
 		  0 = /dev/cuh0		Callout device for ttyH0
 		  1 = /dev/cuh1		Callout device for ttyH1
 		    ...
@@ -644,8 +642,7 @@ Your cooperation is appreciated.
 		  2 = /dev/sbpcd2	Panasonic CD-ROM controller 0 unit 2
 		  3 = /dev/sbpcd3	Panasonic CD-ROM controller 0 unit 3
 
- 26 char	Quanta WinVision frame grabber {2.6}
-		  0 = /dev/wvisfgrab	Quanta WinVision frame grabber
+ 26 char
 
  26 block	Second Matsushita (Panasonic/SoundBlaster) CD-ROM
 		  0 = /dev/sbpcd4	Panasonic CD-ROM controller 1 unit 0
@@ -872,7 +869,7 @@ Your cooperation is appreciated.
 		and "user level packet I/O."  This board is also
 		accessible as a standard networking "eth" device.
 
- 38 block	Reserved for Linux/AP+
+ 38 block	OBSOLETE (was Linux/AP+)
 
  39 char	ML-16P experimental I/O board
 		  0 = /dev/ml16pa-a0	First card, first analog channel
@@ -892,29 +889,16 @@ Your cooperation is appreciated.
 		 50 = /dev/ml16pb-c1	Second card, second counter/timer
 		 51 = /dev/ml16pb-c2	Second card, third counter/timer
 		      ...
- 39 block	Reserved for Linux/AP+
+ 39 block
 
- 40 char	Matrox Meteor frame grabber {2.6}
-		  0 = /dev/mmetfgrab	Matrox Meteor frame grabber
+ 40 char
 
- 40 block	Syquest EZ135 parallel port removable drive
-		  0 = /dev/eza		Parallel EZ135 drive, whole disk
-
-		This device is obsolete and will be removed in a
-		future version of Linux.  It has been replaced with
-		the parallel port IDE disk driver at major number 45.
-		Partitions are handled in the same way as IDE disks
-		(see major number 3).
+ 40 block
 
  41 char	Yet Another Micro Monitor
 		  0 = /dev/yamm		Yet Another Micro Monitor
 
- 41 block	MicroSolutions BackPack parallel port CD-ROM
-		  0 = /dev/bpcd		BackPack CD-ROM
-
-		This device is obsolete and will be removed in a
-		future version of Linux.  It has been replaced with
-		the parallel port ATAPI CD-ROM driver at major number 46.
+ 41 block
 
  42 char	Demo/sample use
 
@@ -1681,13 +1665,7 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
- 93 char	IBM Smart Capture Card frame grabber {2.6}
-		  0 = /dev/iscc0	First Smart Capture Card
-		  1 = /dev/iscc1	Second Smart Capture Card
-		    ...
-		128 = /dev/isccctl0	First Smart Capture Card control
-		129 = /dev/isccctl1	Second Smart Capture Card control
-		    ...
+ 93 char
 
  93 block	NAND Flash Translation Layer filesystem
 		  0 = /dev/nftla	First NFTL layer
@@ -1695,10 +1673,7 @@ Your cooperation is appreciated.
 		    ...
 		240 = /dev/nftlp	16th NTFL layer
 
- 94 char	miroVIDEO DC10/30 capture/playback device {2.6}
-		  0 = /dev/dcxx0	First capture card
-		  1 = /dev/dcxx1	Second capture card
-		    ...
+ 94 char
 
  94 block	IBM S/390 DASD block storage
     		  0 = /dev/dasda First DASD device, major
@@ -1791,11 +1766,7 @@ Your cooperation is appreciated.
 		    ...
 		 15 = /dev/amiraid/ar?p15 15th partition
 
-102 char	Philips SAA5249 Teletext signal decoder {2.6}
-		  0 = /dev/tlk0		First Teletext decoder
-		  1 = /dev/tlk1		Second Teletext decoder
-		  2 = /dev/tlk2		Third Teletext decoder
-		  3 = /dev/tlk3		Fourth Teletext decoder
+102 char
 
 102 block	Compressed block device
 		  0 = /dev/cbd/a	First compressed block device, whole device
@@ -1916,10 +1887,7 @@ Your cooperation is appreciated.
 		DAC960 (see major number 48) except that the limit on
 		partitions is 15.
 
-111 char	Philips SAA7146-based audio/video card {2.6}
-		  0 = /dev/av0		First A/V card
-		  1 = /dev/av1		Second A/V card
-		    ...
+111 char
 
 111 block	Compaq Next Generation Drive Array, eighth controller
 		  0 = /dev/cciss/c7d0	First logical drive, whole disk
@@ -2079,8 +2047,8 @@ Your cooperation is appreciated.
 		    ...
 
 119 char	VMware virtual network control
-		  0 = /dev/vmnet0	1st virtual network
-		  1 = /dev/vmnet1	2nd virtual network
+		  0 = /dev/vnet0	1st virtual network
+		  1 = /dev/vnet1	2nd virtual network
 		    ...
 
 120-127 char	LOCAL/EXPERIMENTAL USE
@@ -2450,7 +2418,7 @@ Your cooperation is appreciated.
 		  2 = /dev/raw/raw2	Second raw I/O device
 		    ...
 
-163 char	UNASSIGNED (was Radio Tech BIM-XXX-RS232 radio modem - see 51)
+163 char
 
 164 char	Chase Research AT/PCI-Fast serial card
 		  0 = /dev/ttyCH0	AT/PCI-Fast board 0, port 0
@@ -2542,6 +2510,12 @@ Your cooperation is appreciated.
 		  1 = /dev/clanvi1	Second cLAN adapter
 		    ...
 
+179 block       MMC block devices
+		  0 = /dev/mmcblk0      First SD/MMC card
+		  1 = /dev/mmcblk0p1    First partition on first MMC card
+		  8 = /dev/mmcblk1      Second SD/MMC card
+		    ...
+
 179 char	CCube DVXChip-based PCI products
 		  0 = /dev/dvxirq0	First DVX device
 		  1 = /dev/dvxirq1	Second DVX device
@@ -2560,6 +2534,9 @@ Your cooperation is appreciated.
 		 96 = /dev/usb/hiddev0	1st USB HID device
 		    ...
 		111 = /dev/usb/hiddev15	16th USB HID device
+		112 = /dev/usb/auer0	1st auerswald ISDN device
+		    ...
+		127 = /dev/usb/auer15	16th auerswald ISDN device
 		128 = /dev/usb/brlvgr0	First Braille Voyager device
 		    ...
 		131 = /dev/usb/brlvgr3	Fourth Braille Voyager device
@@ -2810,6 +2787,16 @@ Your cooperation is appreciated.
 		    ...
 		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
 		 191 = /dev/xvc0		Xen virtual console - port 0
+		 192 = /dev/ttyPZ0		pmac_zilog - port 0
+		    ...
+		 195 = /dev/ttyPZ3		pmac_zilog - port 3
+		 196 = /dev/ttyTX0		TX39/49 serial port 0
+		    ...
+		 204 = /dev/ttyTX7		TX39/49 serial port 7
+		 205 = /dev/ttySC0		SC26xx serial port 0
+		 206 = /dev/ttySC1		SC26xx serial port 1
+		 207 = /dev/ttySC2		SC26xx serial port 2
+		 208 = /dev/ttySC3		SC26xx serial port 3
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
@@ -3145,6 +3132,14 @@ Your cooperation is appreciated.
 		  1 = /dev/blockrom1	Second ROM card's translation layer interface
 		  ...
 
+259 block	Block Extended Major
+		  Used dynamically to hold additional partition minor
+		  numbers and allow large numbers of partitions per device
+
+259 char	FPGA configuration interfaces
+		  0 = /dev/icap0	First Xilinx internal configuration
+		  1 = /dev/icap1	Second Xilinx internal configuration
+
 260 char	OSD (Object-based-device) SCSI Device
 		  0 = /dev/osd0		First OSD Device
 		  1 = /dev/osd1		Second OSD Device

