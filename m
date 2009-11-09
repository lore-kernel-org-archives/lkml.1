Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZKIRDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZKIRDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZKIRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:03:32 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51881 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZKIRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:03:28 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf bench: Add stuffs to bench.h for unified output formatting
Date: Tue, 10 Nov 2009 02:03:23 +0900
Message-Id: <1257786206-9208-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257786206-9208-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257786206-9208-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some constants and extern declaration to bench.h.
These stuffs are used for unified output formatting
of 'perf bench'.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/bench/bench.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 59adb27..42167ea 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -6,4 +6,13 @@ extern int bench_sched_messaging(int argc, const char **argv,
 extern int bench_sched_pipe(int argc, const char **argv,
 			    const char *prefix);
 
+#define BENCH_FORMAT_DEFAULT_STR "default"
+#define BENCH_FORMAT_DEFAULT 0
+#define BENCH_FORMAT_SIMPLE_STR "simple"
+#define BENCH_FORMAT_SIMPLE 1
+
+#define BENCH_FORMAT_UNKNOWN -1
+
+extern int bench_format;
+
 #endif
-- 
1.5.6.5

