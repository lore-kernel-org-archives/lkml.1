Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZEZJpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZEZJpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZEZJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:45:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44602 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbZEZJpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:45:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] linux/magic.h: move cramfs magic out of cramfs_fs.h
Date: Tue, 26 May 2009 05:45:04 -0400
Message-Id: <1243331104-26375-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
---
 include/linux/cramfs_fs.h |    3 +--
 include/linux/magic.h     |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/cramfs_fs.h b/include/linux/cramfs_fs.h
index 3be4e5a..6fc2bed 100644
--- a/include/linux/cramfs_fs.h
+++ b/include/linux/cramfs_fs.h
@@ -2,9 +2,8 @@
 #define __CRAMFS_H
 
 #include <linux/types.h>
+#include <linux/magic.h>
 
-#define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
-#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define CRAMFS_SIGNATURE	"Compressed ROMFS"
 
 /*
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 5b4e28b..192f980 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -6,6 +6,8 @@
 #define AFS_SUPER_MAGIC                0x5346414F
 #define AUTOFS_SUPER_MAGIC	0x0187
 #define CODA_SUPER_MAGIC	0x73757245
+#define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
+#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define DEBUGFS_MAGIC          0x64626720
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
-- 
1.6.3.1

