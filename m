Return-Path: <linux-kernel-owner+w=401wt.eu-S1764180AbZFMOwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180AbZFMOwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbZFMOus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:50:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:49139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763013AbZFMOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:50:45 -0400
Date: Sat, 13 Jun 2009 14:50:09 GMT
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
Subject: [tip:perfcounters/core] perf stat: Enable raw data to be printed
Message-ID: <tip-ef281a196d66b8bc2d067a3704712e5b93691fbc@git.kernel.org>
Git-Commit-ID: ef281a196d66b8bc2d067a3704712e5b93691fbc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:50:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef281a196d66b8bc2d067a3704712e5b93691fbc
Gitweb:     http://git.kernel.org/tip/ef281a196d66b8bc2d067a3704712e5b93691fbc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 13 Jun 2009 15:40:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 15:40:35 +0200

perf stat: Enable raw data to be printed

If -vv (very verbose) is specified, print out raw data
in the following format:

$ perf stat -vv -r 3 ./loop_1b_instructions

[ perf stat: executing run #1 ... ]
[ perf stat: executing run #2 ... ]
[ perf stat: executing run #3 ... ]

debug:              runtime[0]: 235871872
debug:             walltime[0]: 236646752
debug:       runtime_cycles[0]: 755150182
debug:            counter/0[0]: 235871872
debug:            counter/1[0]: 235871872
debug:            counter/2[0]: 235871872
debug:               scaled[0]: 0
debug:            counter/0[1]: 2
debug:            counter/1[1]: 235870662
debug:            counter/2[1]: 235870662
debug:               scaled[1]: 0
debug:            counter/0[2]: 1
debug:            counter/1[2]: 235870437
debug:            counter/2[2]: 235870437
debug:               scaled[2]: 0
debug:            counter/0[3]: 140
debug:            counter/1[3]: 235870298
debug:            counter/2[3]: 235870298
debug:               scaled[3]: 0
debug:            counter/0[4]: 755150182
debug:            counter/1[4]: 235870145
debug:            counter/2[4]: 235870145
debug:               scaled[4]: 0
debug:            counter/0[5]: 1001411258
debug:            counter/1[5]: 235868838
debug:            counter/2[5]: 235868838
debug:               scaled[5]: 0
debug:            counter/0[6]: 27897
debug:            counter/1[6]: 235868560
debug:            counter/2[6]: 235868560
debug:               scaled[6]: 0
debug:            counter/0[7]: 2910
debug:            counter/1[7]: 235868151
debug:            counter/2[7]: 235868151
debug:               scaled[7]: 0
debug:              runtime[0]: 235980257
debug:             walltime[0]: 236770942
debug:       runtime_cycles[0]: 755114546
debug:            counter/0[0]: 235980257
debug:            counter/1[0]: 235980257
debug:            counter/2[0]: 235980257
debug:               scaled[0]: 0
debug:            counter/0[1]: 3
debug:            counter/1[1]: 235980049
debug:            counter/2[1]: 235980049
debug:               scaled[1]: 0
debug:            counter/0[2]: 1
debug:            counter/1[2]: 235979907
debug:            counter/2[2]: 235979907
debug:               scaled[2]: 0
debug:            counter/0[3]: 135
debug:            counter/1[3]: 235979780
debug:            counter/2[3]: 235979780
debug:               scaled[3]: 0
debug:            counter/0[4]: 755114546
debug:            counter/1[4]: 235979652
debug:            counter/2[4]: 235979652
debug:               scaled[4]: 0
debug:            counter/0[5]: 1001439771
debug:            counter/1[5]: 235979304
debug:            counter/2[5]: 235979304
debug:               scaled[5]: 0
debug:            counter/0[6]: 23723
debug:            counter/1[6]: 235979050
debug:            counter/2[6]: 235979050
debug:               scaled[6]: 0
debug:            counter/0[7]: 2213
debug:            counter/1[7]: 235978820
debug:            counter/2[7]: 235978820
debug:               scaled[7]: 0
debug:              runtime[0]: 235888002
debug:             walltime[0]: 236700533
debug:       runtime_cycles[0]: 754881504
debug:            counter/0[0]: 235888002
debug:            counter/1[0]: 235888002
debug:            counter/2[0]: 235888002
debug:               scaled[0]: 0
debug:            counter/0[1]: 2
debug:            counter/1[1]: 235887793
debug:            counter/2[1]: 235887793
debug:               scaled[1]: 0
debug:            counter/0[2]: 1
debug:            counter/1[2]: 235887645
debug:            counter/2[2]: 235887645
debug:               scaled[2]: 0
debug:            counter/0[3]: 135
debug:            counter/1[3]: 235887499
debug:            counter/2[3]: 235887499
debug:               scaled[3]: 0
debug:            counter/0[4]: 754881504
debug:            counter/1[4]: 235887368
debug:            counter/2[4]: 235887368
debug:               scaled[4]: 0
debug:            counter/0[5]: 1001401731
debug:            counter/1[5]: 235887024
debug:            counter/2[5]: 235887024
debug:               scaled[5]: 0
debug:            counter/0[6]: 24212
debug:            counter/1[6]: 235886786
debug:            counter/2[6]: 235886786
debug:               scaled[6]: 0
debug:            counter/0[7]: 1824
debug:            counter/1[7]: 235886560
debug:            counter/2[7]: 235886560
debug:               scaled[7]: 0

 Performance counter stats for '/home/mingo/loop_1b_instructions' (3 runs):

     235.913377  task-clock-msecs     #      0.997 CPUs    ( +-   0.011% )
              2  context-switches     #      0.000 M/sec   ( +-   0.000% )
              1  CPU-migrations       #      0.000 M/sec   ( +-   0.000% )
            136  page-faults          #      0.001 M/sec   ( +-   0.730% )
      755048744  cycles               #   3200.534 M/sec   ( +-   0.009% )
     1001417586  instructions         #      1.326 IPC     ( +-   0.001% )
          25277  cache-references     #      0.107 M/sec   ( +-   3.988% )
           2315  cache-misses         #      0.010 M/sec   ( +-   9.845% )

    0.236706075  seconds time elapsed.

This allows the summary stats to be validated.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile       |    2 +-
 tools/perf/builtin-stat.c |   46 ++++++++++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0cbd5d6..e8346f9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -160,7 +160,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
-LDFLAGS = -lpthread -lrt -lelf
+LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9eb42b1..e5b3c0f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -324,9 +324,9 @@ static void print_counter(int counter)
 }
 
 /*
- * Normalize noise values down to stddev:
+ * normalize_noise noise values down to stddev:
  */
-static void normalize(__u64 *val)
+static void normalize_noise(__u64 *val)
 {
 	double res;
 
@@ -335,6 +335,13 @@ static void normalize(__u64 *val)
 	*val = (__u64)res;
 }
 
+static void update_avg(const char *name, int idx, __u64 *avg, __u64 *val)
+{
+	*avg += *val;
+
+	if (verbose > 1)
+		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
+}
 /*
  * Calculate the averages and noises:
  */
@@ -342,16 +349,23 @@ static void calc_avg(void)
 {
 	int i, j;
 
+	if (verbose > 1)
+		fprintf(stderr, "\n");
+
 	for (i = 0; i < run_count; i++) {
-		runtime_nsecs_avg += runtime_nsecs[i];
-		walltime_nsecs_avg += walltime_nsecs[i];
-		runtime_cycles_avg += runtime_cycles[i];
+		update_avg("runtime", 0, &runtime_nsecs_avg, runtime_nsecs + i);
+		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
+		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
 
 		for (j = 0; j < nr_counters; j++) {
-			event_res_avg[j][0] += event_res[i][j][0];
-			event_res_avg[j][1] += event_res[i][j][1];
-			event_res_avg[j][2] += event_res[i][j][2];
-			event_scaled_avg[j] += event_scaled[i][j];
+			update_avg("counter/0", j,
+				event_res_avg[j]+0, event_res[i][j]+0);
+			update_avg("counter/1", j,
+				event_res_avg[j]+1, event_res[i][j]+1);
+			update_avg("counter/2", j,
+				event_res_avg[j]+2, event_res[i][j]+2);
+			update_avg("scaled", j,
+				event_scaled_avg + j, event_scaled[i]+j);
 		}
 	}
 	runtime_nsecs_avg /= run_count;
@@ -382,14 +396,14 @@ static void calc_avg(void)
 		}
 	}
 
-	normalize(&runtime_nsecs_noise);
-	normalize(&walltime_nsecs_noise);
-	normalize(&runtime_cycles_noise);
+	normalize_noise(&runtime_nsecs_noise);
+	normalize_noise(&walltime_nsecs_noise);
+	normalize_noise(&runtime_cycles_noise);
 
 	for (j = 0; j < nr_counters; j++) {
-		normalize(&event_res_noise[j][0]);
-		normalize(&event_res_noise[j][1]);
-		normalize(&event_res_noise[j][2]);
+		normalize_noise(&event_res_noise[j][0]);
+		normalize_noise(&event_res_noise[j][1]);
+		normalize_noise(&event_res_noise[j][2]);
 	}
 }
 
@@ -399,8 +413,6 @@ static void print_stat(int argc, const char **argv)
 
 	calc_avg();
 
-	run_idx = 0;
-
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
