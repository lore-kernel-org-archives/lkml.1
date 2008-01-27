Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYA0Mhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYA0Mhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYA0MfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:11 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:60764 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYA0Me6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:34:58 -0500
Message-Id: <20080127123357.908726834@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:23 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 07/14] m68k: kill arch/m68k/hp300/ksyms.c
Content-Disposition: inline; filename=m68k-kill-arch-m68k-hp300-ksyms-c.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

