Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYJTWaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYJTWaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYJTW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:28:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3720 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYJTW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:28:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 3/3] MAINTAINERS updates
Date: Mon, 20 Oct 2008 15:28:24 -0700
Message-Id: <1224541704-30357-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224541704-30357-3-git-send-email-joe@perches.com>
References: <1224541704-30357-1-git-send-email-joe@perches.com>
 <1224541704-30357-2-git-send-email-joe@perches.com>
 <1224541704-30357-3-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Conform to one email address per line style
 Remove duplicated FUSE section
 Remove unsupported Cirrus Logic CS4280 driver
 Remove file patterns from section names
 Added more directory file patterns to intel net drivers section


Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f39b470..694d73c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -354,41 +354,41 @@ F:	fs/affs/
 
 AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
 P:	David Howells
 M:	dhowells@redhat.com
 L:	linux-afs@lists.infradead.org
 S:	Supported
 F:	fs/afs/
 F:	include/net/af_rxrpc.h
 F:	net/rxrpc/af_rxrpc.c
 
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aha152x*
 F:	drivers/scsi/pcmcia/aha152x*
 
 AIC7XXX / AIC79XX SCSI DRIVER
 P:	Hannes Reinecke
 M:	hare@suse.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
 F:	drivers/scsi/aic7xxx_old/
 
 AIO
 P:	Benjamin LaHaise
 M:	bcrl@kvack.org
 L:	linux-aio@kvack.org
 S:	Supported
 F:	fs/aio.c
 F:	include/linux/*aio*.h
@@ -435,43 +435,43 @@ F:	drivers/usb/gadget/amd5536udc.*
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 F:	arch/x86/kernel/geode_32.c
 F:	drivers/char/hw_random/geode-rng.c
 F:	drivers/crypto/geode*
 F:	drivers/video/geode/
 F:	include/asm-x86/geode.h
 
 AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 F:	arch/x86/kernel/amd_iommu.c
 
 AMD MICROCODE UPDATE SUPPORT
-P:      Peter Oruba
-M:      peter.oruba@amd.com
-S:      Supported
+P:	Peter Oruba
+M:	peter.oruba@amd.com
+S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
 P:	Michael Hanselmann
 M:	linux-kernel@hansmi.ch
 S:	Supported
 F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
 P:	Tom Tucker
 M:	tom@opengridcomputing.com
 P:	Steve Wise
 M:	swise@opengridcomputing.com
 L:	general@lists.openfabrics.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
 AOA (Apple Onboard Audio) ALSA DRIVER
@@ -699,44 +699,44 @@ S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
 P:	Philipp Zabel
 M:	philipp.zabel@gmail.com
 S:	Maintained
 
 ARM/TOSA MACHINE SUPPORT
 P:	Dmitry Baryshkov
 M:	dbaryshkov@gmail.com
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
 S:	Maintained
 
 ARM/PALMTX SUPPORT
 P:	Marek Vasut
 M:	marek.vasut@gmail.com
 W:	http://hackndev.com
 S:	Maintained
 
 ARM/PALMZ72 SUPPORT
-P:     Sergey Lapin
-M:     slapin@ossfans.org
-W:     http://hackndev.com
-S:     Maintained
+P:	Sergey Lapin
+M:	slapin@ossfans.org
+W:	http://hackndev.com
+S:	Maintained
 
 ARM/PLEB SUPPORT
 P:	Peter Chubb
 M:	pleb@gelato.unsw.edu.au
 W:	http://www.disy.cse.unsw.edu.au/Hardware/PLEB
 S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
 P:	Stefan Eletzhofer
 M:	stefan.eletzhofer@eletztrick.de
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
@@ -1270,49 +1270,40 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
-
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
 M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
 F:	fs/coda/
 F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	fs/cifs/
 
@@ -1438,42 +1429,44 @@ S:	Maintained
 F:	arch/cris/
 F:	include/asm-cris/
 
 CRYPTO API
 P:	Herbert Xu
 M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
 CX18 VIDEO4LINUX DRIVER
-P:	Hans Verkuil, Andy Walls
-M:	hverkuil@xs4all.nl, awalls@radix.net
+P:	Hans Verkuil
+M:	hverkuil@xs4all.nl
+P:	Andy Walls
+M:	awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/video/cx18/
 
 CXGB3 ETHERNET DRIVER (CXGB3)
 P:	Divy Le Ray
 M:	divy@chelsio.com
 L:	netdev@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/cxgb3/
 
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 P:	Steve Wise
 M:	swise@chelsio.com
 L:	general@lists.openfabrics.org
@@ -1741,70 +1734,75 @@ F:	drivers/net/wan/dscc4.c
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	drivers/media/dvb/
 F:	drivers/media/common/saa7146*.c
 F:	include/linux/dvb/
 
 DZ DECSTATION DZ11 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+M:	mike@i-Connect.Net
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
 P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata_pio.*
 
 EBTABLES
 P:	Bart De Schuymer
 M:	bart.de.schuymer@pandora.be
 L:	ebtables-user@lists.sourceforge.net
 L:	ebtables-devel@lists.sourceforge.net
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
 F:	include/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
-P:	Mike Halcrow, Phillip Hellewell
-M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
+P:	Mike Halcrow
+M:	mhalcrow@us.ibm.com
+P:	Phillip Hellewell
+M:	phillip@hellewell.homeip.net
 L:	ecryptfs-devel@lists.sourceforge.net
 W:	http://ecryptfs.sourceforge.net/
 S:	Supported
 F:	fs/ecryptfs/
 
 EDAC-CORE
 P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
 F:	Documentation/edac.txt
 F:	drivers/edac/edac_*
 F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
 P:	Doug Thompson
 M:	mark.gross@intel.com
 M:	dougthompson@xmission.com
@@ -1900,90 +1898,98 @@ S:	Supported
 F:	drivers/infiniband/hw/ehca/
 
 EMBEDDED LINUX
 P:	Paul Gortmaker
 M:	paul.gortmaker@windriver.com
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart
 M:	james.smart@emulex.com
 L:	linux-scsi@vger.kernel.org
 W:	http://sourceforge.net/projects/lpfcxxxx
 S:	Supported
 F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
-M:	ch@murgatroid.com, ch@hpl.hp.com
+M:	ch@murgatroid.com
+P:	Christopher Hoover
+M:	ch@hpl.hp.com
 S:	Maintained
 F:	drivers/video/epson1355fb.c
 
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 P:	Kristoffer Ericson
 M:	kristoffer.ericson@gmail.com
 S:	Maintained
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 
 ETHEREXPRESS-16 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	bridge@lists.linux-foundation.org
 W:	http://www.linux-foundation.org/en/Net:Bridge
 S:	Maintained
 F:	include/linux/netfilter_bridge/
 F:	net/bridge/
 
 ETHERTEAM 16I DRIVER
 P:	Mika Kuoppala
 M:	miku@iki.fi
 S:	Maintained
 F:	drivers/net/eth16i.c
 
 EXT2 FILE SYSTEM
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
+P:	Andreas Dilger
+M:	adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/ext3/
 F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 P:	Theodore Ts'o
-M:	tytso@mit.edu, adilger@sun.com
+M:	tytso@mit.edu
+P:	Andreas Dilger
+M:	adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 S:	Maintained
 F:	fs/ext4/
 
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/f71805f
 F:	drivers/hwmon/f71805f.c
 
 FARSYNC SYNCHRONOUS DRIVER
 P:	Kevin Curtis
 M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
 F:	drivers/net/wan/farsync.*
 
@@ -1994,43 +2000,45 @@ S:	Supported
 F:	Documentation/fault-injection/
 F:	lib/fault-inject.c
 
 FILE LOCKING (flock() and fcntl()/lockf())
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
 F:	include/linux/fs.h
 F:	fs/fcntl.c
 F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/*
 
-FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
-P:	Kristian Hoegsberg, Stefan Richter
-M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+FIREWIRE SUBSYSTEM
+P:	Kristian Hoegsberg
+M:	krh@redhat.com
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h
 
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
 
 FPU EMULATOR
 P:	Bill Metzenthen
 M:	billm@suburbia.net
 W:	http://suburbia.net/~billm/floating-point/emulator/
 S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
 P:	Mike McLagan
@@ -2138,49 +2146,40 @@ P:	Jonathan Woithe
 M:	jwoithe@physics.adelaide.edu.au
 L:	linux-acpi@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/fujitsu-laptop.c
 
 FUSE: FILESYSTEM IN USERSPACE
 P:	Miklos Szeredi
 M:	miklos@szeredi.hu
 L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
 F:	fs/fuse/
 F:	include/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
 P:	Rik Faith
 M:	faith@cs.unc.edu
 L:	linux-scsi@vger.kernel.org
 S:	Odd Fixes (e.g., new signatures)
 
-FUSE: FILESYSTEM IN USERSPACE
-P:	Miklos Szeredi
-M:	miklos@szeredi.hu
-L:	fuse-devel@lists.sourceforge.net
-W:	http://fuse.sourceforge.net/
-S:	Maintained
-F:	fs/fuse/
-F:	include/linux/fuse.h
-
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 P:	Achim Leubner
 M:	achim_leubner@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
 GENERIC GPIO I2C DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
 F:	drivers/i2c/busses/i2c-gpio.c
 F:	include/linux/i2c-gpio.h
 
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
@@ -2488,70 +2487,70 @@ F:	drivers/scsi/ips.*
 IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
 M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
 F:	Documentation/ide/
 F:	drivers/ide/
 F:	include/linux/ide.h
 
 IDE/ATAPI CDROM DRIVER
 P:	Borislav Petkov
 M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/ide-cd
 F:	drivers/ide/ide-cd*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	paul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/ide/ide-floppy*
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/ide/ide-tape.c
 
 IDE-SCSI DRIVER
 L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
-IEEE 1394 SUBSYSTEM (drivers/ieee1394)
+IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
-IEEE 1394 RAW I/O DRIVER (raw1394)
+IEEE 1394 RAW I/O DRIVER
 P:	Dan Dennedy
 M:	dan@dennedy.org
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/ieee1394/raw1394*
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
 F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
 M:	rolandd@cisco.com
 P:	Sean Hefty
 M:	sean.hefty@intel.com
 P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com
@@ -2630,41 +2629,43 @@ M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ixp2000/
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
 P:	Jesse Brandeburg
 M:	jesse.brandeburg@intel.com
 P:	Bruce Allan
 M:	bruce.w.allan@intel.com
 P:	PJ Waskiewicz
 M:	peter.p.waskiewicz.jr@intel.com
 P:	John Ronciak
 M:	john.ronciak@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://e1000.sourceforge.net/
 S:	Supported
 F:	drivers/net/e100.c
 F:	drivers/net/e1000/
+F:	drivers/net/e1000e/
 F:	drivers/net/ixgb/
+F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 P:	Zhu Yi
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 P:	Reinette Chatre
 M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
 S:	Supported
 F:	Documentation/networking/README.ipw2100
 F:	drivers/net/wireless/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
 P:	Zhu Yi
 M:	yi.zhu@intel.com
 P:	James Ketrenos
@@ -2848,42 +2849,44 @@ F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 
 JME NETWORK DRIVER
 P:	Guo-Fu Tseng
 M:	cooldavid@cooldavid.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/jme.*
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
 F:	fs/jffs2/
 F:	include/linux/jffs2.h
 F:	include/mtd/jffs2-user.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd*/
 F:	include/linux/ext*jbd*.h
 F:	include/linux/jbd*.h
 
 K8TEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
