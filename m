Return-Path: <linux-kernel-owner+w=401wt.eu-S1763231AbYDVRcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763231AbYDVRcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763416AbYDVR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53940 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763410AbYDVR3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:34 -0400
Message-Id: <20080422172841.232060494@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [RFC patch 3/9] H8300 remove -traditional
Content-Disposition: inline; filename=h8300-remove-traditional.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC patch 3/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/boot/compressed/Makefile |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-lttng/arch/h8300/boot/compressed/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/boot/compressed/Makefile	2008-04-21 09:58:17.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/boot/compressed/Makefile	2008-04-21 09:58:23.000000000 -0400
@@ -5,7 +5,6 @@
 #
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o
-EXTRA_AFLAGS	:= -traditional
 
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
