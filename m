Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbYBLGUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbYBLGUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYBLGTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:19:54 -0500
Received: from rex.snapgear.com ([203.143.235.140]:50364 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753207AbYBLGTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:19:53 -0500
Date: Tue, 12 Feb 2008 16:16:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802120616.m1C6GshP009991@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use tabs not spaces in cacheflush.h
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tabs instead of spaces.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/include/asm-m68knommu/cacheflush.h linux-2.6.x/include/asm-m68knommu/cacheflush.h
--- linux-2.6.25-rc1/include/asm-m68knommu/cacheflush.h	2008-02-11 14:50:23.000000000 +1000
+++ linux-2.6.x/include/asm-m68knommu/cacheflush.h	2008-02-12 13:58:55.000000000 +1000
@@ -54,28 +54,28 @@ static inline void __flush_cache_all(voi
 #if defined(CONFIG_M527x) || defined(CONFIG_M528x)
 	__asm__ __volatile__ (
 		"movel	#0x81000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M527x || CONFIG_M528x */
 #if defined(CONFIG_M5206) || defined(CONFIG_M5206e) || defined(CONFIG_M5272)
 	__asm__ __volatile__ (
-        	"movel	#0x81000100, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0x81000100, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M5206 || CONFIG_M5206e || CONFIG_M5272 */
 #ifdef CONFIG_M5249
 	__asm__ __volatile__ (
-        	"movel	#0xa1000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0xa1000200, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M5249 */
 #ifdef CONFIG_M532x
 	__asm__ __volatile__ (
-        	"movel	#0x81000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0x81000200, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M532x */
