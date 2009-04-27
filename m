Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbZD0TM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbZD0TM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZD0TKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:10:38 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:16335 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbZD0TKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:10:37 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
Date: Mon, 27 Apr 2009 15:10:35 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Subject: Fwd:
To: linux-kernel@vger.kernel.org
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-disposition: inline
Message-id: <200904271510.35844.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: 
Date: Monday 27 April 2009
From: arnd@arndb.de
To: "no To-header on input" <unlisted-recipients:; @gmail-pop.l.google.com>

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:13 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>,
 Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 03/17] asm-generic: rename mman.h to mman-common.h
Content-Disposition: inline; filename=0018-asm-generic-make-generic-mman.h-
header-generic.patch
X-Provags-ID: V01U2FsdGVkX18Xnuysx4P/H1PKB8mb4S4lLJMdyLe5LlF6OUh
 uTtfXAZra+pmP0gOZM6rzVh4tacTrkmdtFLejvlgSM/Qgihyd6
 qGAlBbr5jRJrP5qkXAUFA==

The existing asm-generic/mman.h is incomplete and included
by some architectures. New architectures should be able
to use a generic version, so rename the existing file and
change all users, which lets us add the new file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/arm/include/asm/mman.h       |    2 	1 +	1 -	0 !
 arch/avr32/include/asm/mman.h     |    2 	1 +	1 -	0 !
 arch/cris/include/asm/mman.h      |    2 	1 +	1 -	0 !
 arch/frv/include/asm/mman.h       |    2 	1 +	1 -	0 !
 arch/h8300/include/asm/mman.h     |    2 	1 +	1 -	0 !
 arch/ia64/include/asm/mman.h      |    2 	1 +	1 -	0 !
 arch/m32r/include/asm/mman.h      |    2 	1 +	1 -	0 !
 arch/m68k/include/asm/mman.h      |    2 	1 +	1 -	0 !
 arch/mn10300/include/asm/mman.h   |    2 	1 +	1 -	0 !
 arch/powerpc/include/asm/mman.h   |    2 	1 +	1 -	0 !
 arch/s390/include/asm/mman.h      |    2 	1 +	1 -	0 !
 arch/sh/include/asm/mman.h        |    2 	1 +	1 -	0 !
 arch/sparc/include/asm/mman.h     |    2 	1 +	1 -	0 !
 arch/x86/include/asm/mman.h       |    2 	1 +	1 -	0 !
 include/asm-generic/Kbuild        |    2 	1 +	1 -	0 !
 include/asm-generic/mman-common.h |   41 	41 +	0 -	0 !
 include/asm-generic/mman.h        |   41 	0 +	41 -	0 !
 17 files changed, 56 insertions(+), 56 deletions(-)
 create mode 100644 include/asm-generic/mman-common.h

Index: linux-2.6/arch/arm/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mman.h
+++ linux-2.6/arch/arm/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ARM_MMAN_H__
 #define __ARM_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/avr32/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/mman.h
+++ linux-2.6/arch/avr32/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_AVR32_MMAN_H__
 #define __ASM_AVR32_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/cris/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/mman.h
+++ linux-2.6/arch/cris/include/asm/mman.h
@@ -3,7 +3,7 @@
 
 /* verbatim copy of asm-i386/ version */
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/frv/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/mman.h
+++ linux-2.6/arch/frv/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_MMAN_H__
 #define __ASM_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/h8300/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/mman.h
+++ linux-2.6/arch/h8300/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __H8300_MMAN_H__
 #define __H8300_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/ia64/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/mman.h
+++ linux-2.6/arch/ia64/include/asm/mman.h
@@ -8,7 +8,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x00100		/* stack-like segment */
 #define MAP_GROWSUP	0x00200		/* register stack-like segment */
Index: linux-2.6/arch/m68k/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/mman.h
+++ linux-2.6/arch/m68k/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __M68K_MMAN_H__
 #define __M68K_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/mn10300/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/mman.h
+++ linux-2.6/arch/mn10300/include/asm/mman.h
@@ -12,7 +12,7 @@
 #ifndef _ASM_MMAN_H
 #define _ASM_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/powerpc/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/mman.h
+++ linux-2.6/arch/powerpc/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_POWERPC_MMAN_H
 #define _ASM_POWERPC_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 /*
  * This program is free software; you can redistribute it and/or
Index: linux-2.6/arch/s390/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/mman.h
+++ linux-2.6/arch/s390/include/asm/mman.h
@@ -9,7 +9,7 @@
 #ifndef __S390_MMAN_H__
 #define __S390_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/sh/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/mman.h
+++ linux-2.6/arch/sh/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_MMAN_H
 #define __ASM_SH_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/arch/sparc/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/mman.h
+++ linux-2.6/arch/sparc/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __SPARC_MMAN_H__
 #define __SPARC_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 /* SunOS'ified... */
 
