Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXEJBj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXEJBj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXEJBjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:39:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52077 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbXEJBjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:39:03 -0400
Message-Id: <20070510013835.617246797@polymtl.ca>
References: <20070510013555.436601330@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:35:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/1] powerpc prom.c - Remove #undef printk
Content-Disposition: inline; filename=prom-powerpc-fix-remove-undef-printk.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 01:38:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/kernel/prom.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/prom.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/prom.c	2007-05-09 14:56:55.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/prom.c	2007-05-09 14:57:24.000000000 -0400
@@ -1040,8 +1040,6 @@
 	DBG(" <- early_init_devtree()\n");
 }
 
-#undef printk
-
 int of_n_addr_cells(struct device_node* np)
 {
 	const int *ip;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
