Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXIZDgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXIZDgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbXIZDd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:33:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35468 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578AbXIZDdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:33:24 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/25] Unionfs: Remove unused #defines
Date: Tue, 25 Sep 2007 23:09:41 -0400
Message-Id: <11907762052800-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/union.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 1cb2e1d..140b8ae 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -437,10 +437,6 @@ static inline int is_robranch(const struct dentry *dentry)
 #define UNIONFS_DIR_OPAQUE_NAME "__dir_opaque"
 #define UNIONFS_DIR_OPAQUE UNIONFS_WHPFX UNIONFS_DIR_OPAQUE_NAME
 
-#ifndef DEFAULT_POLLMASK
-#define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
-#endif /* not DEFAULT_POLLMASK */
-
 /*
  * EXTERNALS:
  */
-- 
1.5.2.2

