Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZAMU3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZAMU3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZAMU1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:50 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2529 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbZAMU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:45 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] MAINTAINERS - Standardize style
Date: Tue, 13 Jan 2009 12:28:11 -0800
Message-Id: <1231878498-25171-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one email address per line
Remove file patterns from section names
Use tab after :

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |  112 ++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b41894c..87ce75b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -375,7 +375,7 @@ F:	include/linux/agp*
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aha152x*
@@ -457,10 +457,10 @@ F:	arch/x86/kernel/amd_iommu*.c
 F:	arch/x86/include/asm/amd_iommu*.h
 
 AMD MICROCODE UPDATE SUPPORT
-P:      Andreas Herrmann
-M:      andeas.herrmann3@amd.com
-L:      amd64-microcode@amd64.org
-S:      Supported
+P:	Andreas Herrmann
+M:	andeas.herrmann3@amd.com
+L:	amd64-microcode@amd64.org
+S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
@@ -727,10 +727,10 @@ W:	http://hackndev.com
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
@@ -1487,8 +1487,10 @@ S:	Maintained
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
 L:	linux-media@vger.kernel.org
@@ -1731,13 +1733,14 @@ L:	linux-acpi@vger.kernel.org
 S:	Supported
 F:	drivers/acpi/dock.c
 
-DOCUMENTATION (/Documentation directory)
+DOCUMENTATION
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 L:	linux-doc@vger.kernel.org
 S:	Maintained
+F:	Documentation/
 
 DOUBLETALK DRIVER
 P:	James R. Van Zandt
@@ -1803,7 +1806,9 @@ F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+M:	mike@i-Connect.Net
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata*
 
@@ -1817,7 +1822,8 @@ F:	drivers/scsi/eata.c
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata_pio.*
 
@@ -1832,8 +1838,10 @@ F:	include/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
-P:	Tyler Hicks, Dustin Kirkland
-M:	tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
+P:	Tyler Hicks
+M:	tyhicks@linux.vnet.ibm.com
+M:	Dustin Kirkland
+P:	kirkland@canonical.com
 L:	ecryptfs-devel@lists.launchpad.net
 W:	https://launchpad.net/ecryptfs
 S:	Supported
@@ -1957,7 +1965,9 @@ F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
-M:	ch@murgatroid.com, ch@hpl.hp.com
+M:	ch@murgatroid.com
+P:	Christopher Hoover
+M:	ch@hpl.hp.com
 S:	Maintained
 F:	drivers/video/epson1355fb.c
 
@@ -1997,8 +2007,12 @@ F:	fs/ext2/
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
@@ -2006,7 +2020,9 @@ F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 P:	Theodore Ts'o
-M:	tytso@mit.edu, adilger@sun.com
+M:	tytso@mit.edu
+P:	Andreas Dilger
+M:	adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 S:	Maintained
@@ -2051,9 +2067,11 @@ L:	linux-fsdevel@vger.kernel.org
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
@@ -2467,7 +2485,7 @@ M:	perex@perex.cz
 S:	Maintained
 F:	drivers/net/hp100.*
 
-HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
+HPET:	High Precision Event Timers driver
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
@@ -2487,7 +2505,7 @@ P:	Vojtech Pavlik
 M:	vojtech@suse.cz
 S:	Maintained
 
-HPET:	ACPI hpet.c
+HPET:	ACPI
 P:	Bob Picco
 M:	bob.picco@hp.com
 S:	Maintained
@@ -2500,7 +2518,7 @@ W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
 F:	fs/hpfs/
 
-HSO	3G Modem Driver (hso.c)
+HSO 3G MODEM DRIVER
 P:	Denis Joseph Barrow
 M:	d.barow@option.com
 W:	http://www.pharscape.org
@@ -2612,7 +2630,7 @@ F:	drivers/ide/ide-cd*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	paul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
@@ -2620,7 +2638,7 @@ F:	drivers/ide/ide-floppy*
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/ide/ide-tape.c
@@ -2632,7 +2650,7 @@ L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
-IEEE 1394 SUBSYSTEM (drivers/ieee1394)
+IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter
@@ -2643,7 +2661,7 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
-IEEE 1394 RAW I/O DRIVER (raw1394)
+IEEE 1394 RAW I/O DRIVER
 P:	Dan Dennedy
 M:	dan@dennedy.org
 P:	Stefan Richter
@@ -3020,8 +3038,10 @@ F:	include/linux/jffs2.h
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
@@ -3069,7 +3089,7 @@ L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
-KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
+KERNEL BUILD
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
@@ -4521,16 +4541,16 @@ S:	Maintained
 F:	drivers/net/wireless/rtl818*
 
 RTL8187 WIRELESS DRIVER
-P:	 Herton Ronaldo Krzesinski
-M:      herton@mandriva.com.br
-P:      Hin-Tak Leung
-M       htl10@users.sourceforge.net
-P:      Larry Finger
-M:      Larry.Finger@lwfinger.net
-L:      linux-wireless@vger.kernel.org
-W:      http://linuxwireless.org/
-T:      git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
-S:      Maintained
+P:	Herton Ronaldo Krzesinski
+M:	herton@mandriva.com.br
+P:	Hin-Tak Leung
+M:	htl10@users.sourceforge.net
+P:	Larry Finger
+M:	Larry.Finger@lwfinger.net
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
@@ -4708,13 +4728,13 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci.*
 
 SECURITY SUBSYSTEM
-F:	security/
 P:	James Morris
 M:	jmorris@namei.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
+F:	security/
 
 SECURITY CONTACT
 P:	Security Officers
@@ -4729,7 +4749,7 @@ M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
@@ -5015,7 +5035,7 @@ F:	arch/sparc/
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
-L:	linux-kernel@vger.kernel.org ?
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/serial/specialix.txt
 F:	drivers/char/specialix*
-- 
1.6.0.2

