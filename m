Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZAELJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZAELJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZAELIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:08:21 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:39571 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZAELIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:08:16 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: [PATCH V3 13/17] Squashfs: Makefiles
Message-Id: <E1LJnJo-0002M5-5z@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 05 Jan 2009 11:08:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/Makefile          |    1 +
 fs/squashfs/Makefile |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index e6f423d..3f8843c 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
+obj-$(CONFIG_SQUASHFS)		+= squashfs/
 obj-y				+= ramfs/
 obj-$(CONFIG_HUGETLBFS)		+= hugetlbfs/
 obj-$(CONFIG_CODA_FS)		+= coda/
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
new file mode 100644
index 0000000..8258cf9
--- /dev/null
+++ b/fs/squashfs/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the linux squashfs routines.
+#
+
+obj-$(CONFIG_SQUASHFS) += squashfs.o
+squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
+squashfs-y += namei.o super.o symlink.o
+#squashfs-y += squashfs2_0.o
-- 
1.5.6.3