Index: linux-2.6/arch/x86/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mman.h
+++ linux-2.6/arch/x86/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_MMAN_H
 #define _ASM_X86_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
Index: linux-2.6/include/asm-generic/mman-common.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/mman-common.h
@@ -0,0 +1,41 @@
+#ifndef __ASM_GENERIC_MMAN_COMMON_H
+#define __ASM_GENERIC_MMAN_COMMON_H
+
+/*
+ Author: Michael S. Tsirkin <mst@mellanox.co.il>, Mellanox Technologies Ltd.
+ Based on: asm-xxx/mman.h
+*/
+
+#define PROT_READ	0x1		/* page can be read */
+#define PROT_WRITE	0x2		/* page can be written */
+#define PROT_EXEC	0x4		/* page can be executed */
+#define PROT_SEM	0x8		/* page may be used for atomic ops */
+#define PROT_NONE	0x0		/* page can not be accessed */
+#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of 
growsdown vma */
+#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of 
growsup vma */
+
+#define MAP_SHARED	0x01		/* Share changes */
+#define MAP_PRIVATE	0x02		/* Changes are private */
+#define MAP_TYPE	0x0f		/* Mask for type of mapping */
+#define MAP_FIXED	0x10		/* Interpret addr exactly */
+#define MAP_ANONYMOUS	0x20		/* don't use a file */
+
+#define MS_ASYNC	1		/* sync memory asynchronously */
+#define MS_INVALIDATE	2		/* invalidate the caches */
+#define MS_SYNC		4		/* synchronous memory sync */
+
+#define MADV_NORMAL	0		/* no further special treatment */
+#define MADV_RANDOM	1		/* expect random page references */
+#define MADV_SEQUENTIAL	2		/* expect sequential page references */
+#define MADV_WILLNEED	3		/* will need these pages */
+#define MADV_DONTNEED	4		/* don't need these pages */
+
+/* common parameters: try to keep these consistent across architectures */
+#define MADV_REMOVE	9		/* remove these pages & resources */
+#define MADV_DONTFORK	10		/* don't inherit across fork */
+#define MADV_DOFORK	11		/* do inherit across fork */
+
+/* compatibility flags */
+#define MAP_FILE	0
+
+#endif /* __ASM_GENERIC_MMAN_COMMON_H */
Index: linux-2.6/include/asm-generic/mman.h
===================================================================
--- linux-2.6.orig/include/asm-generic/mman.h
+++ /dev/null
@@ -1,41 +0,0 @@
-#ifndef _ASM_GENERIC_MMAN_H
-#define _ASM_GENERIC_MMAN_H
-
-/*
- Author: Michael S. Tsirkin <mst@mellanox.co.il>, Mellanox Technologies Ltd.
- Based on: asm-xxx/mman.h
-*/
-
-#define PROT_READ	0x1		/* page can be read */
-#define PROT_WRITE	0x2		/* page can be written */
-#define PROT_EXEC	0x4		/* page can be executed */
-#define PROT_SEM	0x8		/* page may be used for atomic ops */
-#define PROT_NONE	0x0		/* page can not be accessed */
-#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of 
growsdown vma */
-#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of 
growsup vma */
-
-#define MAP_SHARED	0x01		/* Share changes */
-#define MAP_PRIVATE	0x02		/* Changes are private */
-#define MAP_TYPE	0x0f		/* Mask for type of mapping */
-#define MAP_FIXED	0x10		/* Interpret addr exactly */
-#define MAP_ANONYMOUS	0x20		/* don't use a file */
-
-#define MS_ASYNC	1		/* sync memory asynchronously */
-#define MS_INVALIDATE	2		/* invalidate the caches */
-#define MS_SYNC		4		/* synchronous memory sync */
-
-#define MADV_NORMAL	0		/* no further special treatment */
-#define MADV_RANDOM	1		/* expect random page references */
-#define MADV_SEQUENTIAL	2		/* expect sequential page references */
-#define MADV_WILLNEED	3		/* will need these pages */
-#define MADV_DONTNEED	4		/* don't need these pages */
-
-/* common parameters: try to keep these consistent across architectures */
-#define MADV_REMOVE	9		/* remove these pages & resources */
-#define MADV_DONTFORK	10		/* don't inherit across fork */
-#define MADV_DOFORK	11		/* do inherit across fork */
-
-/* compatibility flags */
-#define MAP_FILE	0
-
-#endif
Index: linux-2.6/arch/m32r/include/asm/mman.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/mman.h
+++ linux-2.6/arch/m32r/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __M32R_MMAN_H__
 #define __M32R_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -2,7 +2,7 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
-header-y += mman.h
+header-y += mman-common.h
 header-y += poll.h
 header-y += signal-defs.h
 header-y += statfs.h

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Backed up the system lately?

