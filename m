Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbYDVR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbYDVR35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763225AbYDVR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53803 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762712AbYDVR3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:10 -0400
Message-Id: <20080422172841.628270745@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, geert@linux-m68k.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: [RFC patch 4/9] M68K remove -traditional
Content-Disposition: inline; filename=m68k-remove-traditional.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC patch 4/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

(cross-compile test ok)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: geert@linux-m68k.org
CC: zippel@linux-m68k.org
CC: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/fpsp040/Makefile  |    1 -
 arch/m68k/ifpsp060/Makefile |    1 -
 arch/m68k/kernel/Makefile   |    2 --
 arch/m68k/lib/Makefile      |    2 --
 arch/m68k/math-emu/Makefile |    2 --
 5 files changed, 8 deletions(-)

Index: linux-2.6-lttng/arch/m68k/fpsp040/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/fpsp040/Makefile	2008-04-21 09:59:58.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/fpsp040/Makefile	2008-04-21 10:00:05.000000000 -0400
@@ -10,7 +10,6 @@ obj-y    := bindec.o binstr.o decbin.o d
 	    x_bsun.o x_fline.o x_operr.o x_ovfl.o x_snan.o x_store.o \
 	    x_unfl.o x_unimp.o x_unsupp.o bugfix.o skeleton.o
 
-EXTRA_AFLAGS := -traditional
 EXTRA_LDFLAGS := -x
 
 $(OS_OBJS): fpsp.h
Index: linux-2.6-lttng/arch/m68k/ifpsp060/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/ifpsp060/Makefile	2008-04-21 10:00:10.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/ifpsp060/Makefile	2008-04-21 10:00:15.000000000 -0400
@@ -6,5 +6,4 @@
 
 obj-y := fskeleton.o iskeleton.o os.o
 
-EXTRA_AFLAGS := -traditional
 EXTRA_LDFLAGS := -x
Index: linux-2.6-lttng/arch/m68k/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/kernel/Makefile	2008-04-21 10:00:19.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/kernel/Makefile	2008-04-21 10:00:24.000000000 -0400
@@ -16,5 +16,3 @@ devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI)	+= bios32.o
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
-
-EXTRA_AFLAGS := -traditional
Index: linux-2.6-lttng/arch/m68k/lib/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/lib/Makefile	2008-04-21 10:00:29.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/lib/Makefile	2008-04-21 10:00:34.000000000 -0400
@@ -2,7 +2,5 @@
 # Makefile for m68k-specific library files..
 #
 
-EXTRA_AFLAGS := -traditional
-
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
 	   checksum.o string.o semaphore.o uaccess.o
Index: linux-2.6-lttng/arch/m68k/math-emu/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/math-emu/Makefile	2008-04-21 10:00:38.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/math-emu/Makefile	2008-04-21 10:00:43.000000000 -0400
@@ -2,8 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_AFLAGS := -traditional
-
 #EXTRA_AFLAGS += -DFPU_EMU_DEBUG
 #EXTRA_CFLAGS += -DFPU_EMU_DEBUG
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
