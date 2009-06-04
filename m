Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZFDF0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZFDF0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZFDF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZFDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:12 -0400
Message-Id: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] [GIT PULL] tracing/branch-profiler: per cpu and other things
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-5


Steven Rostedt (6):
      tracing/function-profiler: do not free per cpu variable stat
      tracing/branch-profiler: fix return value check on register_stat_tracer
      tracing/branch-profiler: do not profile managers
      tracing/branch-profiler: move macro defines to kernel.h
      tracing/branch-profiling: add variable to disable branch profiling
      tracing/branch-profiler: add option to profile branches per cpu

----
 include/asm-generic/vmlinux.lds.h |   16 +++++-
 include/linux/compiler.h          |   85 +---------------------------------
 include/linux/kernel.h            |   92 +++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                   |   10 ++++
 kernel/trace/Kconfig              |   13 +++++
 kernel/trace/ftrace.c             |    5 +-
 kernel/trace/trace_branch.c       |   73 ++++++++++++++++++++++++++++-
 7 files changed, 202 insertions(+), 92 deletions(-)
-- 
