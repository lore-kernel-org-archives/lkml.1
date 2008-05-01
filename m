Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbYEACUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbYEACUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbYEACR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:57 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45766 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759881AbYEACR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:56 -0400
Date: Thu, 1 May 2008 12:17:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010217.m412HLoj004138@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: remove unused CONFIG_DISKtel
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused CONFIG_DISKtel support.
Missing config definition pointed out by
Robert P. J. Day <rpjday@mindspring.com>

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/platform/5307/config.c linux-2.6.25-uc0/arch/m68knommu/platform/5307/config.c
--- linux-2.6.25/arch/m68knommu/platform/5307/config.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/platform/5307/config.c	2008-01-11 13:37:38.000000000 +1000
@@ -124,8 +124,7 @@ void __init config_BSP(char *commandp, i
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
 #if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+    defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
