Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZKCKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZKCKy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZKCKy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:54:28 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63484 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZKCKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:54:28 -0500
Date: Tue, 03 Nov 2009 19:54:28 +0900 (JST)
Message-Id: <20091103.195428.512133494850477817.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v2 1/7] Adding general performance benchmarking subcommand
 to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding general performance benchmarking subcommand to perf.
This patch is version 2. But still (and always) comments are welcome.

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

