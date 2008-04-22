Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbYDVRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbYDVRcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762709AbYDVR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53838 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763210AbYDVR3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:12 -0400
Message-Id: <20080422172842.427209743@polymtl.ca>
References: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [RFC patch 6/9] POWERPC remove -traditional
Content-Disposition: inline; filename=powerpc-remove-traditional.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC patch 6/9] Re: [PATCH] Stringify support commas
 > This is a no-no for those archs that still use -traditional.
 > > I dunno if this is a problem for you at the moment and the
 > > right fix is anyway to nuke -traditional.
 > > 
 > >     Sam

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: paulus@samba.org
CC: linuxppc-dev@ozlabs.org
---
 arch/powerpc/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/powerpc/boot/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/boot/Makefile	2008-04-21 10:03:05.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/boot/Makefile	2008-04-21 10:03:17.000000000 -0400
@@ -23,7 +23,7 @@ BOOTCFLAGS    := -Wall -Wundef -Wstrict-
 		 -fno-strict-aliasing -Os -msoft-float -pipe \
 		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -isystem $(shell $(CROSS32CC) -print-file-name=include)
-BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
+BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -nostdinc
 
 ifdef CONFIG_DEBUG_INFO
 BOOTCFLAGS	+= -g

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
