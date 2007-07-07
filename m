Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXGGBDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXGGBDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbXGGBDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:03:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53158 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753507AbXGGBC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:02:59 -0400
Date: Sat, 7 Jul 2007 03:03:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/asm-mips/processor.h: "extern inline" ->
	"static inline"
Message-ID: <20070707010330.GY3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3,
and "static inline" is correct here.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/include/asm-mips/processor.h.old	2007-07-07 01:06:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-mips/processor.h	2007-07-07 01:06:57.000000000 +0200
@@ -237,7 +237,7 @@
 
 #define ARCH_HAS_PREFETCH
 
-extern inline void prefetch(const void *addr)
+static inline void prefetch(const void *addr)
 {
 	__asm__ __volatile__(
 	"	.set	mips4		\n"

