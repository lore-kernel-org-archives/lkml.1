Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXHFOFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXHFOFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbXHFNzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXHFNzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:23 -0400
Date: Mon, 6 Aug 2007 09:55:22 -0400
Message-Id: <200708061355.l76DtMew002395@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 25/25] spufs: call attr_kill_to_mode from spufs_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index b3d0dd1..d0f6b62 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -97,6 +97,7 @@ spufs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 
+	attr_kill_to_mode(inode, attr);
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    (attr->ia_size != inode->i_size))
 		return -EINVAL;
-- 
1.5.2.2

