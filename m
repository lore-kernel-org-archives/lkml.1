Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbYGQTZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbYGQTZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbYGQTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:55 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:52624 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbYGQTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:45 -0400
Message-Id: <20080717191751.090161391@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:13 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 06/29] m68k: remove -traditional
Content-Disposition: inline; filename=m68k-remove-traditional.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Subject: [patch 06/29] [RFC patch 4/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/fpsp040/Makefile  |    1 -
 arch/m68k/ifpsp060/Makefile |    1 -
 arch/m68k/kernel/Makefile   |    2 --
 arch/m68k/lib/Makefile      |    2 --
 arch/m68k/math-emu/Makefile |    2 --
 5 files changed, 8 deletions(-)

--- a/arch/m68k/fpsp040/Makefile
+++ b/arch/m68k/fpsp040/Makefile
@@ -10,7 +10,6 @@ obj-y    := bindec.o binstr.o decbin.o d
 	    x_bsun.o x_fline.o x_operr.o x_ovfl.o x_snan.o x_store.o \
 	    x_unfl.o x_unimp.o x_unsupp.o bugfix.o skeleton.o
 
-EXTRA_AFLAGS := -traditional
 EXTRA_LDFLAGS := -x
 
 $(OS_OBJS): fpsp.h
--- a/arch/m68k/ifpsp060/Makefile
+++ b/arch/m68k/ifpsp060/Makefile
@@ -6,5 +6,4 @@
 
 obj-y := fskeleton.o iskeleton.o os.o
 
-EXTRA_AFLAGS := -traditional
 EXTRA_LDFLAGS := -x
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -16,5 +16,3 @@ devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI)	+= bios32.o
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
-
-EXTRA_AFLAGS := -traditional
--- a/arch/m68k/lib/Makefile
+++ b/arch/m68k/lib/Makefile
@@ -2,7 +2,5 @@
 # Makefile for m68k-specific library files..
 #
 
-EXTRA_AFLAGS := -traditional
-
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
 	   checksum.o string.o uaccess.o
--- a/arch/m68k/math-emu/Makefile
+++ b/arch/m68k/math-emu/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_AFLAGS := -traditional
-
 #EXTRA_AFLAGS += -DFPU_EMU_DEBUG
 #EXTRA_CFLAGS += -DFPU_EMU_DEBUG
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

