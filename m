Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXDIPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXDIPBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964896AbXDIPBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:01:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43993 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933669AbXDIOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:32 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 14/21] Unionfs: Document unionfs_d_release locking
Date: Mon,  9 Apr 2007 10:54:05 -0400
Message-Id: <11761304552377-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index c841f08..4756b78 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -286,6 +286,10 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	return err;
 }
 
+/*
+ * At this point no one can reference this dentry, so we don't have to be
+ * careful about concurrent access.
+ */
 static void unionfs_d_release(struct dentry *dentry)
 {
 	int bindex, bstart, bend;
-- 
1.5.0.3.268.g3dda

