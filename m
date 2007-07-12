Return-Path: <linux-kernel-owner+w=401wt.eu-S937780AbXGLAXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937780AbXGLAXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937542AbXGLARj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53830 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937525AbXGLARc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:32 -0400
Subject: [PATCH 14/23] mount_is_safe(): add comment
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:29 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001729.555C464E@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This area of code is currently #ifdef'd out, so add a comment
for the time when it is actually used.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/namespace.c~mount-is-safe-add-comment fs/namespace.c
--- lxc/fs/namespace.c~mount-is-safe-add-comment	2007-07-10 12:46:11.000000000 -0700
+++ lxc-dave/fs/namespace.c	2007-07-10 12:46:11.000000000 -0700
@@ -728,6 +728,10 @@ static int mount_is_safe(struct nameidat
 		if (current->uid != nd->dentry->d_inode->i_uid)
 			return -EPERM;
 	}
+	/*
+	 * We will eventually check for the mnt->writer_count here,
+	 * but since the code is not used now, skip it - Dave Hansen
+	 */
 	if (vfs_permission(nd, MAY_WRITE))
 		return -EPERM;
 	return 0;
_
