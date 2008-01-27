Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYA0MjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYA0MjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYA0MfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:23 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:59381 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYA0MfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:35:00 -0500
Message-Id: <20080127123359.546594551@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:28 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 12/14] mac68k: remove dead code
Content-Disposition: inline; filename=mac68k-remove-dead-code.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

