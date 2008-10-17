Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYJQPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYJQPxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYJQPwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:52:23 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:2420 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbYJQPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:52:13 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Subject: [PATCH 13/14] Squashfs: Makefiles
Message-Id: <E1KqrTX-0001y9-MO@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Fri, 17 Oct 2008 16:42:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/Makefile          |    1 +
 fs/squashfs/Makefile |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index b6f27dc..42d881b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_JBD)		+= jbd/
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
1.5.2.5

