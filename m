Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZKJLvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZKJLvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZKJLu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:50:59 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61595 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZKJLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:50:56 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf bench: Modify command-list.txt for the entry of perf-bench
Date: Tue, 10 Nov 2009 20:50:55 +0900
Message-Id: <1257853855-28934-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies command-list.txt for the entry of perf-bench.
So perf will show 'bench' in command list.

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
---
 tools/perf/command-list.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 6475db4..161322b 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -12,3 +12,4 @@ perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
+perf-bench			mainporcelain common
-- 
1.6.5.2

