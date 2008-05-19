Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYESWRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYESWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765500AbYESWLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:11:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43185 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765291AbYESWLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:11:15 -0400
Date: Tue, 20 May 2008 01:09:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k: remove CVS keywords
Message-ID: <20080519220909.GU17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/sun3/idprom.c       |    2 +-
 arch/m68k/sun3/prom/Makefile  |    1 -
 arch/m68k/sun3/prom/console.c |    2 +-
 arch/m68k/sun3/prom/init.c    |    2 +-
 arch/m68k/sun3/prom/misc.c    |    2 +-
 arch/m68k/sun3/prom/printf.c  |    2 +-
 drivers/zorro/proc.c          |    2 --
 drivers/zorro/zorro.c         |    2 --
 drivers/zorro/zorro.ids       |    2 --
 include/asm-m68k/apollodma.h  |    2 +-
 include/asm-m68k/dvma.h       |    2 +-
 include/asm-m68k/machines.h   |    2 +-
 include/asm-m68k/md.h         |    2 +-
 include/asm-m68k/openprom.h   |    1 -
 include/asm-m68k/oplib.h      |    2 +-
 include/asm-m68k/sun3-head.h  |    1 -
 16 files changed, 10 insertions(+), 19 deletions(-)

ee8fd7a1ce8ef99adde70ee370963c29bebdde2a diff --git a/arch/m68k/sun3/idprom.c b/arch/m68k/sun3/idprom.c
index dca6ab6..6c5336d 100644
--- a/arch/m68k/sun3/idprom.c
+++ b/arch/m68k/sun3/idprom.c
@@ -1,4 +1,4 @@
-/* $Id: idprom.c,v 1.22 1996/11/13 05:09:25 davem Exp $
+/*
  * idprom.c: Routines to load the idprom into kernel addresses and
  *           interpret the data contained within.
  *
diff --git a/arch/m68k/sun3/prom/Makefile b/arch/m68k/sun3/prom/Makefile
index 6e48ae2..da7eac0 100644
--- a/arch/m68k/sun3/prom/Makefile
+++ b/arch/m68k/sun3/prom/Makefile
@@ -1,4 +1,3 @@
-# $Id: Makefile,v 1.5 1995/11/25 00:59:48 davem Exp $
 # Makefile for the Sun Boot PROM interface library under
 # Linux.
 #
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 52c1427..5812560 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -1,4 +1,4 @@
-/* $Id: console.c,v 1.10 1996/12/18 06:46:54 tridge Exp $
+/*
  * console.c: Routines that deal with sending and receiving IO
  *            to/from the current console device using the PROM.
  *
diff --git a/arch/m68k/sun3/prom/init.c b/arch/m68k/sun3/prom/init.c
index 202adfc..5f85681 100644
--- a/arch/m68k/sun3/prom/init.c
+++ b/arch/m68k/sun3/prom/init.c
@@ -1,4 +1,4 @@
-/* $Id: init.c,v 1.9 1996/12/18 06:46:55 tridge Exp $
+/*
  * init.c:  Initialize internal variables used by the PROM
  *          library functions.
  *
diff --git a/arch/m68k/sun3/prom/misc.c b/arch/m68k/sun3/prom/misc.c
index b88716f..3d60e13 100644
--- a/arch/m68k/sun3/prom/misc.c
+++ b/arch/m68k/sun3/prom/misc.c
@@ -1,4 +1,4 @@
-/* $Id: misc.c,v 1.15 1997/05/14 20:45:00 davem Exp $
+/*
  * misc.c:  Miscellaneous prom functions that don't belong
  *          anywhere else.
  *
diff --git a/arch/m68k/sun3/prom/printf.c b/arch/m68k/sun3/prom/printf.c
index e7bfde3..c8cf98d 100644
--- a/arch/m68k/sun3/prom/printf.c
+++ b/arch/m68k/sun3/prom/printf.c
@@ -1,4 +1,4 @@
-/* $Id: printf.c,v 1.5 1996/04/04 16:31:07 tridge Exp $
+/*
  * printf.c:  Internal prom library printf facility.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index 099b6fb..1f21240 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -1,6 +1,4 @@
 /*
- *	$Id: proc.c,v 1.1.2.1 1998/06/07 23:21:01 geert Exp $
- *
  *	Procfs interface for the Zorro bus.
  *
  *	Copyright (C) 1998-2003 Geert Uytterhoeven
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 4cc42b6..dff16d9 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -1,6 +1,4 @@
 /*
- *    $Id: zorro.c,v 1.1.2.1 1998/06/07 23:21:02 geert Exp $
- *
  *    Zorro Bus Services
  *
  *    Copyright (C) 1995-2003 Geert Uytterhoeven
diff --git a/drivers/zorro/zorro.ids b/drivers/zorro/zorro.ids
index 560fef2..0c0f99e 100644
--- a/drivers/zorro/zorro.ids
+++ b/drivers/zorro/zorro.ids
@@ -4,8 +4,6 @@
 #	Maintained by Geert Uytterhoeven <zorro@linux-m68k.org>
 #	If you have any new entries, please send them to the maintainer.
 #
-#	$Id: zorro.ids,v 1.19 2002/10/14 13:08:58 geert Exp $
-#
 
 # Manufacturers and Products. Please keep sorted.
 
diff --git a/include/asm-m68k/apollodma.h b/include/asm-m68k/apollodma.h
index 6821e3b..954adc8 100644
--- a/include/asm-m68k/apollodma.h
+++ b/include/asm-m68k/apollodma.h
@@ -1,4 +1,4 @@
-/* $Id: dma.h,v 1.7 1992/12/14 00:29:34 root Exp root $
+/*
  * linux/include/asm/dma.h: Defines for using and allocating dma channels.
  * Written by Hennus Bergman, 1992.
  * High DMA channel support & info by Hannu Savolainen
diff --git a/include/asm-m68k/dvma.h b/include/asm-m68k/dvma.h
index e1112de..5d28631 100644
--- a/include/asm-m68k/dvma.h
+++ b/include/asm-m68k/dvma.h
@@ -1,4 +1,4 @@
-/* $Id: dvma.h,v 1.4 1999/03/27 20:23:41 tsbogend Exp $
+/*
  * include/asm-m68k/dma.h
  *
  * Copyright 1995 (C) David S. Miller (davem@caip.rutgers.edu)
diff --git a/include/asm-m68k/machines.h b/include/asm-m68k/machines.h
index da6015a..748a786 100644
--- a/include/asm-m68k/machines.h
+++ b/include/asm-m68k/machines.h
@@ -1,4 +1,4 @@
-/* $Id: machines.h,v 1.4 1995/11/25 02:31:58 davem Exp $
+/*
  * machines.h:  Defines for taking apart the machine type value in the
  *              idprom and determining the kind of machine we are on.
  *
diff --git a/include/asm-m68k/md.h b/include/asm-m68k/md.h
index 467ea08..d2f78f2 100644
--- a/include/asm-m68k/md.h
+++ b/include/asm-m68k/md.h
@@ -1,4 +1,4 @@
-/* $Id: md.h,v 1.1 1997/12/15 15:12:04 jj Exp $
+/*
  * md.h: High speed xor_block operation for RAID4/5
  *
  */
