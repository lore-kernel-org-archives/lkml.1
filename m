Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZFYPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZFYPeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZFYPeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:34:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZFYPeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:34:07 -0400
Date: Thu, 25 Jun 2009 15:33:32 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245934522.5308.39.camel@hpdv5.satnam>
References: <1245934522.5308.39.camel@hpdv5.satnam>
Subject: [tip:perfcounters/urgent] perf_counter tools: Shorten names for events
Message-ID: <tip-e5c59547791f171b280bc4c4b2c3ff171824c1a3@git.kernel.org>
Git-Commit-ID: e5c59547791f171b280bc4c4b2c3ff171824c1a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 15:33:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5c59547791f171b280bc4c4b2c3ff171824c1a3
Gitweb:     http://git.kernel.org/tip/e5c59547791f171b280bc4c4b2c3ff171824c1a3
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Thu, 25 Jun 2009 18:25:22 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 17:30:23 +0200

perf_counter tools: Shorten names for events

Added new alias for events.

On AMD box:

 $ ./perf stat -e l1d -e l1d-misses -e l1d-write -e l1d-prefetch -e l1d-prefetch-miss -e l1i -e l1i-misses -e l1i-prefetch -e l2 -e l2-misses -e l2-write -e dtlb -e dtlb-misses -e itlb -e itlb-misses -e bpu -e bpu-misses -- ls -lR /usr/include/ > /dev/null

Before :

 Performance counter stats for 'ls -lR /usr/include/':

      248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
        1001433  L1-data-Cache-Load-Misses  (scaled from 23.34%)
         153691  L1-data-Cache-Store-Referencees  (scaled from 23.34%)
         423248  L1-data-Cache-Prefetch-Referencees  (scaled from 23.33%)
         302138  L1-data-Cache-Prefetch-Misses  (scaled from 23.25%)
      251217546  L1-instruction-Cache-Load-Referencees  (scaled from 23.25%)
        5757005  L1-instruction-Cache-Load-Misses  (scaled from 23.23%)
          93435  L1-instruction-Cache-Prefetch-Referencees  (scaled from 23.24%)
        6496073  L2-Cache-Load-Referencees  (scaled from 23.32%)
         609485  L2-Cache-Load-Misses  (scaled from 23.45%)
        6876991  L2-Cache-Store-Referencees  (scaled from 23.71%)
      248922840  Data-TLB-Cache-Load-Referencees  (scaled from 23.94%)
        5828386  Data-TLB-Cache-Load-Misses  (scaled from 24.17%)
      257613506  Instruction-TLB-Cache-Load-Referencees  (scaled from 24.20%)
           6833  Instruction-TLB-Cache-Load-Misses  (scaled from 23.88%)
      109043606  Branch-Cache-Load-Referencees  (scaled from 23.64%)
        5552296  Branch-Cache-Load-Misses  (scaled from 23.42%)

    0.413702461  seconds time elapsed.

After :

 Peformance counter stats for 'ls -lR /usr/include/':

      266590464  L1-d$-loads           (scaled from 23.03%)
        1222273  L1-d$-load-misses     (scaled from 23.58%)
         146204  L1-d$-stores          (scaled from 23.83%)
         406344  L1-d$-prefetches      (scaled from 24.09%)
         283748  L1-d$-prefetch-misses (scaled from 24.10%)
      249650965  L1-i$-loads           (scaled from 23.80%)
        3353961  L1-i$-load-misses     (scaled from 23.82%)
         104599  L1-i$-prefetches      (scaled from 23.68%)
        4836405  LLC-loads             (scaled from 23.67%)
         498214  LLC-load-misses       (scaled from 23.66%)
        4953994  LLC-stores            (scaled from 23.64%)
      243354097  dTLB-loads            (scaled from 23.77%)
        6468584  dTLB-load-misses      (scaled from 23.74%)
      249719549  iTLB-loads            (scaled from 23.25%)
           5060  iTLB-load-misses      (scaled from 23.00%)
      112343016  branch-loads          (scaled from 22.76%)
        5528876  branch-load-misses    (scaled from 22.54%)

    0.427154051  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245934522.5308.39.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   45 ++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7939a21..430f060 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,23 +71,23 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
-	{ "L1-data",		"l1-d",		"l1d"			},
-	{ "L1-instruction",	"l1-i",		"l1i"			},
-	{ "L2",			"l2"					},
-	{ "Data-TLB",		"dtlb",		"d-tlb"			},
-	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
-	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
+ { "L1-d$",	"l1-d",		"L1-data",				},
+ { "L1-i$",	"l1-i",		"L1-instruction",			},
+ { "LLC",	"L2"							},
+ { "dTLB",	"d-tlb",	"Data-TLB",				},
+ { "iTLB",	"i-tlb",	"Instruction-TLB",			},
+ { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
 };
 
 static char *hw_cache_op[][MAX_ALIASES] = {
-	{ "Load",		"read"					},
-	{ "Store",		"write"					},
-	{ "Prefetch",		"speculative-read", "speculative-load"	},
+ { "load",	"loads",	"read",					},
+ { "store",	"stores",	"write",				},
+ { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
 static char *hw_cache_result[][MAX_ALIASES] = {
-	{ "Reference",		"ops",		"access"		},
-	{ "Miss"							},
+ { "refs",	"Reference",	"ops",		"access",		},
+ { "misses",	"miss",							},
 };
 
 #define C(x)		PERF_COUNT_HW_CACHE_##x
@@ -118,6 +118,22 @@ static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 		return 0;	/* invalid */
 }
 
+static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
+{
+	static char name[50];
+
+	if (cache_result) {
+		sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][0],
+			hw_cache_result[cache_result][0]);
+	} else {
+		sprintf(name, "%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][1]);
+	}
+
+	return name;
+}
+
 char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
@@ -137,7 +153,6 @@ char *event_name(int counter)
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
-		static char name[100];
 
 		cache_type   = (config >>  0) & 0xff;
 		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
@@ -153,12 +168,8 @@ char *event_name(int counter)
 
 		if (!is_cache_op_valid(cache_type, cache_op))
 			return "invalid-cache";
-		sprintf(name, "%s-Cache-%s-%ses",
-			hw_cache[cache_type][0],
-			hw_cache_op[cache_op][0],
-			hw_cache_result[cache_result][0]);
 
-		return name;
+		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
 	case PERF_TYPE_SOFTWARE:
