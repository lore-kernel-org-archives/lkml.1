Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXGOXoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXGOXoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGOXnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:43:53 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:59835 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585AbXGOXnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:43:53 -0400
Date: Sun, 15 Jul 2007 19:43:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Linux Kernel Markers - Architecture Independent Code Remove ifdef KERNEL
Message-ID: <20070715234350.GK22428@Krystal>
References: <20070714012914.508504384@polymtl.ca> <20070714013050.289300592@polymtl.ca> <20070715013431.GE23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013431.GE23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:42:47 up 8 days, 13:48,  3 users,  load average: 0.39, 0.59, 0.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Architecture Independent Code Remove ifdef kernel

Remove #ifdef __KERNEL__ in marker.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/linux/marker.h |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-07-15 19:17:05.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-07-15 19:17:28.000000000 -0400
@@ -12,8 +12,6 @@
  * See the file COPYING for more details.
  */
 
-#ifdef __KERNEL__
-
 #include <linux/immediate.h>
 #include <linux/types.h>
 
@@ -132,5 +130,4 @@ extern struct __mark_marker *marker_get_
 extern void marker_release(struct __mark_marker *iter);
 extern void *marker_get_pdata(const char *name);
 
-#endif /* __KERNEL__ */
 #endif
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
