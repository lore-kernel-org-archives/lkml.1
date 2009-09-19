Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbZISRCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbZISRCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZISRCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:02:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZISRCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:02:07 -0400
Date: Sat, 19 Sep 2009 17:01:40 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, arjan@infradead.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       paulus@samba.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090919133604.3767fa35@infradead.org>
References: <20090919133604.3767fa35@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Add timechart help text and add timechart to "perf help"
Message-ID: <tip-151750cec5db3c7ea45255d2901e581e2162317a@git.kernel.org>
Git-Commit-ID: 151750cec5db3c7ea45255d2901e581e2162317a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 17:01:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  151750cec5db3c7ea45255d2901e581e2162317a
Gitweb:     http://git.kernel.org/tip/151750cec5db3c7ea45255d2901e581e2162317a
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 19 Sep 2009 13:36:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 18:57:53 +0200

perf: Add timechart help text and add timechart to "perf help"

As suggested by Ingo, add a timechart man page help text, as well
as add it to the "perf help" overview.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090919133604.3767fa35@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-timechart.txt |   35 +++++++++++++++++++++++++++
 tools/perf/command-list.txt                 |    1 +
 2 files changed, 36 insertions(+), 0 deletions(-)

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