@@ -2897,41 +2900,41 @@ M:	hbabu@us.ibm.com
 L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
 F:	Documentation/kdump
 
 KERNEL AUTOMOUNTER (AUTOFS)
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
 F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 P:	Ian Kent
 M:	raven@themaw.net
 L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
-KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
+KERNEL BUILD
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
 
 KERNEL JANITORS
 P:	Several
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
@@ -4489,41 +4492,41 @@ F:	drivers/mmc/host/sdricoh_cs.c
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
 P:	Pierre Ossman
 M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 S:	Maintained
 F:	drivers/mmc/host/sdhci.*
 
 SECURITY CONTACT
 P:	Security Officers
 M:	security@kernel.org
 S:	Supported
 
 SELINUX SECURITY MODULE
 P:	Stephen Smalley
 M:	sds@tycho.nsa.gov
 P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
 
 SENSABLE PHANTOM
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 F:	drivers/ata/
@@ -4756,41 +4759,41 @@ SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT
 P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 T:	git opensource.wolfsonmicro.com/linux-2.6-asoc
 L:	alsa-devel@alsa-project.org (subscribers-only)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 F:	sound/soc/
 
 SPARC (sparc32)
 P:	William L. Irwin
 M:	wli@holomorphy.com
 L:	sparclinux@vger.kernel.org
 S:	Maintained
 F:	arch/sparc/
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
-L:	linux-kernel@vger.kernel.org ?
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/char/specialix*
 
 SPI SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
 F:	include/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 P:	Ishizaki Kou
 M:	kou.ishizaki@toshiba.co.jp
 P:	Jens Osterkamp
 M:	jens@de.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/spider_net.txt
-- 
1.6.0.2

