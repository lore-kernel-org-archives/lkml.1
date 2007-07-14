Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbXGNXOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbXGNXOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbXGNXO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:14:28 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:40768 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761085AbXGNXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:14:28 -0400
Date: Sat, 14 Jul 2007 19:09:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Pre fix powerpc Optimization
Message-ID: <20070714230916.GH18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.842959793@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012624.842959793@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:08:14 up 7 days, 13:13,  3 users,  load average: 0.50, 0.48, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Pre fix powerpc Optimization

Since I removed the immediate-values-non-optimized-architectures.patch, we need
to redo it to apply immediate-values-powerpc-optimization.patch correctly.

It applies _before_ immediate-values-powerpc-optimization.patch and can
be folded with it.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 include/asm-powerpc/immediate.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-07-14 18:21:07.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
