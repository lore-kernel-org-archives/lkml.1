Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZHaBcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZHaBcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 21:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHaBcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 21:32:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55794 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZHaBcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 21:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BnQW79KfhlClds930fkasgSxwtF1/Mj12H/v1I8z6j9Ks+AQWCEgASgsbgLaWYRVv9
         29ILxO8qR2NTPU2CuOxybDy53t6v2Q1Sj7yp1OaCJpTdklJW1hxgkscrEU5G2FyOZ1Zm
         jl7C6JiU4c/aJg9XCdXDRE4GwdG7PeeOu1GRI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Add missing parameters documentation
Date: Mon, 31 Aug 2009 03:32:03 +0200
Message-Id: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing documentation for the following parameters:

- perf record -R
- perf report -g

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.3

