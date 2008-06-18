Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYFRSxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYFRSxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYFRSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:53:40 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:35573 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYFRSxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SDHpdD+ysxy+AuQGaYyK0ChQ5GigoyxJ7/JqT+z1oUzxfm2gr+557F0gLaLKBKP2dN
         TOKS7iVlxp52M/6ugM9A1jnJ37xgRDmK3bZcld1clAOZPeKXvs4oy4ytFM1Hi47UHF0e
         qIeJYBqoRG/Ekiu8DHDVBAxpxPMmx0yVk23X8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove unused file after numaq etc depends on genericarch
Date: Wed, 18 Jun 2008 11:54:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806171539.01555.yhlu.kernel@gmail.com>
In-Reply-To: <200806171539.01555.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181154.37444.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we don't need those mach_mpsech.h now.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/asm-x86/mach-bigsmp/mach_mpspec.h |    8 --------
 include/asm-x86/mach-es7000/mach_mpspec.h |    8 --------
 include/asm-x86/mach-numaq/mach_mpspec.h  |    8 --------
 include/asm-x86/mach-summit/mach_mpspec.h |    9 ---------
 4 files changed, 33 deletions(-)

Index: linux-2.6/include/asm-x86/mach-bigsmp/mach_mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-bigsmp/mach_mpspec.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __ASM_MACH_MPSPEC_H
-#define __ASM_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 256
-
-#define MAX_MP_BUSSES 32
-
-#endif /* __ASM_MACH_MPSPEC_H */
Index: linux-2.6/include/asm-x86/mach-es7000/mach_mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_mpspec.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __ASM_MACH_MPSPEC_H
-#define __ASM_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 256
-
-#define MAX_MP_BUSSES 256
-
-#endif /* __ASM_MACH_MPSPEC_H */
Index: linux-2.6/include/asm-x86/mach-numaq/mach_mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_mpspec.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __ASM_MACH_MPSPEC_H
-#define __ASM_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 512
-
-#define MAX_MP_BUSSES 32
-
-#endif /* __ASM_MACH_MPSPEC_H */
Index: linux-2.6/include/asm-x86/mach-summit/mach_mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/mach_mpspec.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_MACH_MPSPEC_H
-#define __ASM_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 256
-
-/* Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets. */
-#define MAX_MP_BUSSES 260
-
-#endif /* __ASM_MACH_MPSPEC_H */
