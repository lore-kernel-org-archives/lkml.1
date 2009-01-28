Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZA1Xmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZA1Xmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA1Xm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:42:26 -0500
Received: from gw.goop.org ([64.81.55.164]:57241 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZA1XmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:42:25 -0500
Message-ID: <4980ED5F.30904@goop.org>
Date: Wed, 28 Jan 2009 15:42:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: unify asm/io.h: IO_SPACE_LIMIT
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io.h    |    1 +
 arch/x86/include/asm/io_32.h |    2 --
 arch/x86/include/asm/io_64.h |    2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

===================================================================
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -105,5 +105,6 @@
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
+#define IO_SPACE_LIMIT 0xffff
 
 #endif /* _ASM_X86_IO_H */
===================================================================
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -37,8 +37,6 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define IO_SPACE_LIMIT 0xffff
-
 #define XQUAD_PORTIO_BASE 0xfe400000
 #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
 
===================================================================
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -136,8 +136,6 @@
 __OUTS(w)
 __OUTS(l)
 
-#define IO_SPACE_LIMIT 0xffff
-
 #if defined(__KERNEL__) && defined(__x86_64__)
 
 #include <linux/vmalloc.h>

