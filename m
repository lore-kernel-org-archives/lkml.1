Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbYDAVHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbYDAVHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbYDAVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45562 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbYDAVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:31 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/14] Unionfs: use __func__ instead of __FUNCTION__
Date: Tue,  1 Apr 2008 17:06:50 -0400
Message-Id: <12070840201274-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    2 +-
 fs/unionfs/union.h  |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index f8f65e1..5e498c2 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -406,7 +406,7 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 	chain = kzalloc(chain_len * sizeof(struct dentry *), GFP_KERNEL);
 	if (unlikely(!chain)) {
 		printk(KERN_CRIT "unionfs: no more memory in %s\n",
-		       __FUNCTION__);
+		       __func__);
 		goto out;
 	}
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 63f3b21..e93b9ef 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -557,24 +557,24 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 #ifdef CONFIG_UNION_FS_DEBUG
 
 /* useful for tracking code reachability */
-#define UDBG pr_debug("DBG:%s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__)
+#define UDBG pr_debug("DBG:%s:%s:%d\n", __FILE__, __func__, __LINE__)
 
 #define unionfs_check_inode(i)	__unionfs_check_inode((i),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define unionfs_check_dentry(d)	__unionfs_check_dentry((d),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define unionfs_check_file(f)	__unionfs_check_file((f),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define unionfs_check_nd(n)	__unionfs_check_nd((n),		\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define show_branch_counts(sb)	__show_branch_counts((sb),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define show_inode_times(i)	__show_inode_times((i),		\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define show_dinode_times(d)	__show_dinode_times((d),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 #define show_inode_counts(i)	__show_inode_counts((i),	\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 
 extern void __unionfs_check_inode(const struct inode *inode, const char *fname,
 				  const char *fxn, int line);
-- 
1.5.2.2

