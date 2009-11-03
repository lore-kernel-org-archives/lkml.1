Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZKCEgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZKCEgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZKCEgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:36:15 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60208 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbZKCEgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:36:15 -0500
Date: Tue, 03 Nov 2009 13:36:15 +0900 (JST)
Message-Id: <20091103.133615.1066539147061640148.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [RFC][PATCH 1/7] Adding general performance benchmarking subsystem
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
This patch modifies Makefile of perf to build new source files.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e190d5..f6f7a6b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -391,6 +391,9 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
+BUILTIN_OBJS += builtin-bench.o
+BUILTIN_OBJS += builtin-bench-messaging.o
+BUILTIN_OBJS += builtin-bench-pipe.o
 
 PERFLIBS = $(LIB_FILE)
 
-- 
1.5.6.5

