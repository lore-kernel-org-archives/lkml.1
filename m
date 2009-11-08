Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZKHJZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZKHJZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZKHJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:25:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:34927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZKHJZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:25:32 -0500
Date: Sun, 8 Nov 2009 09:24:45 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add new directory and header for new subcommand 'bench'
Message-ID: <tip-c426bba069e65ea438880a04aa4e7c5b880e1728@git.kernel.org>
Git-Commit-ID: c426bba069e65ea438880a04aa4e7c5b880e1728
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c426bba069e65ea438880a04aa4e7c5b880e1728
Gitweb:     http://git.kernel.org/tip/c426bba069e65ea438880a04aa4e7c5b880e1728
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:31 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:15 +0100

perf bench: Add new directory and header for new subcommand 'bench'

This patch adds bench/ directory and bench/bench.h.

bench/ directory will contain modules for bench subcommand.
bench/bench.h is for listing prototypes of module functions.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/bench.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

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
