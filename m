Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbZDIMQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbZDIMQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbZDIMPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:15:40 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:48847 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbZDIMPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:15:38 -0400
X-Greylist: delayed 2534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 08:15:38 EDT
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       navy-patches@mns.spb.ru, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH] Makefile: fix few typos
Date: Thu,  9 Apr 2009 15:34:34 +0400
Message-Id: <1239276874-2141-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.6.2.2.471.g6da14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e5ad5fd..3e95d45 100644
--- a/Makefile
+++ b/Makefile
@@ -567,7 +567,7 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
-# disable invalid "can't wrap" optimzations for signed / pointers
+# disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
 
 # revert to pre-gcc-4.4 behaviour of .eh_frame
@@ -1587,5 +1587,5 @@ PHONY += FORCE
 FORCE:
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
-# information in a variable se we can use it in if_changed and friends.
+# information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
-- 
1.6.2.2.471.g6da14

