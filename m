Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZKDNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZKDNHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZKDNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:07:21 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61144 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbZKDNHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:07:13 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v3 1/7] Adding general performance benchmarking subcommand to perf.
Date: Wed,  4 Nov 2009 22:06:21 +0900
Message-Id: <1257339987-22953-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is version 3. But still (and always) comments are welcome.

This patch adds bench/ directory and bench/bench.h.
bench/ directory will contain modules for bench subcommand.
bench/bench.h is for listing prototypes of module functions.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>

---
 tools/perf/bench/bench.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/bench.h

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
new file mode 100644
index 0000000..59adb27
--- /dev/null
+++ b/tools/perf/bench/bench.h
@@ -0,0 +1,9 @@
+#ifndef BENCH_H
+#define BENCH_H
+
+extern int bench_sched_messaging(int argc, const char **argv,
+				 const char *prefix);
+extern int bench_sched_pipe(int argc, const char **argv,
+			    const char *prefix);
+
+#endif
-- 
1.5.6.5

