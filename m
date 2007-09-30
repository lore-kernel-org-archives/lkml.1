Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXI3OHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXI3OHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXI3OHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:07:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:54349 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbXI3OH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:07:29 -0400
Date: Sun, 30 Sep 2007 10:07:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Linux Kernel Markers - Samples Coding Style Fix
Message-ID: <20070930140725.GA18579@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.948108939@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070928143159.948108939@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:05:12 up 62 days, 14:24,  2 users,  load average: 4.31, 3.07, 1.93
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Samples Coding Style Fix

- Change struct __mark_marker to struct marker.

It applies after
linux-kernel-markers-samples-checkpatch-fixes.patch
in the series.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 samples/markers/probe-example.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/probe-example.c	2007-09-30 09:39:49.000000000 -0400
+++ linux-2.6-lttng/samples/markers/probe-example.c	2007-09-30 09:40:16.000000000 -0400
@@ -20,8 +20,8 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
-void probe_subsystem_event(const struct __mark_marker *mdata,
-		void *private, const char *format, ...)
+void probe_subsystem_event(const struct marker *mdata, void *private,
+	const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */
@@ -43,8 +43,8 @@ void probe_subsystem_event(const struct 
 
 atomic_t eventb_count = ATOMIC_INIT(0);
 
-void probe_subsystem_eventb(const struct __mark_marker *mdata,
-	void *private, const char *format, ...)
+void probe_subsystem_eventb(const struct marker *mdata, void *private,
+	const char *format, ...)
 {
 	/* Increment counter */
 	atomic_inc(&eventb_count);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
