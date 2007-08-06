Return-Path: <linux-kernel-owner+w=401wt.eu-S1765748AbXHFOCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765748AbXHFOCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764609AbXHFNzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbXHFNyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:53 -0400
Date: Mon, 6 Aug 2007 09:54:50 -0400
Message-Id: <200708061354.l76DsoWh002331@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
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

