Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZBINbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZBINbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZBINbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:31:21 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:29721 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018AbZBINbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:31:20 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 8/8] fs: Add exofs to Kernel build
Date: Mon,  9 Feb 2009 15:31:12 +0200
Message-Id: <1234186272-7971-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <49902A9E.3070002@panasas.com>
References: <49902A9E.3070002@panasas.com>
X-OriginalArrivalTime: 09 Feb 2009 13:31:18.0318 (UTC) FILETIME=[B04D5CE0:01C98ABA]
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
index 38bc735..c907161 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,3 +122,4 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_EXOFS_FS)          += exofs/
-- 
1.6.0.1

