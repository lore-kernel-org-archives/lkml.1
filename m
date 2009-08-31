Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZHaIhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZHaIhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZHaIhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:37:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:57204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZHaIhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:37:35 -0400
Date: Mon, 31 Aug 2009 08:37:05 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Add missing parameters documentation
Message-ID: <tip-ec7ba4ea1d605029fb09601ab4ad3053bc1f519c@git.kernel.org>
Git-Commit-ID: ec7ba4ea1d605029fb09601ab4ad3053bc1f519c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 08:37:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec7ba4ea1d605029fb09601ab4ad3053bc1f519c
Gitweb:     http://git.kernel.org/tip/ec7ba4ea1d605029fb09601ab4ad3053bc1f519c
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 31 Aug 2009 03:32:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 10:04:47 +0200

perf tools: Add missing parameters documentation

Add missing documentation for the following parameters:

- perf record -R
- perf report -g

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-record.txt |    4 ++++
 tools/perf/Documentation/perf-report.txt |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6be696b..0ff23de 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -91,6 +91,10 @@ OPTIONS
 --no-samples::
 	Don't sample.
 
+-R::
+--raw-samples::
+Collect raw sample records from all opened counters (typically for tracepoint counters).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 370344a..59f0b84 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -51,6 +51,16 @@ OPTIONS
 	all occurances of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
+-g [type,min]::
+--call-graph::
+        Display callchains using type and min percent threshold.
+	type can be either:
+	- flat: single column, linear exposure of callchains.
+	- graph: use a graph tree, displaying absolute overhead rates.
+	- fractal: like graph, but displays relative rates. Each branch of
+		 the tree is considered as a new profiled object. +
+	Default: fractal,0.5.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
