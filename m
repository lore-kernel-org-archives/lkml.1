Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXGMESW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXGMESW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXGMESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:18:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59743 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbXGMESN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:18:13 -0400
Date: Fri, 13 Jul 2007 06:18:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] Makefile: use -fno-optimize-sibling-calls
	unconditionally
Message-ID: <20070713041847.GZ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to check for -fno-optimize-sibling-calls since even
gcc 3.2 supports it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/Makefile.old	2007-07-13 06:01:20.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Makefile	2007-07-13 06:01:44.000000000 +0200
@@ -493,7 +493,7 @@
 include $(srctree)/arch/$(ARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
-CFLAGS		+= -fno-omit-frame-pointer $(call cc-option,-fno-optimize-sibling-calls,)
+CFLAGS		+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
 CFLAGS		+= -fomit-frame-pointer
 endif

