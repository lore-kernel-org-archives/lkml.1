Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXGCQuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXGCQuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbXGCQrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:47:53 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46450 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbXGCQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:47:52 -0400
Message-Id: <20070703164629.363240511@polymtl.ca>
References: <20070703164534.492133618@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:45:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [patch 2/3] Add missing DATA_DATA in powerpc
Content-Disposition: inline; filename=use-data-data-in-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:46:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: paulus@samba.org
CC: linuxppc-dev@ozlabs.org
--
 arch/powerpc/kernel/vmlinux.lds.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/vmlinux.lds.S	2007-06-16 22:17:53.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S	2007-06-16 22:18:32.000000000 -0400
@@ -173,7 +173,9 @@
 	}
 #else
 	.data : {
-		*(.data .data.rel* .toc1)
+		DATA_DATA
+		*(.data.rel*)
+		*(.toc1)
 		*(.branch_lt)
 	}
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
