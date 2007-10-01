Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXJAFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXJAFyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbXJAFvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40737 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXJAFvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:25 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/19] Unionfs: properly indent static struct
Date: Mon,  1 Oct 2007 01:50:43 -0400
Message-Id: <11912178593894-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 615617a..5c7f672 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -564,7 +564,10 @@ static struct dentry *unionfs_d_alloc_root(struct super_block *sb)
 	struct dentry *ret = NULL;
 
 	if (sb) {
-		static const struct qstr name = {.name = "/",.len = 1 };
+		static const struct qstr name = {
+			.name = "/",
+			.len = 1
+		};
 
 		ret = d_alloc(NULL, &name);
 		if (likely(ret)) {
-- 
1.5.2.2

