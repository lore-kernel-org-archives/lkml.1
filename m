Return-Path: <linux-kernel-owner+w=401wt.eu-S1423363AbXBIWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423363AbXBIWyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946549AbXBIWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:38 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44317 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423362AbXBIWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:38 -0500
Subject: [PATCH 09/22] mount_is_safe(): add comment
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:35 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225335.017500FA@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This area of code is currently #ifdef'd out, so add a comment
for the time when it is actually used.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/namespace.c~11-24-mount-is-safe-add-comment fs/namespace.c
--- lxc/fs/namespace.c~11-24-mount-is-safe-add-comment	2007-02-09 14:26:52.000000000 -0800
+++ lxc-dave/fs/namespace.c	2007-02-09 14:26:52.000000000 -0800
@@ -744,6 +744,10 @@ static int mount_is_safe(struct nameidat
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
