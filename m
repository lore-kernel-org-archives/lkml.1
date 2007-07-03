Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXGCQue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXGCQue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761101AbXGCQr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:47:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46311 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbXGCQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:47:27 -0400
Message-Id: <20070703164629.061359284@polymtl.ca>
References: <20070703164534.492133618@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:45:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, starvik@axis.com,
       dev-etrax@axis.com
Subject: [patch 1/3] Use DATA_DATA in CRIS
Content-Disposition: inline; filename=use-data-data-in-cris.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:46:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: starvik@axis.com
CC: dev-etrax@axis.com
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
