Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100Ab0AMQpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0AMQpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086Ab0AMQpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:45:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:34940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab0AMQpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:45:09 -0500
Date: Wed, 13 Jan 2010 16:42:47 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263396139-4798-2-git-send-email-acme@infradead.org>
References: <1263396139-4798-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix few typos + cosmetics
Message-ID: <tip-0895cf0a823e03ea6d79736611e90186006c805e@git.kernel.org>
Git-Commit-ID: 0895cf0a823e03ea6d79736611e90186006c805e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 16:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0895cf0a823e03ea6d79736611e90186006c805e
Gitweb:     http://git.kernel.org/tip/0895cf0a823e03ea6d79736611e90186006c805e
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Wed, 13 Jan 2010 13:22:18 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 17:39:44 +0100

perf: Fix few typos + cosmetics

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1263396139-4798-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf.txt |    2 +-
 tools/perf/design.txt             |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 69c8325..0eeb247 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-Performance counters for Linux are are a new kernel-based subsystem
+Performance counters for Linux are a new kernel-based subsystem
 that provide a framework for all things performance analysis. It
 covers hardware level (CPU/PMU, Performance Monitoring Unit) features
 and software features (software counters, tracepoints) as well.
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 8d0de51..bd0bb1b 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -101,10 +101,10 @@ enum hw_event_ids {
 	 */
 	PERF_COUNT_HW_CPU_CYCLES		= 0,
 	PERF_COUNT_HW_INSTRUCTIONS		= 1,
-	PERF_COUNT_HW_CACHE_REFERENCES	= 2,
+	PERF_COUNT_HW_CACHE_REFERENCES		= 2,
 	PERF_COUNT_HW_CACHE_MISSES		= 3,
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
-	PERF_COUNT_HW_BRANCH_MISSES	= 5,
+	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
 };
 
@@ -131,8 +131,8 @@ software events, selected by 'event_id':
  */
 enum sw_event_ids {
 	PERF_COUNT_SW_CPU_CLOCK		= 0,
-	PERF_COUNT_SW_TASK_CLOCK		= 1,
-	PERF_COUNT_SW_PAGE_FAULTS		= 2,
+	PERF_COUNT_SW_TASK_CLOCK	= 1,
+	PERF_COUNT_SW_PAGE_FAULTS	= 2,
 	PERF_COUNT_SW_CONTEXT_SWITCHES	= 3,
 	PERF_COUNT_SW_CPU_MIGRATIONS	= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN	= 5,
