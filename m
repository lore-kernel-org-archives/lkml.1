Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZKJN0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZKJN0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbZKJN0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:26:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:34300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbZKJN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:26:07 -0500
Date: Tue, 10 Nov 2009 13:25:45 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257853855-28934-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257853855-28934-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Modify command-list.txt for the entry of perf-bench
Message-ID: <tip-8d8d61aadb9d8cce07f7dcdb77a4c20a25d36d07@git.kernel.org>
Git-Commit-ID: 8d8d61aadb9d8cce07f7dcdb77a4c20a25d36d07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d8d61aadb9d8cce07f7dcdb77a4c20a25d36d07
Gitweb:     http://git.kernel.org/tip/8d8d61aadb9d8cce07f7dcdb77a4c20a25d36d07
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Tue, 10 Nov 2009 20:50:55 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 14:14:36 +0100

perf bench: Modify command-list.txt for the entry of perf-bench

This patch modifies command-list.txt for the entry of
perf-bench. So perf will show 'bench' in command list.

Example:
% perf

 usage: perf [--version] [--help] COMMAND [ARGS]

 The most commonly used perf commands are:
   annotate    Read perf.data (created by perf record) and display annotated code
   bench       General framework for benchmark suites
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   list        List all symbolic event types
   probe       Define new dynamic tracepoints
   record      Run a command and record its profile into perf.data
   report      Read perf.data (created by perf record) and display the profile
   sched       Tool to trace/measure scheduler properties (latencies)
   stat        Run a command and gather performance counter statistics
   timechart   Tool to visualize total system behavior during a workload
   top         System profiling tool.
   trace       Read perf.data (created by perf record) and display trace output

 See 'perf help COMMAND' for more information on a specific command.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257853855-28934-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/command-list.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 00326e2..981c40b 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -3,6 +3,7 @@
 # command name			category [deprecated] [common]
 #
 perf-annotate			mainporcelain common
+perf-bench			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
 perf-record			mainporcelain common
