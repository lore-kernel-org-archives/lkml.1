Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZHJUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZHJUzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZHJUz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:55:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60987 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZHJUzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:55:23 -0400
Date: Mon, 10 Aug 2009 16:53:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <d1a228daf853b6a044e03b5bac1b06d0996bf745.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 11/12] add more namespace area to 'perf list' output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new syscall tracepoints can be too long for the 'perf list' output. Add
a few more characters.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 tools/perf/util/parse-events.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4858d83..a5d661b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -606,7 +606,7 @@ static void print_tracepoint_events(void)
 								evt_path, st) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			fprintf(stderr, "  %-40s [%s]\n", evt_path,
+			fprintf(stderr, "  %-42s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
 		}
 		closedir(evt_dir);
@@ -640,7 +640,7 @@ void print_events(void)
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
+		fprintf(stderr, "  %-42s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
@@ -654,7 +654,7 @@ void print_events(void)
 				continue;
 
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				fprintf(stderr, "  %-40s [%s]\n",
+				fprintf(stderr, "  %-42s [%s]\n",
 					event_cache_name(type, op, i),
 					event_type_descriptors[4]);
 			}
@@ -662,7 +662,7 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
+	fprintf(stderr, "  %-42s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
-- 
1.6.2.5

