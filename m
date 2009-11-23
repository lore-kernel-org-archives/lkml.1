Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZKWKk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZKWKk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZKWKk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:53256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981AbZKWKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:57 -0500
Message-Id: <20091123103819.613427378@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/8] perf: style nits
Content-Disposition: inline; filename=perf-foo-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -449,9 +450,8 @@ retry:
 	 * can remove the event safely, if the call above did not
 	 * succeed.
 	 */
-	if (!list_empty(&event->group_entry)) {
+	if (!list_empty(&event->group_entry))
 		list_del_event(event, ctx);
-	}
 	spin_unlock_irq(&ctx->lock);
 }
 
@@ -1033,10 +1033,10 @@ void __perf_event_sched_out(struct perf_
 	update_context_time(ctx);
 
 	perf_disable();
-	if (ctx->nr_active)
+	if (ctx->nr_active) {
 		list_for_each_entry(event, &ctx->group_list, group_entry)
 			group_sched_out(event, cpuctx, ctx);
-
+	}
 	perf_enable();
  out:
 	spin_unlock(&ctx->lock);

-- 

