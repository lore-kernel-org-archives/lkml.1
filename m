Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXEXAk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXEXAk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761430AbXEXAgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:43 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40232 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbXEXAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:29 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 07/21] Unionfs: Consistent pointer declaration spacing
Date: Wed, 23 May 2007 20:35:57 -0400
Message-Id: <11799669724076-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Change instances of "foo * var" to "foo *var" for consistency.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    6 +++---
 fs/unionfs/file.c   |   14 +++++++-------
 fs/unionfs/inode.c  |    2 +-
 fs/unionfs/super.c  |    2 +-
 fs/unionfs/xattr.c  |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 4924685..0975b6e 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -541,7 +541,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 }
 
 /* purge a dentry's lower-branch states (dput/mntput, etc.) */
-static void __cleanup_dentry(struct dentry * dentry, int bindex,
+static void __cleanup_dentry(struct dentry *dentry, int bindex,
 			     int old_bstart, int old_bend)
 {
 	int loop_start;
@@ -592,7 +592,7 @@ static void __cleanup_dentry(struct dentry * dentry, int bindex,
 }
 
 /* set lower inode ptr and update bstart & bend if necessary */
-static void __set_inode(struct dentry * upper, struct dentry * lower,
+static void __set_inode(struct dentry *upper, struct dentry *lower,
 			int bindex)
 {
 	unionfs_set_lower_inode_idx(upper->d_inode, bindex,
@@ -605,7 +605,7 @@ static void __set_inode(struct dentry * upper, struct dentry * lower,
 }
 
 /* set lower dentry ptr and update bstart & bend if necessary */
-static void __set_dentry(struct dentry * upper, struct dentry * lower,
+static void __set_dentry(struct dentry *upper, struct dentry *lower,
 			 int bindex)
 {
 	unionfs_set_lower_dentry_idx(upper, bindex, lower);
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 57f2bdd..1dfcfcb 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -53,8 +53,8 @@ out:
 	return err;
 }
 
-static ssize_t unionfs_read(struct file * file, char __user * buf,
-			    size_t count, loff_t * ppos)
+static ssize_t unionfs_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
 {
 	struct file *hidden_file;
 	loff_t pos = *ppos;
@@ -78,8 +78,8 @@ out:
 }
 
 /* helper function to unionfs_write */
-static ssize_t __unionfs_write(struct file * file, const char __user * buf,
-			       size_t count, loff_t * ppos)
+static ssize_t __unionfs_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
 {
 	int err = -EINVAL;
 	struct file *hidden_file = NULL;
@@ -123,8 +123,8 @@ out:
 	return err;
 }
 
-static ssize_t unionfs_write(struct file * file, const char __user * buf,
-			     size_t count, loff_t * ppos)
+static ssize_t unionfs_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	int err = 0;
 
@@ -145,7 +145,7 @@ static int unionfs_file_readdir(struct file *file, void *dirent,
 	return -ENOTDIR;
 }
 
-static unsigned int unionfs_poll(struct file *file, poll_table * wait)
+static unsigned int unionfs_poll(struct file *file, poll_table *wait)
 {
 	unsigned int mask = DEFAULT_POLLMASK;
 	struct file *hidden_file = NULL;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 2d0822a..c54b290 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -768,7 +768,7 @@ out:
 	return err;
 }
 
-static int unionfs_readlink(struct dentry *dentry, char __user * buf,
+static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 			    int bufsiz)
 {
 	int err;
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 39939ba..b7f0b45 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -824,7 +824,7 @@ static void unionfs_destroy_inode(struct inode *inode)
 }
 
 /* unionfs inode cache constructor */
-static void init_once(void *v, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(void *v, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct unionfs_inode_info *i = v;
 
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 4dc8ada..12d618b 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -51,7 +51,7 @@ void unionfs_xattr_free(void *ptr, size_t size)
  * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
-ssize_t unionfs_getxattr(struct dentry * dentry, const char *name, void *value,
+ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 			 size_t size)
 {
 	struct dentry *hidden_dentry = NULL;
@@ -115,7 +115,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
  * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
-ssize_t unionfs_listxattr(struct dentry * dentry, char *list, size_t size)
+ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
-- 
1.5.2.rc1.165.gaf9b

