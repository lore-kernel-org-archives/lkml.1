Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbZLOLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbZLOLX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbZLOLXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:23:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZLOLXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:23:24 -0500
Message-ID: <4B277143.9070909@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 19:21:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf/timer: add document
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com>
In-Reply-To: <4B2770FA.7090803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document for 'perf timer'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-timer.txt |   40 +++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-timer.txt

diff --git a/tools/perf/Documentation/perf-timer.txt b/tools/perf/Documentation/perf-timer.txt
new file mode 100644
index 0000000..fbff936
--- /dev/null
+++ b/tools/perf/Documentation/perf-timer.txt
@@ -0,0 +1,40 @@
+perf-timer(1)
+==============
+
+NAME
+----
+perf-timer - Tool to trace/measure kernel timer properties
+
+SYNOPSIS
+--------
+[verse]
+'perf timer' {record|latency} [<options>]
+
+DESCRIPTION
+-----------
+There are two variants of perf timer:
+
+  'perf timer record <command>' to record the timer events
+  of an arbitrary workload.
+
+  'perf timer latency' to report kernel timer latency and
+  timer function handle time.
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the sched data.
+
+-i <file>::
+--input=<file>::
+	Select the input file (default: perf.data)
+
+-s <key[,key2...]>::
+--sort=<key[,key2...]>::
+	Sort the output (default: timer, type, avg-timer-latency,
+	max-timer-latency, avg-handle-time, max-handle-time)
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
-- 
1.6.1.2


