Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYEIUMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYEIUMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYEIULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:11:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37477 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbYEIULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:11:06 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/2] Unionfs: move fs/Makefile entry up to minimize merge conflicts
Date: Fri,  9 May 2008 16:07:16 -0400
Message-Id: <12103636371013-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12103636363945-git-send-email-ezk@cs.sunysb.edu>
References: <12103636363945-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index 22ebb61..dadf53b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_ISO9660_FS)	+= isofs/
 obj-$(CONFIG_HFSPLUS_FS)	+= hfsplus/ # Before hfs to find wrapped HFS+
 obj-$(CONFIG_HFS_FS)		+= hfs/
 obj-$(CONFIG_ECRYPT_FS)		+= ecryptfs/
+obj-$(CONFIG_UNION_FS)		+= unionfs/
 obj-$(CONFIG_VXFS_FS)		+= freevxfs/
 obj-$(CONFIG_NFS_FS)		+= nfs/
 obj-$(CONFIG_EXPORTFS)		+= exportfs/
@@ -119,4 +120,3 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
-obj-$(CONFIG_UNION_FS)		+= unionfs/
-- 
1.5.2.2

