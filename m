Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbXJLWzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbXJLWzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbXJLWWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbXJLWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 63/75] sysfs: make sysfs_root a regular directory dirent
Date: Fri, 12 Oct 2007 15:17:07 -0700
Message-Id: <11922277364080-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227731677-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs_root is different from a regular directory dirent in that it's
of type SYSFS_ROOT and doesn't have a name.  These differences aren't
used by anybody and only adds to complexity.  Make sysfs_root a
regular directory dirent.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    5 -----
 fs/sysfs/mount.c |    3 ++-
 fs/sysfs/sysfs.h |    9 ++++-----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index b6ac4e6..c40fb9f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -157,11 +157,6 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 	/* initialize inode according to type */
 	switch (sysfs_type(sd)) {
-	case SYSFS_ROOT:
-		inode->i_op = &sysfs_dir_inode_operations;
-		inode->i_fop = &sysfs_dir_operations;
-		inc_nlink(inode); /* directory, account for "." */
-		break;
 	case SYSFS_DIR:
 		inode->i_op = &sysfs_dir_inode_operations;
 		inode->i_fop = &sysfs_dir_operations;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 28bf359..465902c 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -24,8 +24,9 @@ static const struct super_operations sysfs_ops = {
 };
 
 struct sysfs_dirent sysfs_root = {
+	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
-	.s_flags	= SYSFS_ROOT,
+	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
 };
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2a68bfa..60405a6 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -48,11 +48,10 @@ struct sysfs_dirent {
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
 #define SYSFS_TYPE_MASK			0x00ff
-#define SYSFS_ROOT			0x0001
-#define SYSFS_DIR			0x0002
-#define SYSFS_KOBJ_ATTR			0x0004
-#define SYSFS_KOBJ_BIN_ATTR		0x0008
-#define SYSFS_KOBJ_LINK			0x0020
+#define SYSFS_DIR			0x0001
+#define SYSFS_KOBJ_ATTR			0x0002
+#define SYSFS_KOBJ_BIN_ATTR		0x0004
+#define SYSFS_KOBJ_LINK			0x0008
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
-- 
1.5.3.4

