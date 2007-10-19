Return-Path: <linux-kernel-owner+w=401wt.eu-S966494AbXJSDzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966494AbXJSDzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934401AbXJSDzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:55:39 -0400
Received: from rex.snapgear.com ([203.143.235.140]:43528 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934405AbXJSDzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:38 -0400
Date: Fri, 19 Oct 2007 13:55:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190355.l9J3tOoP004657@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove use of undefined symbol CONFIG_DISKtel (more)
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove use of undefined symbol CONFIG_DISKtel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/system.h linux-2.6.23-uc0/include/asm-m68knommu/system.h
--- linux-2.6.23/include/asm-m68knommu/system.h	2007-10-19 10:21:31.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/system.h	2007-10-19 10:32:28.000000000 +1000
@@ -253,8 +253,7 @@ cmpxchg(volatile int *p, int old, int ne
         ");				\
 })
 #elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+      defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 #define HARD_RESET_NOW() ({		\
         asm("				\
 	movew #0x2700, %sr;		\
