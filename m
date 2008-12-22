Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYLVNUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYLVNUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYLVNUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:20:41 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:3863 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbYLVNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:20:40 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd ml <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/18] scsi: Add osd library to build system
Date: Mon, 22 Dec 2008 15:20:35 +0200
Message-Id: <1229952035-16225-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <494F88C0.4070507@panasas.com>
References: <494F88C0.4070507@panasas.com>
X-OriginalArrivalTime: 22 Dec 2008 13:20:37.0708 (UTC) FILETIME=[143A48C0:01C96438]
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
index 8f2b67e..79df335 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3234,6 +3234,16 @@ L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 
+OSD LIBRARY
+P:	Boaz Harrosh
+M:	bharrosh@panasas.com
+P:	Benny Halevy
+M:	bhalevy@panasas.com
+L:	osd-dev@open-osd.org
+W:	http://open-osd.org
+T:	git://git.open-osd.org/open-osd.git
+S:	Maintained
+
 P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 673463e..1170c01 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1800,4 +1800,6 @@ source "drivers/scsi/pcmcia/Kconfig"
 
 source "drivers/scsi/device_handler/Kconfig"
 
+source "drivers/scsi/osd/Kconfig"
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 07d0f58..e68864b 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -137,6 +137,8 @@ obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-- 
1.6.0.1

