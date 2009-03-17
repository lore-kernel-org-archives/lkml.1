Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZCQXXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZCQXXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCQXVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:21:03 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4392 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbZCQXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:21:00 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/8] MAINTAINERS - Standardize style
Date: Tue, 17 Mar 2009 16:19:24 -0700
Message-Id: <1237331969-28565-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237331969-28565-1-git-send-email-joe@perches.com>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one email address per line
Remove file patterns from section names
Use tab after :

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |  121 ++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 70 insertions(+), 51 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 673d66f..a8436c5 100644
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
@@ -1505,8 +1505,10 @@ S:	Maintained
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
@@ -1750,7 +1752,7 @@ L:	linux-acpi@vger.kernel.org
 S:	Supported
 F:	drivers/acpi/dock.c
 
-DOCUMENTATION (/Documentation directory)
+DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 L:	linux-doc@vger.kernel.org
@@ -1821,7 +1823,9 @@ F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+M:	mike@i-Connect.Net
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata*
 
@@ -1835,7 +1839,8 @@ F:	drivers/scsi/eata.c
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata_pio.*
 
@@ -1850,8 +1855,10 @@ F:	include/linux/netfilter_bridge/ebt_*.h
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
@@ -1983,7 +1990,9 @@ F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
-M:	ch@murgatroid.com, ch@hpl.hp.com
+M:	ch@murgatroid.com
+P:	Christopher Hoover
+M:	ch@hpl.hp.com
 S:	Maintained
 F:	drivers/video/epson1355fb.c
 
@@ -2023,8 +2032,12 @@ F:	fs/ext2/
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
@@ -2032,7 +2045,9 @@ F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 P:	Theodore Ts'o
-M:	tytso@mit.edu, adilger@sun.com
+M:	tytso@mit.edu
+P:	Andreas Dilger
+M:	adilger@sun.com
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 S:	Maintained
@@ -2077,9 +2092,11 @@ L:	linux-fsdevel@vger.kernel.org
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
@@ -2504,7 +2521,7 @@ M:	perex@perex.cz
 S:	Maintained
 F:	drivers/net/hp100.*
 
-HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
+HPET:	High Precision Event Timers driver
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
@@ -2524,7 +2541,7 @@ P:	Vojtech Pavlik
 M:	vojtech@suse.cz
 S:	Maintained
 
-HPET:	ACPI hpet.c
+HPET:	ACPI
 P:	Bob Picco
 M:	bob.picco@hp.com
 S:	Maintained
@@ -2537,7 +2554,7 @@ W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
 F:	fs/hpfs/
 
-HSO	3G Modem Driver (hso.c)
+HSO 3G MODEM DRIVER
 P:	Denis Joseph Barrow
 M:	d.barow@option.com
 W:	http://www.pharscape.org
@@ -2650,7 +2667,7 @@ F:	drivers/ide/ide-cd*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	paul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
@@ -2658,7 +2675,7 @@ F:	drivers/ide/ide-floppy*
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/ide/ide-tape.c
@@ -2670,7 +2687,7 @@ L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
-IEEE 1394 SUBSYSTEM (drivers/ieee1394)
+IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter
@@ -2681,7 +2698,7 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
-IEEE 1394 RAW I/O DRIVER (raw1394)
+IEEE 1394 RAW I/O DRIVER
 P:	Dan Dennedy
 M:	dan@dennedy.org
 P:	Stefan Richter
@@ -3059,8 +3076,10 @@ F:	include/linux/jffs2.h
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
@@ -3108,7 +3127,7 @@ L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
-KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
+KERNEL BUILD
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
@@ -4558,16 +4577,16 @@ S:	Maintained
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
@@ -4745,13 +4764,13 @@ S:	Maintained
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
@@ -4766,7 +4785,7 @@ M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
@@ -4790,11 +4809,11 @@ S:	Supported
 SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
 P:	Sathya Perla
 M:	sathyap@serverengines.com
-P:      Subbu Seetharaman
-M:      subbus@serverengines.com
-L:      netdev@vger.kernel.org
-W:      http://www.serverengines.com
-S:      Supported
+P:	Subbu Seetharaman
+M:	subbus@serverengines.com
+L:	netdev@vger.kernel.org
+W:	http://www.serverengines.com
+S:	Supported
 F:	drivers/net/benet/
 
 SFC NETWORK DRIVER
@@ -5063,7 +5082,7 @@ F:	arch/sparc/
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

