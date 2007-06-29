Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXF2H1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXF2H1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932784AbXF2H0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:43 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46311 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761553AbXF2H0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 4/5] Unionfs: Clarification comment for unionfs_lookup
Date: Fri, 29 Jun 2007 03:26:20 -0400
Message-Id: <1183101982440-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
References: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index f946b33..a86da5b 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -217,6 +217,11 @@ out:
 	return err;
 }
 
+/*
+ * unionfs_lookup is the only special function which takes a dentry, yet we
+ * do NOT want to call __unionfs_d_revalidate_chain because by definition,
+ * we don't have a valid dentry here yet.
+ */
 static struct dentry *unionfs_lookup(struct inode *parent,
 				     struct dentry *dentry,
 				     struct nameidata *nd)
-- 
1.5.2.2.238.g7cbf2f2

