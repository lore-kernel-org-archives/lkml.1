Return-Path: <linux-kernel-owner+w=401wt.eu-S1030699AbXCNJFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699AbXCNJFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXCNJFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:05:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57603 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705AbXCNJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:04:53 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 4/13] (uml) sparse flags for userland glue are missing $(CF)
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPPf-0001tA-Of@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:04:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/scripts/Makefile.rules |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index 813077f..a9a4b85 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -10,7 +10,7 @@ USER_OBJS := $(foreach file,$(USER_OBJS),$(obj)/$(file))
 $(USER_OBJS:.o=.%): \
 	c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) $(CFLAGS_$(basetarget).o)
 $(USER_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
-	-Dunix -D__unix__ -D__$(SUBARCH)__
+	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
 # These are like USER_OBJS but filter USER_CFLAGS through unprofile instead of
 # using it directly.
@@ -19,7 +19,7 @@ UNPROFILE_OBJS := $(foreach file,$(UNPROFILE_OBJS),$(obj)/$(file))
 $(UNPROFILE_OBJS:.o=.%): \
 	c_flags = -Wp,-MD,$(depfile) $(call unprofile,$(USER_CFLAGS)) $(CFLAGS_$(basetarget).o)
 $(UNPROFILE_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
-	-Dunix -D__unix__ -D__$(SUBARCH)__
+	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
 # The stubs and unmap.o can't try to call mcount or update basic block data
 define unprofile
-- 
1.5.0-rc2.GIT


