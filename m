Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXKAVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXKAVgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbXKAVfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:35:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:55667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbXKAVfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:35:46 -0400
Message-Id: <20071029124121.200421099@weierstrass.suse.de>
References: <20071029124120.528997881@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 29 Oct 2007 13:41:22 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH 2/7] d_path: kerneldoc cleanup
Content-Disposition: inline; filename=vfs/d_path-kerneldoc_cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move and update d_path() kernel API documentation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/dcache.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1762,22 +1762,6 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
-/**
- * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
- * @root: root dentry
- * @rootmnt: vfsmnt to which the root dentry belongs
- * @buffer: buffer to return value in
- * @buflen: buffer length
- *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
- *
- * Returns the buffer or an error code if the path was too long.
- *
- * "buflen" should be positive. Caller holds the dcache_lock.
- */
 static char * __d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
 		       struct path *root, char *buffer, int buflen)
 {
@@ -1845,9 +1829,22 @@ Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
 
-/* write full pathname into buffer and return start of pathname */
-char * d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-				char *buf, int buflen)
+/**
+ * d_path - return the path of a dentry
+ * @dentry: dentry to report
+ * @vfsmnt: vfsmnt to which the dentry belongs
+ * @buf: buffer to return value in
+ * @buflen: buffer length
+ *
+ * Convert a dentry into an ASCII path name. If the entry has been deleted
+ * the string " (deleted)" is appended. Note that this is ambiguous.
+ *
+ * Returns the buffer or an error code if the path was too long.
+ *
+ * "buflen" should be positive. Caller holds the dcache_lock.
+ */
+char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+	     char *buf, int buflen)
 {
 	char *res;
 	struct path root;

-- 

