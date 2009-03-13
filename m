Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbZCMClg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbZCMClg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZCMCie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65335 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023826.306251717@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/16] tracing: make bprint event use the proper event id
Content-Disposition: inline; filename=0007-tracing-make-bprint-event-use-the-proper-event-id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The bprint record is using TRACE_PRINT when it should be TRACE_BPRINT.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_event_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index d0907d7..0199150 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -102,7 +102,7 @@ TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
 );
 
-TRACE_EVENT_FORMAT(bprint, TRACE_PRINT, bprint_entry, ignore,
+TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(unsigned int, depth, depth)
-- 
1.6.1.3

-- 
