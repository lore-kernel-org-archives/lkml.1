Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZKHJ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZKHJ1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZKHJ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:27:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:60147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbZKHJ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:27:06 -0500
Date: Sun, 8 Nov 2009 09:26:29 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-8-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-8-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add subcommand 'bench' to the Makefile
Message-ID: <tip-bfde82ef51e3ea6ab8634d0fdbf5adcdd1b429cb@git.kernel.org>
Git-Commit-ID: bfde82ef51e3ea6ab8634d0fdbf5adcdd1b429cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfde82ef51e3ea6ab8634d0fdbf5adcdd1b429cb
Gitweb:     http://git.kernel.org/tip/bfde82ef51e3ea6ab8634d0fdbf5adcdd1b429cb
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:37 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:20 +0100

perf bench: Add subcommand 'bench' to the Makefile

This patch modifies Makefile for new files related to 'bench'
subcommand. The new code is active from this point on.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-8-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 542b29e..0a25428 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -416,6 +416,13 @@ LIB_OBJS += util/hist.o
 LIB_OBJS += util/data_map.o
 
 BUILTIN_OBJS += builtin-annotate.o
+
+BUILTIN_OBJS += builtin-bench.o
+
+# Benchmark modules
+BUILTIN_OBJS += bench/sched-messaging.o
+BUILTIN_OBJS += bench/sched-pipe.o
+
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-list.o
