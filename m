Return-Path: <linux-kernel-owner+w=401wt.eu-S1946485AbXEAEFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946485AbXEAEFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXEAEBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:60937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946488AbXEAD6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:15 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [16/30] i386: Add X86_FEATURE_RDTSCP
Message-Id: <20070501035814.304CB13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Following x86-64
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/cpufeature.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -52,6 +52,7 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
 #define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
