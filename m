Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbXFQEZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbXFQEZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 00:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXFQEZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 00:25:23 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:55535 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbXFQEZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 00:25:22 -0400
Date: Sat, 16 Jun 2007 22:29:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [PATCH] Use DATA_DATA in xtensa
Message-ID: <20070617022939.GC6832@Krystal>
References: <20070615202959.316963297@polymtl.ca> <20070615203550.044690775@polymtl.ca> <20070615215534.GB11267@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070615215534.GB11267@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:29:04 up 19 days, 11:07,  3 users,  load average: 0.07, 0.09, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> From your patch it looks like I originally missed out
> powerpc + xtensa when introducing DATA_DATA - would be nice if
> you could fix that.
> 
> 	Sam

Use DATA_DATA in xtensa

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/kernel/vmlinux.lds.S	2007-06-16 22:20:09.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S	2007-06-16 22:20:41.000000000 -0400
@@ -118,7 +118,8 @@
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
