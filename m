Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbYGGWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbYGGWDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYGGWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12844 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298AbYGGWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=UHdOe2/syyKP7MShFJ5gZNK3PpXVpPQiS00qrUSPf3ZGRpkB25o9vnccQCc4tRY8a4
         WpfiQoURhYi9oJ1a5aUrE+OJ0dzkl+CLjLBOYlOGoa6BgYbsgTqO6vn9PFAbMYgRobxL
         rinA+fUq4/JNvOImLjoQgrT3CTHKXubdJM0qo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 10/10] ide: remove <asm/ide.h> for some archs
Date: Mon, 7 Jul 2008 23:58:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072358.25962.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove <linux/irq.h> include from <asm-ia64.h> (<linux/ide.h> includes
  <linux/interrupt.h> which is enough).

* Remove <asm/ide.h> for alpha/blackfin/h8300/ia64/m32r/sh/x86/xtensa
  (this leaves us with arm/frv/m68k/mips/mn10300/parisc/powerpc/sparc[64]).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-alpha/ide.h    |   20 --------------------
 include/asm-blackfin/ide.h |   25 -------------------------
 include/asm-h8300/ide.h    |   24 ------------------------
 include/asm-ia64/ide.h     |   22 ----------------------
 include/asm-m32r/ide.h     |   20 --------------------
 include/asm-sh/ide.h       |   21 ---------------------
 include/asm-x86/ide.h      |   18 ------------------
 include/asm-xtensa/ide.h   |   21 ---------------------
 include/linux/ide.h        |    6 ++++++
 9 files changed, 6 insertions(+), 171 deletions(-)

Index: b/include/asm-alpha/ide.h
===================================================================
--- a/include/asm-alpha/ide.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- *  linux/include/asm-alpha/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the alpha architecture specific IDE code.
- */
-
-#ifndef __ASMalpha_IDE_H
-#define __ASMalpha_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMalpha_IDE_H */
Index: b/include/asm-blackfin/ide.h
===================================================================
--- a/include/asm-blackfin/ide.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/****************************************************************************/
-
-/*
- *  linux/include/asm-blackfin/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- *  Copyright (C) 2001       Lineo Inc., davidm@snapgear.com
- *  Copyright (C) 2002       Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 2002       Yoshinori Sato (ysato@users.sourceforge.jp)
- *  Copyright (C) 2005       Hennerich Michael (hennerich@blackfin.uclinux.org)
- */
-
-/****************************************************************************/
-#ifndef _BLACKFIN_IDE_H
-#define _BLACKFIN_IDE_H
-/****************************************************************************/
-#ifdef __KERNEL__
-/****************************************************************************/
-
-#include <asm-generic/ide_iops.h>
-
-/****************************************************************************/
-#endif				/* __KERNEL__ */
-#endif				/* _BLACKFIN_IDE_H */
-/****************************************************************************/
Index: b/include/asm-h8300/ide.h
===================================================================
--- a/include/asm-h8300/ide.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/****************************************************************************/
-
-/*
- *  linux/include/asm-h8300/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- *  Copyright (C) 2001       Lineo Inc., davidm@snapgear.com
- *  Copyright (C) 2002       Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 2002       Yoshinori Sato (ysato@users.sourceforge.jp)
- */
-
-/****************************************************************************/
-#ifndef _H8300_IDE_H
-#define _H8300_IDE_H
-/****************************************************************************/
-#ifdef __KERNEL__
-/****************************************************************************/
-
-#include <asm-generic/ide_iops.h>
-
-/****************************************************************************/
-#endif /* __KERNEL__ */
-#endif /* _H8300_IDE_H */
-/****************************************************************************/
Index: b/include/asm-ia64/ide.h
===================================================================
--- a/include/asm-ia64/ide.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- *  linux/include/asm-ia64/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the ia64 architecture specific IDE code.
- */
-
-#ifndef __ASM_IA64_IDE_H
-#define __ASM_IA64_IDE_H
-
-#ifdef __KERNEL__
-
-#include <linux/irq.h>
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASM_IA64_IDE_H */
Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_M32R_IDE_H
-#define _ASM_M32R_IDE_H
-
-/*
- *  linux/include/asm-m32r/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- */
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_M32R_IDE_H */
Index: b/include/asm-sh/ide.h
===================================================================
--- a/include/asm-sh/ide.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- *  linux/include/asm-sh/ide.h
- *
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- *  In future, SuperH code.
- */
-
-#ifndef __ASM_SH_IDE_H
-#define __ASM_SH_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASM_SH_IDE_H */
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- *  Copyright (C) 1994-1996  Linus Torvalds & authors
- */
-
-/*
- *  This file contains the i386 architecture specific IDE code.
- */
-
-#ifndef __ASMi386_IDE_H
-#define __ASMi386_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASMi386_IDE_H */
Index: b/include/asm-xtensa/ide.h
===================================================================
--- a/include/asm-xtensa/ide.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * include/asm-xtensa/ide.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1994 - 1996  Linus Torvalds & authors
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_IDE_H
-#define _XTENSA_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm-generic/ide_iops.h>
-
-#endif	/* __KERNEL__ */
-
-#endif	/* _XTENSA_IDE_H */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -211,7 +211,13 @@ static inline int __ide_default_irq(unsi
 	return 0;
 }
 
+#if defined(CONFIG_ARM) || defined(CONFIG_FRV) || defined(CONFIG_M68K) || \
+    defined(CONFIG_MIPS) || defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
+    || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || defined(CONFIG_SPARC64)
 #include <asm/ide.h>
+#else
+#include <asm-generic/ide_iops.h>
+#endif
 
 #ifndef MAX_HWIFS
 #if defined(CONFIG_BLACKFIN) || defined(CONFIG_H8300) || defined(CONFIG_XTENSA)
