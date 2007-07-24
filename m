Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXHFN32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXHFN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbXHFNTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:19:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765431AbXHFNST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:19 -0400
Message-Id: <200708061318.l76DIEYh001743@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 13:01:56 -0400
Subject: [PATCH 15/25] JFS: call attr_kill_to_mode from jfs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/jfs/acl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 4d84bdc..34ca314 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -227,6 +227,8 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int rc;
 
+	attr_kill_to_mode(inode, iattr);
+
 	rc = inode_change_ok(inode, iattr);
 	if (rc)
 		return rc;
-- 
1.5.2.2

