Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZG2RNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZG2RNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZG2RNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:13:33 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:63379 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZG2RNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wyzNhYKXq+uRcJC/Slr8W5VP+M4G80ayz9VjN8IVx9MT86XY0qvLmFVkfY+PYby4Xw
         0F7ybhGvb9CTooMGMkZhxflBWnVFHM+zf5ZuAXNFFbxxKWSRl8EPathnkGW8H+Cmnosv
         Z201todGjXNwujvrlzz6kHdzQqz2Vg+ND+xgg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing: Various cleanups for 2.6.32
Date: Wed, 29 Jul 2009 19:13:23 +0200
Message-Id: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Ingo,

These patches are the result of various cleanups in the tracing
subsystem: algorithms simpifications, and various trace.c to tracer
files moving.

Thanks,
Frederic.

The following changes since commit d34a4debef933061924ee17c2ede33f5c44925fb:
  jolsa@redhat.com (1):
        tracing: Remove .globl in the scripts/recordmcount.pl doc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core

Frederic Weisbecker (5):
      tracing/function-graph-tracer: Drop the useless nmi protection
      tracing/function-tracer: Move trace_function() in the function tracer file
      tracing/core: Make the stack entry helpers global
      tracing: Move sched event insertion helpers in the sched switch tracer file
      tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file

Lai Jiangshan (1):
      tracing: Simplify print_graph_cpu()

 arch/x86/kernel/ftrace.c             |    4 -
 kernel/trace/trace.c                 |  217 ++--------------------------------
 kernel/trace/trace.h                 |   30 ++++-
 kernel/trace/trace_functions.c       |   25 ++++
 kernel/trace/trace_functions_graph.c |  152 +++++++++++++++++++-----
 kernel/trace/trace_sched_switch.c    |   57 +++++++++
 kernel/trace/trace_selftest.c        |    1 +
 7 files changed, 242 insertions(+), 244 deletions(-)
