Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYERTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYERTDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbYERSyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:15 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:57707 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759965AbYERSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:02 -0400
Message-Id: <20080518185153.147231182@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:20 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 14/18] m68k: export m68k_mmutype
Content-Disposition: inline; filename=m68k-export-m68k_mmutype.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

UIO needs m68k_mmutype:

ERROR: "m68k_mmutype" [drivers/uio/uio.ko] undefined!

(noticed by Christian T. Steigies)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    3 ++-
 include/asm-m68k/setup.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -41,11 +41,12 @@
 #endif
 
 unsigned long m68k_machtype;
-unsigned long m68k_cputype;
 EXPORT_SYMBOL(m68k_machtype);
+unsigned long m68k_cputype;
 EXPORT_SYMBOL(m68k_cputype);
 unsigned long m68k_fputype;
 unsigned long m68k_mmutype;
+EXPORT_SYMBOL(m68k_mmutype);
 #ifdef CONFIG_VME
 unsigned long vme_brdtype;
 EXPORT_SYMBOL(vme_brdtype);
--- a/include/asm-m68k/setup.h
+++ b/include/asm-m68k/setup.h
@@ -248,7 +248,7 @@ extern unsigned long m68k_machtype;
 #ifndef __ASSEMBLY__
 extern unsigned long m68k_cputype;
 extern unsigned long m68k_fputype;
-extern unsigned long m68k_mmutype;		/* Not really used yet */
+extern unsigned long m68k_mmutype;
 #ifdef CONFIG_VME
 extern unsigned long vme_brdtype;
 #endif

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

