Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZLKWdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZLKWdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZLKWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:32:52 -0500
Received: from kroah.org ([198.145.64.141]:32821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762736AbZLKWZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/27] sysfs: Nicely indent sysfs_symlink_inode_operations
Date: Fri, 11 Dec 2009 14:24:41 -0800
Message-Id: <1260570289-6997-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Lining up the functions in sysfs_symlink_inode_operations
follows the pattern in the rest of sysfs and makes things
slightly more readable.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index c5081ad..1137418 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -210,10 +210,10 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd, void *co
 }
 
 const struct inode_operations sysfs_symlink_inode_operations = {
-	.setxattr = sysfs_setxattr,
-	.readlink = generic_readlink,
-	.follow_link = sysfs_follow_link,
-	.put_link = sysfs_put_link,
+	.setxattr	= sysfs_setxattr,
+	.readlink	= generic_readlink,
+	.follow_link	= sysfs_follow_link,
+	.put_link	= sysfs_put_link,
 };
 
 
-- 
1.6.5.5

