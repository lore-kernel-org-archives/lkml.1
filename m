Return-Path: <linux-kernel-owner+w=401wt.eu-S938335AbZDJHWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938335AbZDJHWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938069AbZDJHRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:17:42 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:61470 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938055AbZDJHRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:17:40 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 29/29] kbuild aufs
Date: Fri, 10 Apr 2009 16:02:43 +0900
Message-Id: <1239346963-30953-30-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/Kconfig  |    1 +
 fs/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 9f7270f..7b7f62a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -203,6 +203,7 @@ config NILFS2_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called nilfs2.  If unsure, say N.
 
+source "fs/aufs/Kconfig"
 endif # MISC_FILESYSTEMS
 
 menuconfig NETWORK_FILESYSTEMS
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..dba1ce1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
+obj-$(CONFIG_AUFS_FS)           += aufs/
-- 
1.6.1.284.g5dc13

