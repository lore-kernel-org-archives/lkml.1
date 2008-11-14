Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYKNXE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYKNXE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYKNXA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:27 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57185 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYKNXA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:26 -0500
Message-Id: <20081114224949.751661181@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 16/16] marker_synchronize_unregister->tracepoint_synchronize_unregister
Content-Disposition: inline; filename=tracepoints-fix-typo-in-documentation.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: documentation update.

Signed-off-by: Zhaolei <zhaolei@cn.fujitsu.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/tracepoints.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/Documentation/tracepoints.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/tracepoints.txt	2008-11-14 17:19:21.000000000 -0500
+++ linux-2.6-lttng/Documentation/tracepoints.txt	2008-11-14 17:19:25.000000000 -0500
@@ -71,7 +71,7 @@ Connecting a function (probe) to a trace
 (function to call) for the specific tracepoint through
 register_trace_subsys_eventname().  Removing a probe is done through
 unregister_trace_subsys_eventname(); it will remove the probe.
-marker_synchronize_unregister() must be called before the end of the module exit
+tracepoint_synchronize_unregister() must be called before the end of the module exit
 function to make sure there is no caller left using the probe. This, and the
 fact that preemption is disabled around the probe call, make sure that probe
 removal and module unload are safe. See the "Probe example" section below for a

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
