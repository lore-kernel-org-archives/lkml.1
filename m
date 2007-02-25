Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXBYXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXBYXS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965223AbXBYXS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:18:56 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44222 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965225AbXBYXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:18:54 -0500
Date: Mon, 26 Feb 2007 00:18:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/slab.c: proper prototypes
Message-ID: <20070225231854.GE29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes in include/linux/slab.h.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/proc/proc_misc.c  |    2 --
 include/linux/slab.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.20-mm2/include/linux/slab.h.old	2007-02-25 19:48:30.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/slab.h	2007-02-25 19:52:47.000000000 +0100
@@ -218,6 +218,9 @@
 
 #endif /* DEBUG_SLAB */
 
+extern const struct seq_operations slabinfo_op;
+ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
 
--- linux-2.6.20-mm2/fs/proc/proc_misc.c.old	2007-02-25 19:51:44.000000000 +0100
+++ linux-2.6.20-mm2/fs/proc/proc_misc.c	2007-02-25 19:52:17.000000000 +0100
@@ -400,8 +400,6 @@
 #endif
 
 #ifdef CONFIG_SLAB
-extern struct seq_operations slabinfo_op;
-extern ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
 static int slabinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &slabinfo_op);

