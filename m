Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbZEOOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbZEOOoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZEOOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:43:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:54736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZEOOn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:43:57 -0400
Date: Fri, 15 May 2009 14:43:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090515132018.429826617@chello.nl>
References: <20090515132018.429826617@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: remove perf_disable/enable exports
Message-ID: <tip-548e1ddf255b4ebfb4ef20c08936fd8d4deb3bd9@git.kernel.org>
Git-Commit-ID: 548e1ddf255b4ebfb4ef20c08936fd8d4deb3bd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:43:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  548e1ddf255b4ebfb4ef20c08936fd8d4deb3bd9
Gitweb:     http://git.kernel.org/tip/548e1ddf255b4ebfb4ef20c08936fd8d4deb3bd9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 May 2009 15:19:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 15:26:55 +0200

perf_counter: remove perf_disable/enable exports

Now that ACPI idle doesn't use it anymore, remove the exports.

[ Impact: remove dead code/data ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090515132018.429826617@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e814ff0..0173738 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -90,14 +90,12 @@ void perf_disable(void)
 	__perf_disable();
 	hw_perf_disable();
 }
-EXPORT_SYMBOL_GPL(perf_disable); /* ACPI idle */
 
 void perf_enable(void)
 {
 	if (__perf_enable())
 		hw_perf_enable();
 }
-EXPORT_SYMBOL_GPL(perf_enable); /* ACPI idle */
 
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
