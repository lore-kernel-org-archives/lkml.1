Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbYDVRbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbYDVRbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763228AbYDVR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53817 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829AbYDVR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:11 -0400
Message-Id: <20080422172840.383879948@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, starvik@axis.com,
       jesper.nilsson@axis.com, dev-etrax@axis.com
Subject: [RFC patch 1/9] CRIS remove -traditional
Content-Disposition: inline; filename=cris-remove-traditional.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC patch 1/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: starvik@axis.com
CC: jesper.nilsson@axis.com
CC: dev-etrax@axis.com
---
 arch/cris/arch-v10/boot/compressed/Makefile |    2 +-
 arch/cris/arch-v10/boot/rescue/Makefile     |    1 -
 arch/cris/arch-v10/lib/Makefile             |    3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/cris/arch-v10/boot/compressed/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/boot/compressed/Makefile	2008-04-21 09:54:08.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/boot/compressed/Makefile	2008-04-21 09:54:22.000000000 -0400
@@ -22,7 +22,7 @@ $(obj)/decompress.bin: $(obj)/decompress
 	$(call if_changed,objcopy)
 
 $(obj)/head.o: $(obj)/head.S .config
-	@$(CC) -D__ASSEMBLY__ -traditional -c $< -o $@
+	@$(CC) -D__ASSEMBLY__ -c $< -o $@
 
 $(obj)/misc.o: $(obj)/misc.c .config
 	@$(CC) -D__KERNEL__ -c $< -o $@
Index: linux-2.6-lttng/arch/cris/arch-v10/boot/rescue/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/boot/rescue/Makefile	2008-04-21 09:54:29.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/boot/rescue/Makefile	2008-04-21 09:54:38.000000000 -0400
@@ -4,7 +4,6 @@
 
 CC = gcc-cris -mlinux $(LINUXINCLUDE)
 ccflags-y += -O2
-asflags-y += -traditional
 LD = gcc-cris -mlinux -nostdlib
 ldflags-y += -T $(obj)/rescue.ld
 OBJCOPY = objcopy-cris
Index: linux-2.6-lttng/arch/cris/arch-v10/lib/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/lib/Makefile	2008-04-21 09:54:44.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/lib/Makefile	2008-04-21 09:54:53.000000000 -0400
@@ -2,8 +2,5 @@
 # Makefile for Etrax-specific library files..
 #
 
-
-EXTRA_AFLAGS := -traditional
-
 lib-y  = checksum.o checksumcopy.o string.o usercopy.o memset.o csumcpfruser.o
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
