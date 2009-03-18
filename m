Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZCRSNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZCRSNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZCRSNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:13:04 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:22225 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759411AbZCRSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:13:03 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 8/8] fs: Add exofs to Kernel build
Date: Wed, 18 Mar 2009 20:11:51 +0200
Message-Id: <1237399911-29572-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-OriginalArrivalTime: 18 Mar 2009 18:13:00.0353 (UTC) FILETIME=[2BFBFB10:01C9A7F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add exofs to fs/Kconfig under "menu 'Miscellaneous filesystems'"
- Add exofs to fs/Makefile

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/Kconfig  |    2 ++
 fs/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 93945dd..d0c544c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -223,6 +223,8 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 
+source "fs/exofs/Kconfig"
+
 endif # MISC_FILESYSTEMS
 
 menuconfig NETWORK_FILESYSTEMS
diff --git a/fs/Makefile b/fs/Makefile
index dc20db3..f5f5ce7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_EXOFS_FS)          += exofs/
-- 
1.6.2.1

