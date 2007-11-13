Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXKMTlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXKMTlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXKMTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:09 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47622 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758385AbXKMTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:08 -0500
Message-Id: <20071113194023.895571147@polymtl.ca>
References: <20071113193349.214098508@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:33:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC 1/7] Include marker.h in kernel.h -- temporary, for code readability
Content-Disposition: inline; filename=lttng-instrument-kernelh.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:40:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a hack to make my life easier : it lessens the conflicts due to
header includes that changes between the kernel versions.

The proper way to do this is to include <linux/marker.h> in every file using the
markers.

NOT FOR UPSTREAM.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/kernel.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kernel.h	2007-06-15 16:13:48.000000000 -0400
+++ linux-2.6-lttng/include/linux/kernel.h	2007-06-15 16:14:28.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/marker.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
