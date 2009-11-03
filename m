Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZKCEgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZKCEgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZKCEgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:36:45 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60229 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbZKCEgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:36:45 -0500
Date: Tue, 03 Nov 2009 13:36:45 +0900 (JST)
Message-Id: <20091103.133645.1116588942663460777.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [RFC][PATCH 2/7] Adding general performance benchmarking subsystem
 to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding general performance benchmarking subsystem to perf.
This patch add new file: bench-suite.h

bench-suite.h contains prototypes of benchmark suite functions.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/bench-suite.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench-suite.h

diff --git a/tools/perf/bench-suite.h b/tools/perf/bench-suite.h
new file mode 100644
index 0000000..65f6f55
--- /dev/null
+++ b/tools/perf/bench-suite.h
@@ -0,0 +1,7 @@
+#ifndef BENCH_SUITE_H
+#define BENCH_SUITE_H
+
+extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
+extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
+
+#endif
-- 
1.5.6.5

