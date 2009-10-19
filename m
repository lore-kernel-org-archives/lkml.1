Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZJSLsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZJSLsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJSLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:47:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbZJSLr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:47:57 -0400
Date: Mon, 19 Oct 2009 11:47:02 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
In-Reply-To: <4ADC3975.8050109@klingt.org>
References: <4ADC3975.8050109@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add branch performance events to default output
Message-ID: <tip-12133afffcc7140eea915b1572189a2ea0cf7b0e@git.kernel.org>
Git-Commit-ID: 12133afffcc7140eea915b1572189a2ea0cf7b0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Oct 2009 11:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12133afffcc7140eea915b1572189a2ea0cf7b0e
Gitweb:     http://git.kernel.org/tip/12133afffcc7140eea915b1572189a2ea0cf7b0e
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Mon, 19 Oct 2009 12:03:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Oct 2009 13:26:42 +0200

perf stat: Add branch performance events to default output

Adds performance event information about branches
and branch misses to the default output of perf stat.

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4ADC3975.8050109@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c373683..95a55ea 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -59,6 +59,8 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES	},
 
 };
 
