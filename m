Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXICCdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXICCdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXICC0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57680 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbXICCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:57 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 07/32] Unionfs: cpp endif comments
Date: Sun,  2 Sep 2007 22:20:30 -0400
Message-Id: <11887860561705-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Add comments to #endif's to help clarify code.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    2 +-
 fs/unionfs/inode.c  |    4 ++--
 fs/unionfs/sioq.h   |    2 +-
 fs/unionfs/union.h  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index cc7a816..410ce07 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -433,7 +433,7 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 	/* Selinux uses extended attributes for permissions. */
 	if ((err = copyup_xattrs(old_lower_dentry, new_lower_dentry)))
 		goto out_unlink;
-#endif
+#endif /* CONFIG_UNION_FS_XATTR */
 
 	/* do not allow files getting deleted to be re-interposed */
 	if (!d_deleted(dentry))
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index cbbde6f..9261bed 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1122,7 +1122,7 @@ struct inode_operations unionfs_dir_iops = {
 	.getxattr	= unionfs_getxattr,
 	.removexattr	= unionfs_removexattr,
 	.listxattr	= unionfs_listxattr,
-#endif
+#endif /* CONFIG_UNION_FS_XATTR */
 };
 
 struct inode_operations unionfs_main_iops = {
@@ -1133,5 +1133,5 @@ struct inode_operations unionfs_main_iops = {
 	.getxattr	= unionfs_getxattr,
 	.removexattr	= unionfs_removexattr,
 	.listxattr	= unionfs_listxattr,
-#endif
+#endif /* CONFIG_UNION_FS_XATTR */
 };
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index bedd7af..afb71ee 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -89,4 +89,4 @@ extern void __unionfs_unlink(struct work_struct *work);
 extern void __delete_whiteouts(struct work_struct *work);
 extern void __is_opaque_dir(struct work_struct *work);
 
-#endif /* _SIOQ_H */
+#endif /* not _SIOQ_H */
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 2a8f763..b7e5a93 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -419,7 +419,7 @@ static inline int is_robranch(const struct dentry *dentry)
 
 #ifndef DEFAULT_POLLMASK
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
-#endif
+#endif /* not DEFAULT_POLLMASK */
 
 /*
  * EXTERNALS:
-- 
1.5.2.2.238.g7cbf2f2

