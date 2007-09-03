Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbXICCaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbXICCaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXICCZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57645 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXICCYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:37 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 01/32] VFS: export release_open_intent symbol
Date: Sun,  2 Sep 2007 22:20:24 -0400
Message-Id: <118878605590-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a83160a..b2b7c8e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -374,6 +374,7 @@ void release_open_intent(struct nameidata *nd)
 	else
 		fput(nd->intent.open.file);
 }
+EXPORT_SYMBOL(release_open_intent);
 
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
-- 
1.5.2.2.238.g7cbf2f2

