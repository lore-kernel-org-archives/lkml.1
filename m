Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYGDXzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYGDXzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGDXzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42502 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYGDXzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:09 -0400
Message-Id: <20080704235426.751868080@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 07/12] Traceprobes
Content-Disposition: inline; filename=traceprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Menu option to activate tracing probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 init/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-07-04 09:32:52.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2008-07-04 09:33:05.000000000 -0400
@@ -795,6 +795,15 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
+config TRACEPROBES
+	tristate "Compile generic tracing probes"
+	depends on MARKERS
+	default y
+	help
+	  Compile generic tracing probes, which connect to the tracepoints when
+	  loaded and format the information collected by the tracepoints with
+	  the Markers.
+
 source "arch/Kconfig"
 
 config PROC_PAGE_MONITOR

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
