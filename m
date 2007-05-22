Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbXEVBK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbXEVBK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXEVBKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:10:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46108 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbXEVBKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:10:21 -0400
Date: Tue, 22 May 2007 11:10:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix headers check fallout
Message-Id: <20070522111019.a29cf062.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit e8edc6e03a5c8562dc70a6d969f732bdb355a7e7 added an include of
linux/jiffies.h in linux/smb_fs.h outside the ifdef __KERNEL__.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/smb_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/smb_fs.h b/include/linux/smb_fs.h
index 6b51a48..2c5cd55 100644
--- a/include/linux/smb_fs.h
+++ b/include/linux/smb_fs.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_SMB_FS_H
 #define _LINUX_SMB_FS_H
 
-#include <linux/jiffies.h>
 #include <linux/smb.h>
 
 /*
@@ -30,6 +29,7 @@
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 #include <linux/smb_mount.h>
+#include <linux/jiffies.h>
 #include <asm/unaligned.h>
 
 static inline struct smb_sb_info *SMB_SB(struct super_block *sb)
-- 
1.5.1.4

