Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbXEFPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbXEFPam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXEFPam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 11:30:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56007 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbXEFPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 11:30:40 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH] fs: Fix indentation in do_path_lookup
Date: Sun,  6 May 2007 11:30:28 -0400
Message-Id: <11784654282342-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <20070506111124.GA1211@infradead.org>
References: <20070506111124.GA1211@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0262594..48078ea 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1156,11 +1156,9 @@ static int fastcall do_path_lookup(int dfd, const char *name,
 	current->total_link_count = 0;
 	retval = link_path_walk(name, nd);
 out:
-	if (likely(retval == 0)) {
-		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
-				nd->dentry->d_inode))
+	if (unlikely(!retval && !audit_dummy_context() && nd &&
+				nd->dentry && nd->dentry->d_inode))
 		audit_inode(name, nd->dentry->d_inode);
-	}
 out_fail:
 	return retval;
 
-- 
1.5.2.rc1.20.g86b9

