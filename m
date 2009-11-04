Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZKDNIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZKDNIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZKDNHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:07:23 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61189 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZKDNHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:07:20 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v3 5/7] Adding general performance benchmarking subcommand to perf.
Date: Wed,  4 Nov 2009 22:06:25 +0900
Message-Id: <1257339987-22953-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257339987-22953-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is version 3. But still (and always) comments are welcome.
This patch modifies builtin.h to add prototype of cmd_bench().

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

