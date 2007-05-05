Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXEEXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXEEXCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934112AbXEEXCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:02:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54802 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbXEEXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:01:56 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/2] fs: Fix indentation in do_path_lookup
Date: Sat,  5 May 2007 18:59:39 -0400
Message-Id: <11784059803717-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <1178405980972-git-send-email-jsipek@cs.sunysb.edu>
References: <1178405980972-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0262594..600a4e7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1159,7 +1159,7 @@ out:
 	if (likely(retval == 0)) {
 		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
 				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry->d_inode);
+			audit_inode(name, nd->dentry->d_inode);
 	}
 out_fail:
 	return retval;
-- 
1.5.0.3.1043.g4342

