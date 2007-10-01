Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbXJAFvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbXJAFvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXJAFvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40591 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbXJAFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:13 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/19] Unionfs: compile if debug is off
Date: Mon,  1 Oct 2007 01:50:38 -0400
Message-Id: <11912178573215-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/union.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 824bb67..7ce4771 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -556,6 +556,7 @@ extern void __show_inode_counts(const struct inode *inode,
 #define unionfs_check_inode(i)		do { } while(0)
 #define unionfs_check_dentry(d)		do { } while(0)
 #define unionfs_check_file(f)		do { } while(0)
+#define unionfs_check_nd(n)		do { } while(0)
 #define show_branch_counts(sb)		do { } while(0)
 #define show_inode_times(i)		do { } while(0)
 #define show_dinode_times(d)		do { } while(0)
-- 
1.5.2.2

