Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbZDJFen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbZDJFen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbZDJFdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:58962 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbZDJFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:14 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 4/8] nilfs2: remove module version
Date: Fri, 10 Apr 2009 14:27:57 +0900
Message-Id: <1239341281-20249-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A MODULE_VERSION() macro has been used in out-of-tree nilfs modules,
but it's needless and not updated in tree.  So, this removes it along
with the version declaration.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/nilfs.h |    5 -----
 fs/nilfs2/super.c |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 7558c97..3d0c18a 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -35,11 +35,6 @@
 #include "bmap_union.h"
 
 /*
- * NILFS filesystem version
- */
-#define NILFS_VERSION		"2.0.5"
-
-/*
  * nilfs inode data in memory
  */
 struct nilfs_inode_info {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8a965f9..6989b03 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -63,7 +63,6 @@
 MODULE_AUTHOR("NTT Corp.");
 MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 		   "(NILFS)");
-MODULE_VERSION(NILFS_VERSION);
 MODULE_LICENSE("GPL");
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
-- 
1.5.6.5

