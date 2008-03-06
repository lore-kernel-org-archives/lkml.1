Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbYCFBSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbYCFBSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbYCFBPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:15:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20194 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbYCFBPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:15:06 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, teigland@redhat.com
Subject: [PATCH 09/10] ocfs2: Add kbuild for ocfs2_stack_user.ko
Date: Wed,  5 Mar 2008 17:13:57 -0800
Message-Id: <1204766038-31721-10-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ocfs2_stack_user.ko to the Makefile so that it builds.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b734254..b8d6d02 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -2,7 +2,11 @@ EXTRA_CFLAGS += -Ifs/ocfs2
 
 EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
 
-obj-$(CONFIG_OCFS2_FS) += ocfs2.o ocfs2_stackglue.o ocfs2_stack_o2cb.o
+obj-$(CONFIG_OCFS2_FS) += 	\
+	ocfs2.o			\
+	ocfs2_stackglue.o	\
+	ocfs2_stack_o2cb.o	\
+	ocfs2_stack_user.o
 
 ocfs2-objs := \
 	alloc.o 		\
@@ -33,6 +37,7 @@ ocfs2-objs := \
 
 ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
+ocfs2_stack_user-objs := stack_user.o
 
 obj-$(CONFIG_OCFS2_FS) += cluster/
 obj-$(CONFIG_OCFS2_FS) += dlm/
-- 
1.5.3.8

