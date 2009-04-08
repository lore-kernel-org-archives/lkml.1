Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbZDHFXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbZDHFXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbZDHFUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:20:33 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4370 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbZDHFUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:20:31 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] MAINTAINERS - standardize "T:       git urls"
Date: Tue,  7 Apr 2009 22:17:47 -0700
Message-Id: <1239167872-8179-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239167872-8179-1-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various forms of "T:        git" entries exist:
git kernel.org:/
git kernel.org/
git://git.kernel.org/
Standardize on "T:  git git://git.kernel.org/<foo>" where appropriate
Fix a few bad git path entries

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |  196 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09d503f..abbb79a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -180,7 +180,7 @@ P:	Latchesar Ionkov
 M:	lucho@ionkov.net
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
-T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
 F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
@@ -235,7 +235,7 @@ P:	Len Brown
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
@@ -327,7 +327,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/adm8211.*
 
@@ -370,7 +370,7 @@ F:	net/rxrpc/af_rxrpc.c
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
@@ -454,7 +454,7 @@ AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 F:	arch/x86/kernel/amd_iommu*.c
 F:	arch/x86/include/asm/amd_iommu*.h
@@ -607,7 +607,7 @@ ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 P:	Paulius Zaleckas
 M:	paulius.zaleckas@teltonika.lt
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-T:	git gitorious.org/linux-gemini/mainline.git
+T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 
 ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
@@ -990,7 +990,7 @@ P:	Eric Paris
 M:	eparis@redhat.com
 L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
-T:	git git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
 S:	Maintained
 F:	include/linux/audit.h
 F:	kernel/audit*
@@ -1134,7 +1134,7 @@ BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
 
@@ -1158,7 +1158,7 @@ P:	Marcel Holtmann
 M:	marcel@holtmann.org
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
@@ -1223,7 +1223,7 @@ P:	Chris Mason
 M:	chris.mason@oracle.com
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
@@ -1233,7 +1233,7 @@ P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/video/bt8xx/bttv*
@@ -1242,7 +1242,7 @@ CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
 F:	drivers/media/video/cafe_ccic*
@@ -1390,7 +1390,7 @@ M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
 F:	fs/cifs/
@@ -1479,7 +1479,7 @@ P:	Dave Jones
 M:	davej@redhat.com
 L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
-T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
 F:	arch/x86/kernel/cpu/cpufreq/
 F:	drivers/cpufreq/
