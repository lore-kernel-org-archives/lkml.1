Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbZKEAbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbZKEAbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbZKEAbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:31:44 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50499 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbZKEAbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:31:43 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v5 7/7] Modyfing Makefile to build subcommand 'bench'
Date: Thu,  5 Nov 2009 09:31:37 +0900
Message-Id: <1257381097-4743-8-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Makefile for new files related to 'bench' subcommand.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a130134..17f8e9d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -427,6 +427,12 @@ BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 BUILTIN_OBJS += builtin-probe.o
+BUILTIN_OBJS += builtin-bench.o
+
+# Benchmark modules
+BUILTIN_OBJS += bench/sched-messaging.o
+BUILTIN_OBJS += bench/sched-pipe.o
+
 
 PERFLIBS = $(LIB_FILE)
 
-- 
1.6.5.2

