Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbXKRKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbXKRKTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXKRKPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:42 -0500
Received: from adicia.telenet-ops.be ([195.130.132.56]:35056 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbXKRKPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:19 -0500
Message-Id: <20071118101449.090712866@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:47 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 11/13] mac68k: remove dead code
Content-Disposition: inline; filename=mac68k-remove-dead-code.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Remove dead code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/config.c       |    2 --
 include/asm-m68k/macintosh.h |    2 --
 2 files changed, 4 deletions(-)

--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -58,8 +58,6 @@ extern struct mem_info m68k_memory[NUM_M
 
 extern struct mem_info m68k_ramdisk;
 
-extern char m68k_command_line[CL_SIZE];
-
 void *mac_env;					/* Loaded by the boot asm */
 
 /* The phys. video addr. - might be bogus on some machines */
--- a/include/asm-m68k/macintosh.h
+++ b/include/asm-m68k/macintosh.h
@@ -14,8 +14,6 @@ extern void mac_init_IRQ(void);
 extern int mac_irq_pending(unsigned int);
 extern void mac_identify(void);
 extern void mac_report_hardware(void);
-extern void mac_debugging_penguin(int);
-extern void mac_boom(int);
 
 /*
  *	Floppy driver magic hook - probably shouldnt be here

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

