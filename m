Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZFBWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZFBWn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZFBWnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbZFBWnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:18 -0400
Date: Tue, 2 Jun 2009 22:42:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Make source code headers more coherent
Message-ID: <tip-bf9e187637ca3d85cee7407e3af93995868cc87c@git.kernel.org>
Git-Commit-ID: bf9e187637ca3d85cee7407e3af93995868cc87c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 22:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf9e187637ca3d85cee7407e3af93995868cc87c
Gitweb:     http://git.kernel.org/tip/bf9e187637ca3d85cee7407e3af93995868cc87c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 23:37:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 23:37:05 +0200

perf_counter tools: Make source code headers more coherent

The perf commands had different ways of describing themselves,
introduce a coherent command-file-header format taken from the
Git project.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   11 ++++-
 Documentation/perf_counter/builtin-report.c |   10 ++++-
 Documentation/perf_counter/builtin-stat.c   |   29 ++++++++-----
 Documentation/perf_counter/builtin-top.c    |   60 ++++++++-------------------
 Documentation/perf_counter/perf.c           |    9 ++++
 5 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 8feb119..2741b35 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -1,9 +1,14 @@
 /*
- * perf record: Record the profile of a workload (or a CPU, or a PID) into
- * the perf.data output file - for later analysis via perf report.
+ * builtin-record.c
+ *
+ * Builtin record command: Record the profile of a workload
+ * (or a CPU, or a PID) into the perf.data output file - for
+ * later analysis via perf report.
  */
-#include "perf.h"
 #include "builtin.h"
+
+#include "perf.h"
+
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 270e986..9da990f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1,6 +1,14 @@
-#include "util/util.h"
+/*
+ * builtin-report.c
+ *
+ * Builtin report command: Analyze the perf.data input file,
+ * look up and read DSOs and symbol information and display
+ * a histogram of results, along various sorting keys.
+ */
 #include "builtin.h"
 
+#include "util/util.h"
+
 #include "util/list.h"
 #include "util/cache.h"
 #include "util/rbtree.h"
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 27abe6a..2357a66 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -1,20 +1,27 @@
 /*
- * perf stat:  /usr/bin/time -alike performance counter statistics utility
+ * builtin-stat.c
+ *
+ * Builtin stat command: Give a precise performance counters summary
+ * overview about any workload, CPU or specific PID.
+ *
+ * Sample output:
 
-          It summarizes the counter events of all tasks (and child tasks),
-          covering all CPUs that the command (or workload) executes on.
-          It only counts the per-task events of the workload started,
-          independent of how many other tasks run on those CPUs.
+   $ perf stat ~/hackbench 10
+   Time: 0.104
 
-   Sample output:
+    Performance counter stats for '/home/mingo/hackbench':
 
-   $ perf stat -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null
+       1255.538611  task clock ticks     #      10.143 CPU utilization factor
+             54011  context switches     #       0.043 M/sec
+               385  CPU migrations       #       0.000 M/sec
+             17755  pagefaults           #       0.014 M/sec
+        3808323185  CPU cycles           #    3033.219 M/sec
+        1575111190  instructions         #    1254.530 M/sec
+          17367895  cache references     #      13.833 M/sec
+           7674421  cache misses         #       6.112 M/sec
 
-   Performance counter stats for 'ls':
+    Wall-clock time elapsed:   123.786620 msecs
 
-           163516953 instructions
-                2295 cache-misses
-             2855182 branch-misses
  *
  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
  *
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 5029d8e..a639352 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -1,49 +1,25 @@
 /*
- * kerneltop.c: show top kernel functions - performance counters showcase
-
-   Build with:
-
-     make -C Documentation/perf_counter/
-
-   Sample output:
-
-------------------------------------------------------------------------------
- KernelTop:    2669 irqs/sec  [cache-misses/cache-refs],  (all, cpu: 2)
-------------------------------------------------------------------------------
-
-             weight         RIP          kernel function
-             ______   ________________   _______________
-
-              35.20 - ffffffff804ce74b : skb_copy_and_csum_dev
-              33.00 - ffffffff804cb740 : sock_alloc_send_skb
-              31.26 - ffffffff804ce808 : skb_push
-              22.43 - ffffffff80510004 : tcp_established_options
-              19.00 - ffffffff8027d250 : find_get_page
-              15.76 - ffffffff804e4fc9 : eth_type_trans
-              15.20 - ffffffff804d8baa : dst_release
-              14.86 - ffffffff804cf5d8 : skb_release_head_state
-              14.00 - ffffffff802217d5 : read_hpet
-              12.00 - ffffffff804ffb7f : __ip_local_out
-              11.97 - ffffffff804fc0c8 : ip_local_deliver_finish
-               8.54 - ffffffff805001a3 : ip_queue_xmit
+ * builtin-top.c
+ *
+ * Builtin top command: Display a continuously updated profile of
+ * any workload, CPU or specific PID.
+ *
+ * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ *
+ * Improvements and fixes by:
+ *
+ *   Arjan van de Ven <arjan@linux.intel.com>
+ *   Yanmin Zhang <yanmin.zhang@intel.com>
+ *   Wu Fengguang <fengguang.wu@intel.com>
+ *   Mike Galbraith <efault@gmx.de>
+ *   Paul Mackerras <paulus@samba.org>
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
  */
-
- /*
-  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
-  *
-  * Improvements and fixes by:
-  *
-  *   Arjan van de Ven <arjan@linux.intel.com>
-  *   Yanmin Zhang <yanmin.zhang@intel.com>
-  *   Wu Fengguang <fengguang.wu@intel.com>
-  *   Mike Galbraith <efault@gmx.de>
-  *   Paul Mackerras <paulus@samba.org>
-  *
-  * Released under the GPL v2. (and only v2, not any later version)
-  */
+#include "builtin.h"
 
 #include "perf.h"
-#include "builtin.h"
+
 #include "util/symbol.h"
 #include "util/util.h"
 #include "util/rbtree.h"
diff --git a/Documentation/perf_counter/perf.c b/Documentation/perf_counter/perf.c
index e8a8584..ec7edb7 100644
--- a/Documentation/perf_counter/perf.c
+++ b/Documentation/perf_counter/perf.c
@@ -1,4 +1,13 @@
+/*
+ * perf.c
+ *
+ * Performance analysis utility.
+ *
+ * This is the main hub from which the sub-commands (perf stat,
+ * perf top, perf record, perf report, etc.) are started.
+ */
 #include "builtin.h"
+
 #include "util/exec_cmd.h"
 #include "util/cache.h"
 #include "util/quote.h"
