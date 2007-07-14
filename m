Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbXGNXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbXGNXIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764429AbXGNXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:08:13 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:44404 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764285AbXGNXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:08:12 -0400
Date: Sat, 14 Jul 2007 19:08:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Pre Fix i386 Optimization
Message-ID: <20070714230809.GG18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.507095382@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012624.507095382@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:07:11 up 7 days, 13:12,  3 users,  load average: 0.23, 0.39, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Pre Fix i386 Optimization

Since I removed the immediate-values-non-optimized-architectures.patch, we need
to redo it to apply immediate-values-i386-optimization.patch correctly.

It should be applied _before_ the
immediate-values-i386-optimization.patch and folded with it.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 include/asm-i386/immediate.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/asm-i386/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/immediate.h	2007-07-14 18:20:49.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