diff --git a/include/asm-m68k/openprom.h b/include/asm-m68k/openprom.h
index 869ab91..d33cdad 100644
--- a/include/asm-m68k/openprom.h
+++ b/include/asm-m68k/openprom.h
@@ -1,4 +1,3 @@
-/* $Id: openprom.h,v 1.19 1996/09/25 03:51:08 davem Exp $ */
 #ifndef __SPARC_OPENPROM_H
 #define __SPARC_OPENPROM_H
 
diff --git a/include/asm-m68k/oplib.h b/include/asm-m68k/oplib.h
index 06caa2d..9c7953a 100644
--- a/include/asm-m68k/oplib.h
+++ b/include/asm-m68k/oplib.h
@@ -1,4 +1,4 @@
-/* $Id: oplib.h,v 1.12 1996/10/31 06:29:13 davem Exp $
+/*
  * oplib.h:  Describes the interface and available routines in the
  *           Linux Prom library.
  *
diff --git a/include/asm-m68k/sun3-head.h b/include/asm-m68k/sun3-head.h
index e74f384..05af2f1 100644
--- a/include/asm-m68k/sun3-head.h
+++ b/include/asm-m68k/sun3-head.h
@@ -1,4 +1,3 @@
-/* $Id: head.h,v 1.32 1996/12/04 00:12:48 ecd Exp $ */
 #ifndef __SUN3_HEAD_H
 #define __SUN3_HEAD_H
 

