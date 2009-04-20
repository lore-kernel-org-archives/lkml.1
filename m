Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZDTRkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZDTRkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDTRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:40:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZDTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:40:19 -0400
Message-Id: <20090420174017.590031937@goodmis.org>
References: <20090420173819.957332585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:38:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] tracing/events: call the correct event trace selftest init function
Content-Disposition: inline; filename=0001-tracing-events-call-the-correct-event-trace-selftes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The late_initcall calls a helper function instead of the proper
init event selftest function.

This update may have been lost due to conflicting merges.

[ Impact: fix compiler warning and call extended event trace self tests ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 64f9d6d..98daf5d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1199,6 +1199,6 @@ static __init int event_trace_self_tests_init(void)
 	return 0;
 }
 
-late_initcall(event_trace_self_tests);
+late_initcall(event_trace_self_tests_init);
 
 #endif
-- 
1.6.2.1

-- 
