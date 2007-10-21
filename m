Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbXJUXxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbXJUXxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXJUXv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49210 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbXJUXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:51 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 9/9] Unionfs: remove obsolete #define and comment
Date: Sun, 21 Oct 2007 19:51:22 -0400
Message-Id: <1193010687563-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 include/linux/union_fs.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
index 7f8dcc3..d29318f 100644
--- a/include/linux/union_fs.h
+++ b/include/linux/union_fs.h
@@ -20,8 +20,5 @@
 # define UNIONFS_IOCTL_INCGEN		_IOR(0x15, 11, int)
 # define UNIONFS_IOCTL_QUERYFILE	_IOR(0x15, 15, int)
 
-/* We don't support normal remount, but unionctl uses it. */
-# define UNIONFS_REMOUNT_MAGIC		0x4a5a4380
-
 #endif /* _LINUX_UNIONFS_H */
 
-- 
1.5.2.2

