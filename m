Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYAJPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYAJPDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYAJPAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:40 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57004 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbYAJPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:32 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/29] Makefile: hook to compile unionfs
Date: Thu, 10 Jan 2008 09:59:22 -0500
Message-Id: <11999771892263-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index 500cf15..e202288 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_UNION_FS)		+= unionfs/
-- 
1.5.2.2

