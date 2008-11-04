Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYKDQrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYKDQrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYKDQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:46:09 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37573 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbYKDQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:46:06 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>
Subject: [PATCH 18/18] scsi: Add osd library to build system
Date: Tue,  4 Nov 2008 18:44:55 +0200
Message-Id: <1225817095-6293-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <491073BB.4000900@panasas.com>
References: <491073BB.4000900@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSD in kernel source code is assumed to be at:
drivers/scsi/osd/ with its own Makefile and Kconfig

Add includes to them from drivers/scsi Makefile and Kconfig
Add OSD to MAINTAINERS file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 MAINTAINERS           |   10 ++++++++++
 drivers/scsi/Kconfig  |    2 ++
 drivers/scsi/Makefile |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 355c192..03da1e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3153,6 +3153,16 @@ L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 
+OSD LIBRARY
+P:	Boaz Harrosh
+M:	bharrosh@panasas.com
+P:	Benny Halevy
+M:	bhalevy@panasas.com
+L:	osd-dev@open-osd.org
+W:	http://open-osd.org
+T:	git://git.open-osd.org/osd-lib.git
+S:	Maintained
+
 P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 403ecad..e6af21c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1780,4 +1780,6 @@ source "drivers/scsi/pcmcia/Kconfig"
 
 source "drivers/scsi/device_handler/Kconfig"
 
+source "drivers/scsi/osd/Kconfig"
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72fd504..1e49632 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -135,6 +135,8 @@ obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-- 
1.6.0.1

