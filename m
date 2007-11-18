Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbXKRKRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbXKRKRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXKRKP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:28 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:37818 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXKRKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:16 -0500
Message-Id: <20071118101447.787517062@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:42 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 06/13] m68k: kill arch/m68k/hp300/ksyms.c
Content-Disposition: inline; filename=m68k-kill-arch-m68k-hp300-ksyms-c.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

m68k: kill arch/m68k/hp300/ksyms.c

It was empty.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/hp300/Makefile |    2 +-
 arch/m68k/hp300/ksyms.c  |    9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/arch/m68k/hp300/Makefile
+++ b/arch/m68k/hp300/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/hp300 source directory
 #
 
-obj-y		:= ksyms.o config.o time.o reboot.o
+obj-y		:= config.o time.o reboot.o
--- a/arch/m68k/hp300/ksyms.c
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- *  linux/arch/m68k/hp300/ksyms.c
- *
- *  Copyright (C) 1998 Philip Blundell <philb@gnu.org>
- *
- *  This file contains the HP300-specific kernel symbols.  None yet. :-)
- */
-
-#include <linux/module.h>

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

