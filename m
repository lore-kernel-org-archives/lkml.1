Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZKEAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZKEAbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZKEAbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:31:41 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50429 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbZKEAbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:31:38 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v5 0/7] Adding general performance benchmarking subcommand to perf.
Date: Thu,  5 Nov 2009 09:31:30 +0900
Message-Id: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add general benchmark subcommand to perf.

The subcommand will unify the benchmarking programs
and provide these in standardized way.

I fixed this series for latest tip tree.
My previous patch series conflicts with cmd_probe().
So please discard v4 and use this v5.

Hitoshi Mitake (7):
  Adding new directory and header for new subcommand 'bench'
  sched-messaging.c: benchmark for scheduler and IPC mechanisms based
    on hackbench
  sched-pipe.c: benchmark for pipe() system call
  builtin-bench.c: General framework for benchmark suites
  Modifying builtin.h for new prototype
  Modyfing perf.c for subcommand 'bench'
  Modyfing Makefile to build subcommand 'bench'

 tools/perf/Makefile                |    6 +
 tools/perf/bench/bench.h           |    9 +
 tools/perf/bench/sched-messaging.c |  332 ++++++++++++++++++++++++++++++++++++
 tools/perf/bench/sched-pipe.c      |  113 ++++++++++++
 tools/perf/builtin-bench.c         |  128 ++++++++++++++
 tools/perf/builtin.h               |    1 +
 tools/perf/perf.c                  |    1 +
 7 files changed, 590 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/bench.h
 create mode 100644 tools/perf/bench/sched-messaging.c
 create mode 100644 tools/perf/bench/sched-pipe.c
 create mode 100644 tools/perf/builtin-bench.c

