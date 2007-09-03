Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbXICCjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbXICCjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964830AbXICC2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:28:10 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57940 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782AbXICC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:28:08 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 03/32] VFS/fsstack: cpp endif comments
Date: Sun,  2 Sep 2007 22:20:26 -0400
Message-Id: <11887860564146-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Add comments to #endif's to help clarify code.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/linux/fs_stack.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index 6b52faf..28543ad 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -39,4 +39,4 @@ static inline void fsstack_copy_attr_times(struct inode *dest,
 	dest->i_ctime = src->i_ctime;
 }
 
-#endif /* _LINUX_FS_STACK_H */
+#endif /* not _LINUX_FS_STACK_H */
-- 
1.5.2.2.238.g7cbf2f2

