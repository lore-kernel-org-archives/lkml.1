Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZKJEW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZKJEW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZKJEW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:22:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:45897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKJEW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:22:27 -0500
Date: Tue, 10 Nov 2009 04:22:04 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257808802-9420-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257808802-9420-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add format constants to bench.h for unified output formatting
Message-ID: <tip-242aa14a67f4e19453fc8a51cffc5ac5ee5bcbd1@git.kernel.org>
Git-Commit-ID: 242aa14a67f4e19453fc8a51cffc5ac5ee5bcbd1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  242aa14a67f4e19453fc8a51cffc5ac5ee5bcbd1
Gitweb:     http://git.kernel.org/tip/242aa14a67f4e19453fc8a51cffc5ac5ee5bcbd1
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Tue, 10 Nov 2009 08:19:59 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:53:48 +0100

perf bench: Add format constants to bench.h for unified output formatting

This patch adds some constants and extern declaration to
bench.h. These are used for unified output formatting
of 'perf bench'.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257808802-9420-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
