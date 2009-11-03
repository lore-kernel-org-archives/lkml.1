Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZKCEhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZKCEhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZKCEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:37:49 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60261 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbZKCEht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:37:49 -0500
Date: Tue, 03 Nov 2009 13:37:49 +0900 (JST)
Message-Id: <20091103.133749.851593939415662052.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [RFC][PATCH 4/7] Adding general performance benchmarking subsystem
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
This patch modifies builtin.h to add prototype of bench.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index e11d8d2..b346b66 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -25,5 +25,6 @@ extern int cmd_timechart(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
+extern int cmd_bench(int argc, const char **argv, const char *prefix);
 
 #endif
-- 
1.5.6.5

