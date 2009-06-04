Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZFDPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZFDPlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZFDPlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:41:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:33162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZFDPlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:41:00 -0400
Date: Thu, 4 Jun 2009 15:39:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: Update help text
Message-ID: <tip-20c84e959ec11b1803d2b2832eef703d5fbe7f7b@git.kernel.org>
Git-Commit-ID: 20c84e959ec11b1803d2b2832eef703d5fbe7f7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 15:39:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20c84e959ec11b1803d2b2832eef703d5fbe7f7b
Gitweb:     http://git.kernel.org/tip/20c84e959ec11b1803d2b2832eef703d5fbe7f7b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 16:33:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 16:33:00 +0200

perf stat: Update help text

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-stat.txt       |   30 ++++++++++++-------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/Documentation/perf_counter/Documentation/perf-stat.txt
index a67d0e3..a340e7b 100644
--- a/Documentation/perf_counter/Documentation/perf-stat.txt
+++ b/Documentation/perf_counter/Documentation/perf-stat.txt
@@ -22,6 +22,7 @@ OPTIONS
 <command>...::
 	Any command you can specify in a shell.
 
+
 -e::
 --event=::
                              0:0: cpu-cycles          
@@ -45,6 +46,13 @@ OPTIONS
                              1:4: migrations          
                            rNNN: raw PMU events (eventsel+umask)
 
+-i::
+--inherit::
+        child tasks inherit counters
+-p::
+--pid=<pid>::
+        stat events on existing pid
+
 -a::
         system-wide collection
 
@@ -54,20 +62,20 @@ OPTIONS
 EXAMPLES
 --------
 
-$ perf stat sleep 1
+$ perf stat -- make -j
 
- Performance counter stats for 'sleep':
+ Performance counter stats for 'make -j':
 
-       0.678356  task clock ticks     (msecs)
-              7  context switches     (events)
-              4  CPU migrations       (events)
-            232  pagefaults           (events)
-        1810403  CPU cycles           (events)
-         946759  instructions         (events)
-          18952  cache references     (events)
-           4885  cache misses         (events)
+    8117.370256  task clock ticks     #      11.281 CPU utilization factor
+            678  context switches     #       0.000 M/sec
+            133  CPU migrations       #       0.000 M/sec
+         235724  pagefaults           #       0.029 M/sec
+    24821162526  CPU cycles           #    3057.784 M/sec
+    18687303457  instructions         #    2302.138 M/sec
+      172158895  cache references     #      21.209 M/sec
+       27075259  cache misses         #       3.335 M/sec
 
- Wall-clock time elapsed:  1001.252894 msecs
+ Wall-clock time elapsed:   719.554352 msecs
 
 SEE ALSO
 --------
