Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZKWLym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZKWLym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZKWLyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:54:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:56128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbZKWLyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:54:39 -0500
Date: Mon, 23 Nov 2009 11:54:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091123103819.613427378@chello.nl>
References: <20091123103819.613427378@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix style nits
Message-ID: <tip-6c2bfcbe58e0dd39554be88940149f5aa11e17d1@git.kernel.org>
Git-Commit-ID: 6c2bfcbe58e0dd39554be88940149f5aa11e17d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c2bfcbe58e0dd39554be88940149f5aa11e17d1
Gitweb:     http://git.kernel.org/tip/6c2bfcbe58e0dd39554be88940149f5aa11e17d1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:55 +0100

perf_events: Fix style nits

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091123103819.613427378@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e2daa10..1f14481 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -447,9 +447,8 @@ retry:
 	 * can remove the event safely, if the call above did not
 	 * succeed.
 	 */
-	if (!list_empty(&event->group_entry)) {
+	if (!list_empty(&event->group_entry))
 		list_del_event(event, ctx);
-	}
 	spin_unlock_irq(&ctx->lock);
 }
 
@@ -1033,10 +1032,10 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
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
