Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYAJPEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYAJPEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbYAJPA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:57 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57022 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbYAJPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:41 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 04/29] Unionfs: main Makefile
Date: Thu, 10 Jan 2008 09:59:23 -0500
Message-Id: <11999771903655-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
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

