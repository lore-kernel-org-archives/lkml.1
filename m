Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbYDVR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbYDVR3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbYDVR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:10 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53793 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbYDVR3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:08 -0400
Message-Id: <20080422172840.765241303@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
Subject: [RFC patch 2/9] M32R remove -traditional
Content-Disposition: inline; filename=m32r-remove-traditional.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC patch 2/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: takata@linux-m32r.org
CC: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/boot/compressed/Makefile |    1 -
 arch/m32r/kernel/Makefile          |    2 --
 2 files changed, 3 deletions(-)

Index: linux-2.6-lttng/arch/m32r/boot/compressed/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/boot/compressed/Makefile	2008-04-21 09:57:01.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/boot/compressed/Makefile	2008-04-21 09:57:09.000000000 -0400
@@ -6,7 +6,6 @@
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o \
 		   piggy.o vmlinux.lds
-EXTRA_AFLAGS	:= -traditional
 
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 
Index: linux-2.6-lttng/arch/m32r/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/kernel/Makefile	2008-04-21 09:57:16.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/kernel/Makefile	2008-04-21 09:57:22.000000000 -0400
@@ -9,5 +9,3 @@ obj-y	:= process.o entry.o traps.o align
 
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o
 obj-$(CONFIG_MODULES)		+= module.o
-
-EXTRA_AFLAGS	:= -traditional

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
