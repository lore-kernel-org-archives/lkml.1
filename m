Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbYDBUa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbYDBUa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbYDBURv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:17:51 -0400
Received: from mail.suse.de ([195.135.220.2]:36831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760318AbYDBURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:17:49 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 34/62] ocfs2: Add kbuild for ocfs2_stack_user.ko
Date: Wed,  2 Apr 2008 13:14:44 -0700
Message-Id: <12071673882492-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12071673872568-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
 <1207167318479-git-send-email-mfasheh@suse.com>
 <12071673203909-git-send-email-mfasheh@suse.com>
 <12071673232465-git-send-email-mfasheh@suse.com>
 <12071673263948-git-send-email-mfasheh@suse.com>
 <12071673282579-git-send-email-mfasheh@suse.com>
 <1207167330482-git-send-email-mfasheh@suse.com>
 <12071673321172-git-send-email-mfasheh@suse.com>
 <12071673341888-git-send-email-mfasheh@suse.com>
 <12071673362069-git-send-email-mfasheh@suse.com>
 <12071673391031-git-send-email-mfasheh@suse.com>
 <12071673413492-git-send-email-mfasheh@suse.com>
 <1207167343926-git-send-email-mfasheh@suse.com>
 <12071673461268-git-send-email-mfasheh@suse.com>
 <12071673481928-git-send-email-mfasheh@suse.com>
 <12071673492775-git-send-email-mfasheh@suse.com>
 <12071673511262-git-send-email-mfasheh@suse.com>
 <12071673543752-git-send-email-mfasheh@suse.com>
 <1207167355295-git-send-email-mfasheh@suse.com>
 <12071673571757-git-send-email-mfasheh@suse.com>
 <12071673591158-git-send-email-mfasheh@suse.com>
 <12071673613757-git-send-email-mfasheh@suse.com>
 <1207167363119-git-send-email-mfasheh@suse.com>
 <12071673661674-git-send-email-mfasheh@suse.com>
 <12071673681650-git-send-email-mfasheh@suse.com>
 <12071673701937-git-send-email-mfasheh@suse.com>
 <12071673722691-git-send-email-mfasheh@suse.com>
 <12071673731276-git-send-email-mfasheh@suse.com>
 <12071673753788-git-send-email-mfasheh@suse.com>
 <12071673772233-git-send-email-mfasheh@suse.com>
 <1207167379283-git-send-email-mfasheh@suse.com>
 <12071673821008-git-send-email-mfasheh@suse.com>
 <12071673843208-git-send-email-mfasheh@suse.com>
 <12071673872568-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Add ocfs2_stack_user.ko to the Makefile so that it builds.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.4.1

