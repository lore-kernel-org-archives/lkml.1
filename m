Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYEDWjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYEDWjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYEDWjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:39:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667AbYEDWi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:38:59 -0400
Date: Sun, 4 May 2008 15:38:40 -0700
Message-Id: <200805042238.m44Mcexm017850@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ralf Baechle <ralf@linux-mips.org>, Richard Henderson <rth@twiddle.net>,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] types.h fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull:

    git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

Adrian Bunk (2):
      fix asm-alpha/types.h breakage
      fix asm-mips/types.h syntax error


diff --git a/include/asm-alpha/types.h b/include/asm-alpha/types.h
index a9e34ca..c154135 100644
--- a/include/asm-alpha/types.h
+++ b/include/asm-alpha/types.h
@@ -23,5 +23,11 @@ typedef unsigned int umode_t;
 
 #define BITS_PER_LONG 64
 
+#ifndef __ASSEMBLY__
+
+typedef u64 dma_addr_t;
+typedef u64 dma64_addr_t;
+
+#endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_TYPES_H */
diff --git a/include/asm-mips/types.h b/include/asm-mips/types.h
index 7a2ee4f..bcbb8d6 100644
--- a/include/asm-mips/types.h
+++ b/include/asm-mips/types.h
@@ -19,8 +19,6 @@
 
 typedef unsigned short umode_t;
 
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 /*
