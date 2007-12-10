Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXLJCtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXLJCtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXLJCnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49808 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbXLJCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:21 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 31/42] VFS: fs_stack header cleanups
Date: Sun,  9 Dec 2007 21:42:04 -0500
Message-Id: <11972545551650-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 include/linux/fs_stack.h |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index bb516ce..6b52faf 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -1,17 +1,28 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef _LINUX_FS_STACK_H
 #define _LINUX_FS_STACK_H
 
-/* This file defines generic functions used primarily by stackable
+/*
+ * This file defines generic functions used primarily by stackable
  * filesystems; none of these functions require i_mutex to be held.
  */
 
 #include <linux/fs.h>
 
 /* externs for fs/stack.c */
-extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *));
-
-extern void fsstack_copy_inode_size(struct inode *dst, const struct inode *src);
+extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst,
+				    const struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
-- 
1.5.2.2

