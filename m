Return-Path: <linux-kernel-owner+w=401wt.eu-S939831AbXGaAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939831AbXGaAvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763966AbXGaAvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:51:44 -0400
Received: from rex.snapgear.com ([203.143.235.140]:51252 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759502AbXGaAvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:51:43 -0400
Date: Tue, 31 Jul 2007 10:50:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707310050.l6V0onaL007626@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU] remove unused config symbol CONFIG_DISKtel
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused config symbol CONFIG_DISKtel.
Pointed out by Robert P. J. Day <rpjday@mindspring.com>.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/include/asm-m68knommu/system.h linux-2.6.22-uc1/include/asm-m68knommu/system.h
--- linux-2.6.22/include/asm-m68knommu/system.h	2007-07-26 16:02:01.000000000 +1000
+++ linux-2.6.22-uc1/include/asm-m68knommu/system.h	2007-07-26 16:06:17.000000000 +1000
@@ -253,8 +253,7 @@
         ");				\
 })
 #elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+      defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 #define HARD_RESET_NOW() ({		\
         asm("				\
 	movew #0x2700, %sr;		\