@@ -1525,7 +1525,7 @@ M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	Documentation/crypto/
 F:	arch/*/crypto/
@@ -1553,7 +1553,7 @@ M:	awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
@@ -1763,7 +1763,7 @@ P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 F:	fs/dlm/
 
@@ -1837,7 +1837,7 @@ DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
 
@@ -1852,7 +1852,7 @@ DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	drivers/media/dvb/
@@ -2153,7 +2153,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h
@@ -2358,8 +2358,8 @@ P:	Steven Whitehouse
 M:	swhiteho@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
 F:	Documentation/filesystems/gfs2*.txt
 F:	fs/gfs2/
@@ -2395,7 +2395,7 @@ GSPCA FINEPIX SUBDRIVER
 P:	Frank Zago
 M:	frank@zago.net
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/finepix.c
 
@@ -2403,7 +2403,7 @@ GSPCA M5602 SUBDRIVER
 P:	Erik Andren
 M:	erik.andren@gmail.com
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/m5602/
 
@@ -2411,7 +2411,7 @@ GSPCA PAC207 SONIXB SUBDRIVER
 P:	Hans de Goede
 M:	hdegoede@redhat.com
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/pac207.c
 
@@ -2419,7 +2419,7 @@ GSPCA T613 SUBDRIVER
 P:	Leandro Costantino
 M:	lcostantino@gmail.com
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/t613.c
 
@@ -2428,7 +2428,7 @@ P:	Jean-Francois Moine
 M:	moinejf@free.fr
 W:	http://moinejf.free.fr
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/
 
@@ -2513,7 +2513,7 @@ HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	drivers/hid/
 F:	include/linux/hid*
@@ -2667,7 +2667,7 @@ F:	arch/x86/boot/
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
@@ -2675,7 +2675,7 @@ P:	Tony Luck
 M:	tony.luck@intel.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 F:	arch/ia64/
 
@@ -2732,7 +2732,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
@@ -2765,7 +2765,7 @@ P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com
 L:	general@lists.openfabrics.org (moderated for non-subscribers)
 W:	http://www.openib.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
@@ -2787,7 +2787,7 @@ P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 
@@ -2832,7 +2832,7 @@ INTEL IOMMU (VT-d)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	iommu@lists.linux-foundation.org
-T:	git://git.infradead.org/iommu-2.6.git
+T:	git git://git.infradead.org/iommu-2.6.git
 S:	Supported
 F:	drivers/pci/intel-iommu.c
 F:	include/linux/intel-iommu.h
@@ -2938,7 +2938,7 @@ M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
@@ -3018,7 +3018,7 @@ M:	jkosina@suse.cz
 P:	David Sterba
 M:	dsterba@suse.cz
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
 F:	drivers/char/pcmcia/ipwireless/
 
 IPX NETWORK LAYER
@@ -3054,7 +3054,7 @@ P:	Mike Christie
 M:	michaelc@cs.wisc.edu
 L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
-T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
 S:	Maintained
 F:	drivers/scsi/*iscsi*
 F:	include/scsi/*iscsi*
@@ -3064,7 +3064,7 @@ P:	Karsten Keil
 M:	isdn@linux-pingi.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
-T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
 S:	Maintained
 F:	Documentation/isdn/
 F:	drivers/isdn/
@@ -3085,7 +3085,7 @@ M:	hverkuil@xs4all.nl
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
@@ -3097,7 +3097,7 @@ P:	Dave Kleikamp
 M:	shaggy@austin.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
@@ -3174,8 +3174,8 @@ F:	fs/autofs4/
 KERNEL BUILD
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/
@@ -3375,7 +3375,7 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/benh/powerpc.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
 
 LINUX FOR POWER MACINTOSH
@@ -3400,7 +3400,7 @@ P:	Matt Porter
 M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jwboyer/powerpc.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
@@ -3437,7 +3437,7 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LLC (802.2)
@@ -3477,7 +3477,7 @@ M:	peterz@infradead.org
 P:	Ingo Molnar
 M:	mingo@redhat.com
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
@@ -3517,7 +3517,7 @@ P:	Mike Frysinger
 M:	vapier@gentoo.org
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
-T:	git kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
 S:	Maintained
 
 M32R ARCHITECTURE
@@ -3537,7 +3537,7 @@ P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
-T:	git git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
 S:	Maintained
 F:	arch/m68k/
 
@@ -3560,7 +3560,7 @@ P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
@@ -3573,7 +3573,7 @@ P:	Mattias Nissler
 M:	mattias.nissler@gmx.de
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
@@ -3689,7 +3689,7 @@ P:	Ralf Baechle
 M:	ralf@linux-mips.org
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
-T:	git www.linux-mips.org:/pub/scm/linux.git
+T:	git git://git.linux-mips.org/pub/scm/linux.git
 S:	Supported
 F:	Documentation/mips/
 F:	arch/mips/
@@ -3756,7 +3756,7 @@ MULTIFUNCTION DEVICES (MFD)
 P:	Samuel Ortiz
 M:	sameo@linux.intel.com
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
 S:	Supported
 F:	drivers/mfd/
 
@@ -3795,7 +3795,7 @@ MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
 P:	Felipe Balbi
 M:	felipe.balbi@nokia.com
 L:	linux-usb@vger.kernel.org
-T:	git gitorious.org:/musb/mainline.git
+T:	git git://gitorious.org/musb/mainline.git
 S:	Maintained
 F:	drivers/usb/musb/
 
@@ -3917,7 +3917,7 @@ NETWORK DEVICE DRIVERS
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
 F:	drivers/net/
 
@@ -3944,7 +3944,7 @@ M:	yoshfuji@linux-ipv6.org
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 F:	net/ipv4/
 F:	net/ipv6/
@@ -3960,7 +3960,7 @@ NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/wireless/
 F:	include/net/ieee80211*
@@ -4032,7 +4032,7 @@ M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
@@ -4070,7 +4070,7 @@ OMNIVISION OV7670 SENSOR DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/ov7670.c
 
@@ -4140,7 +4140,7 @@ P:	Benny Halevy
 M:	bhalevy@panasas.com
 L:	osd-dev@open-osd.org
 W:	http://open-osd.org
-T:	git://git.open-osd.org/open-osd.git
+T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 
 P54 WIRELESS DRIVER
@@ -4148,7 +4148,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/p54/
 
@@ -4224,7 +4224,7 @@ P:	Helge Deller
 M:	deller@gmx.de
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
 F:	drivers/parisc/
@@ -4262,7 +4262,7 @@ P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
@@ -4279,7 +4279,7 @@ PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
-T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 F:	Documentation/pcmcia/
 F:	drivers/pcmcia/
@@ -4337,7 +4337,7 @@ M:	cbou@mail.ru
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-kernel@vger.kernel.org
-T:	git git.infradead.org/battery-2.6.git
+T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
 F:	include/linux/power_supply.h
 F:	drivers/power/power_supply*
@@ -4450,7 +4450,7 @@ M:	isely@pobox.com
 L:	pvrusb2@isely.net	(subscribers-only)
 L:	linux-media@vger.kernel.org
 W:	http://www.isely.net/pvrusb2/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/README.pvrusb2
 F:	drivers/media/video/pvrusb2/
@@ -4475,14 +4475,14 @@ M:	eric.miao@marvell.com
 P:	Jason Chagas
 M:	jason.chagas@marvell.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
-T:	git kernel.org:/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Supported
 
 PXA910 SUPPORT
 P:	Eric Miao
 M:	eric.miao@marvell.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
-T:	git kernel.org:/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Supported
 
 PXA MMCI DRIVER
@@ -4549,7 +4549,7 @@ L:	linux-wireless@vger.kernel.org
 L:	users@rt2x00.serialmonkey.com
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
-T:	git kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
@@ -4676,7 +4676,7 @@ P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818*
 
@@ -4689,7 +4689,7 @@ P:	Larry Finger
 M:	Larry.Finger@lwfinger.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187*
 
@@ -4766,7 +4766,7 @@ SAA7146 VIDEO4LINUX-2 DRIVER
 P:	Michael Hunold
 M:	michael@mihu.de
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
 F:	drivers/media/common/saa7146*
@@ -4810,9 +4810,9 @@ SCSI SUBSYSTEM
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/
@@ -4888,7 +4888,7 @@ P:	James Morris
 M:	jmorris@namei.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
-T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
 S:	Supported
 F:	security/
@@ -4908,7 +4908,7 @@ M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
-T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
@@ -4924,7 +4924,7 @@ SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 
 SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
@@ -5118,7 +5118,7 @@ SOC-CAMERA V4L2 SUBSYSTEM
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	include/media/v4l2*
 F:	drivers/media/video/v4l2*
@@ -5185,7 +5185,7 @@ P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
-T:	git opensource.wolfsonmicro.com/linux-2.6-asoc
+T:	git git://opensource.wolfsonmicro.com/linux-2.6-asoc
 L:	alsa-devel@alsa-project.org (subscribers-only)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
@@ -5195,8 +5195,8 @@ SPARC + UltraSPARC (sparc/sparc64)
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
 F:	arch/sparc/
 
@@ -5302,7 +5302,7 @@ P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	arch/sh/
 
@@ -5394,7 +5394,7 @@ M:	ibm-acpi@hmh.eng.br
 L:	ibm-acpi-devel@lists.sourceforge.net
 W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
-T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
+T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 S:	Maintained
 F:	drivers/platform/x86/thinkpad_acpi.c
 
@@ -5430,7 +5430,7 @@ M:	allan.stephens@windriver.com
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
-T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
+T:	git git://tipc.cslab.ericsson.net/pub/git/tipc.git
 S:	Maintained
 F:	include/linux/tipc*.h
 F:	include/net/tipc/
@@ -5494,7 +5494,7 @@ TRIVIAL PATCHES
 P:	Jiri Kosina
 M:	trivial@kernel.org
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/trivial.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
 
 TTY LAYER
@@ -5668,7 +5668,7 @@ P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	drivers/media/video/et61x251/
@@ -5686,7 +5686,7 @@ USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-usb@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	Documentation/usb/hiddev.txt
 F:	drivers/hid/usbhid/
@@ -5848,7 +5848,7 @@ P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/sn9c102.txt
@@ -5888,7 +5888,7 @@ P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
 L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linux-uvc.berlios.de
 S:	Maintained
 F:	drivers/media/video/uvc/
@@ -5898,7 +5898,7 @@ P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/w9968cf.txt
@@ -5916,7 +5916,7 @@ P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/zc0301.txt
@@ -5935,7 +5935,7 @@ P:	Antoine Jacquet
 M:	royale@zerezo.com
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
@@ -5969,7 +5969,7 @@ P:	Karel Zak
 M:	kzak@redhat.com
 L:	util-linux-ng@vger.kernel.org
 W:	http://kernel.org/~kzak/util-linux-ng/
-T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+T:	git git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
 UVESAFB DRIVER
@@ -6024,7 +6024,7 @@ P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/
 F:	drivers/media/video/
@@ -6049,7 +6049,7 @@ P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
-T:	git kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
 S:	Supported
 F:	drivers/regulator/
 F:	include/linux/regulator/
@@ -6102,7 +6102,7 @@ F:	drivers/mmc/host/wbsd.*
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
-T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
@@ -6183,7 +6183,7 @@ P:	H. Peter Anvin
 M:	hpa@zytor.com
 M:	x86@kernel.org
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
@@ -6209,7 +6209,7 @@ M:	felixb@sgi.com
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-T:	git://oss.sgi.com/xfs/xfs.git
+T:	git git://oss.sgi.com/xfs/xfs.git
 S:	Supported
 F:	Documentation/filesystems/xfs.txt
 F:	fs/xfs/
-- 
1.6.0.2

