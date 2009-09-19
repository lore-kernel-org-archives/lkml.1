Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZISLgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZISLgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZISLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:36:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbZISLgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:36:32 -0400
Date: Sat, 19 Sep 2009 13:36:04 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Add timechart help text and add timechart to "perf
 help"
Message-ID: <20090919133604.3767fa35@infradead.org>
In-Reply-To: <20090919133410.7b23e270@infradead.org>
References: <20090919133410.7b23e270@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 880307a7ee6136aca34ca0fc71bab544723829c9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 13:17:57 +0200
Subject: [PATCH] perf: Add timechart help text and add timechart to "perf help"

As suggested by Ingo, add a timechart man page help text, as well
as add it to the "perf help" overview.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/Documentation/perf-timechart.txt |   35 +++++++++++++++++++++++++++
 tools/perf/command-list.txt                 |    1 +
 2 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-timechart.txt

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
new file mode 100644
index 0000000..61e0104
--- /dev/null
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -0,0 +1,35 @@
+perf-timechart(1)
+=================
+
+NAME
+----
+perf-timechart - Tool to visualize total system behavior during a workload
+
+SYNOPSIS
+--------
+[verse]
+'perf timechart' {record}
+
+DESCRIPTION
+-----------
+There are two variants of perf timechart:
+
+  'perf timechart record <command>' to record the system level events
+  of an arbitrary workload.
+
+  'perf timechart' to turn a trace into a Scalable Vector Graphics file,
+  that can be viewed with popular SVG viewers such as 'Inkscape'.
+
+OPTIONS
+-------
+-o::
+--output=::
+        Select the output file (default: output.svg)
+-i::
+--input=::
+        Select the input file (default: perf.data)
+
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 3133c74..00326e2 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -8,5 +8,6 @@ perf-sched			mainporcelain common
 perf-record			mainporcelain common
 perf-report			mainporcelain common
 perf-stat			mainporcelain common
+perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
