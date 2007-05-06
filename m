Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXEFRsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXEFRsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXEFRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:48:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60374 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbXEFRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:48:06 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/2] fs: Fix indentation in do_path_lookup
Date: Sun,  6 May 2007 13:47:55 -0400
Message-Id: <1178473676100-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
References: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7a98676..2a5c232 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1159,11 +1159,9 @@ static int fastcall do_path_lookup(int dfd, const char *name,
 	current->total_link_count = 0;
 	retval = link_path_walk(name, nd);
 out:
-	if (likely(retval == 0)) {
-		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
+	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
 				nd->dentry->d_inode))
 		audit_inode(name, nd->dentry->d_inode);
-	}
 out_fail:
 	return retval;
 
-- 
1.5.2.rc1.20.g86b9

