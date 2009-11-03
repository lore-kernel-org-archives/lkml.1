Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZKCK5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZKCK5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZKCK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:57:32 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63591 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZKCK5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:57:31 -0500
Date: Tue, 03 Nov 2009 19:57:31 +0900 (JST)
Message-Id: <20091103.195731.754697221080775468.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v2 7/7] Adding general performance benchmarking subcommand
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
This patch modifies Makefile for new files related to 'bench' subcommand.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e190d5..40cd847 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -391,6 +391,11 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
+BUILTIN_OBJS += builtin-bench.o
+
+# Benchmark modules
+BUILTIN_OBJS += bench/sched-messaging.o
+BUILTIN_OBJS += bench/sched-pipe.o
 
 PERFLIBS = $(LIB_FILE)
 
-- 
1.5.6.5

