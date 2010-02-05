Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0BEUao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:30:44 -0500
Received: from mail.perches.com ([173.55.12.10]:1860 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab0BEUam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:30:42 -0500
Subject: [PATCH] MAINTAINERS: Document and add "Q" patchwork queue entries
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 12:30:40 -0800
Message-ID: <1265401840.10226.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A resubmit of http://lkml.org/lkml/2010/1/14/59 as a
rolled up patch.  If you want separate patches, just ask.

Patchwork queues show the acceptance/rejection state of
submitted patches for various MAINTAINER trees.

Document their existence.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03f38c1..3469b8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -71,6 +71,7 @@ Descriptions of section entries:
 	M: Mail patches to: FullName <address@domain>
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
+	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
@@ -182,6 +183,7 @@ M:	Ron Minnich <rminnich@sandia.gov>
 M:	Latchesar Ionkov <lucho@ionkov.net>
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
+Q:	http://patchwork.kernel.org/project/v9fs-devel/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
 S:	Maintained
 F:	Documentation/filesystems/9p.txt
@@ -236,6 +238,7 @@ ACPI
 M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
+Q:	http://patchwork.kernel.org/project/linux-acpi/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
@@ -1328,6 +1331,7 @@ BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
+Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
@@ -1491,6 +1495,7 @@ M:	Steve French <sfrench@samba.org>
 L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
+Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
@@ -1776,6 +1781,7 @@ DEVICE-MAPPER  (LVM)
 P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
+Q:	http://patchwork.kernel.org/project/dm-devel/list/
 S:	Maintained
 F:	Documentation/device-mapper/
 F:	drivers/md/dm*
@@ -2119,6 +2125,7 @@ M:	"Theodore Ts'o" <tytso@mit.edu>
 M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
 S:	Maintained
 F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/
@@ -2680,6 +2687,7 @@ F:	drivers/scsi/ips.*
 IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ide/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
@@ -2734,6 +2742,7 @@ M:	Sean Hefty <sean.hefty@intel.com>
 M:	Hal Rosenstock <hal.rosenstock@gmail.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.openib.org/
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
@@ -2753,6 +2762,7 @@ INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
 M:	Dmitry Torokhov <dtor@mail.ru>
 L:	linux-input@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-input/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
@@ -3062,6 +3072,7 @@ F:	drivers/hwmon/k8temp.c
 KCONFIG
 M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-kbuild@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-kbuild/list/
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
@@ -3275,6 +3286,7 @@ M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 M:	Paul Mackerras <paulus@samba.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
+Q:	http://patchwork.ozlabs.org/project/linuxppc-dev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
 F:	Documentation/powerpc/
@@ -3529,6 +3541,7 @@ M:	Mauro Carvalho Chehab <mchehab@infradead.org>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
+Q:	http://patchwork.kernel.org/project/linux-media/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/dvb/
@@ -3564,8 +3577,9 @@ F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
-W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
+W:	http://www.linux-mtd.infradead.org/
+Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
@@ -3823,6 +3837,7 @@ S:	Maintained
 NETWORKING [WIRELESS]
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/
@@ -3914,6 +3929,7 @@ M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
+Q:	http://patchwork.kernel.org/project/linux-omap/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
 F:	arch/arm/*omap*/
@@ -4139,6 +4155,7 @@ M:	Helge Deller <deller@gmx.de>
 M:	"James E.J. Bottomley" <jejb@parisc-linux.org>
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
+Q:	http://patchwork.kernel.org/project/linux-parisc/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
@@ -4181,6 +4198,7 @@ F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 PCI SUBSYSTEM
 M:	Jesse Barnes <jbarnes@virtuousgeek.org>
 L:	linux-pci@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-pci/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
@@ -4548,6 +4566,7 @@ F:	include/linux/rtc.h
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
+Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
@@ -4906,6 +4925,7 @@ F:	drivers/*/*/*s3c2410*
 TI DAVINCI MACHINE SUPPORT
 P:	Kevin Hilman
 M:	davinci-linux-open-source@linux.davincidsp.com
+Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
 F:	arch/arm/mach-davinci
 
@@ -5071,6 +5091,7 @@ F:	include/sound/soc*
 SPARC + UltraSPARC (sparc/sparc64)
 M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/sparclinux/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
@@ -5086,6 +5107,7 @@ SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
+Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
@@ -5162,6 +5184,7 @@ SUPERH
 M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
+Q:	http://patchwork.kernel.org/project/linux-sh/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	Documentation/sh/
@@ -6106,6 +6129,7 @@ F:	drivers/serial/zs.*
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/LKML/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
 F:	*


