Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXLFC2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXLFC2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLFC16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:27:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:50012 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXLFC15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:27:57 -0500
Message-Id: <20071206022741.001401953@polymtl.ca>
References: <20071206022555.150400591@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:25:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 1/7] Include marker.h in kernel.h -- temporary, for code readability
Content-Disposition: inline; filename=lttng-instrument-kernelh.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:27:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
