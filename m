Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbXLJCrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbXLJCrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbXLJCnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:20 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49753 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbXLJCnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:07 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 09/42] Unionfs: main Makefile
Date: Sun,  9 Dec 2007 21:41:42 -0500
Message-Id: <11972545392605-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/Makefile |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 fs/unionfs/Makefile

diff --git a/fs/unionfs/Makefile b/fs/unionfs/Makefile
new file mode 100644
index 0000000..17ca4a7
--- /dev/null
+++ b/fs/unionfs/Makefile
@@ -0,0 +1,13 @@
+obj-$(CONFIG_UNION_FS) += unionfs.o
+
+unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
+	rdstate.o copyup.o dirhelper.o rename.o unlink.o \
+	lookup.o commonfops.o dirfops.o sioq.o mmap.o
+
+unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
+
+unionfs-$(CONFIG_UNION_FS_DEBUG) += debug.o
+
+ifeq ($(CONFIG_UNION_FS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
-- 
1.5.2.2

