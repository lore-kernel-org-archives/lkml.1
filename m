Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXFQEGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXFQEGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 00:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXFQEGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 00:06:23 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:52350 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbXFQEGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 00:06:22 -0400
Date: Sat, 16 Jun 2007 22:28:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [PATCH] Use DATA_DATA in cris
Message-ID: <20070617022825.GA6832@Krystal>
References: <20070615202959.316963297@polymtl.ca> <20070615203550.044690775@polymtl.ca> <20070615215534.GB11267@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070615215534.GB11267@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:25:48 up 19 days, 11:04,  3 users,  load average: 0.00, 0.16, 0.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> From your patch it looks like I originally missed out
> powerpc + xtensa when introducing DATA_DATA - would be nice if
> you could fix that.
> 

Use DATA_DATA in CRIS

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/cris/arch-v10/vmlinux.lds.S |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/vmlinux.lds.S	2007-06-16 22:12:58.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S	2007-06-16 22:13:28.000000000 -0400
@@ -44,7 +44,7 @@
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
Index: linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v32/vmlinux.lds.S	2007-06-16 22:13:03.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S	2007-06-16 22:13:42.000000000 -0400
@@ -49,7 +49,7 @@
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
