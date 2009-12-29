Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZL2FXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZL2FXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZL2FXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:23:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZL2FXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:23:43 -0500
Message-ID: <4B3991EF.9060006@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:21:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/5] perf timer: add document for 'perf timer'
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document for 'perf timer', it let people know how to use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-timer.txt |   50 +++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-timer.txt

diff --git a/tools/perf/Documentation/perf-timer.txt b/tools/perf/Documentation/perf-timer.txt
new file mode 100644
index 0000000..5bd26d4
--- /dev/null
+++ b/tools/perf/Documentation/perf-timer.txt
@@ -0,0 +1,50 @@
+perf-timer(1)
+==============
+
+NAME
+----
+perf-timer - Tool to trace/measure timer properties
+
+SYNOPSIS
+--------
+[verse]
+'perf timer' {record|report} [<options>]
+
+DESCRIPTION
+-----------
+There are two variants of perf timer:
+
+  'perf timer record <command>' to record the timer events
+  of an arbitrary workload.
+
+  'perf timer report' to report number of activated/expired/canceled
+  timers, timer latency and timer function runtime.
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
+	Sort the output (default: type, avg-lat, max-lat,
+	avg-runtime, max-runtime)
+
+--print-lat::
+	Print timer latency
+
+--print-runtime::
+	Print timer function runtime
+
+--type::
+	Timer type selector, you can specify one or more types
+	(timer, hrtimer, itimer-real, itimer-virtual, itimer-prof)
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
-- 
1.6.1.2


