Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZKDNHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZKDNHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZKDNHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:07:03 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61125 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZKDNHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:07:01 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v3 0/7] Adding general performance benchmarking subcommand to perf.
Date: Wed,  4 Nov 2009 22:06:20 +0900
Message-Id: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add general benchmark subcommand to perf.

The subcommand will unify the benchmarking programs
and provide these in standardized way.

Hitoshi Mitake (7):
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.
  Adding general performance benchmarking subcommand to perf.

 tools/perf/Makefile                |    5 +
 tools/perf/bench/bench.h           |    9 +
 tools/perf/bench/sched-messaging.c |  332 ++++++++++++++++++++++++++++++++++++
 tools/perf/bench/sched-pipe.c      |  113 ++++++++++++
 tools/perf/builtin-bench.c         |  128 ++++++++++++++
 tools/perf/builtin.h               |    1 +
 tools/perf/perf.c                  |    1 +
 7 files changed, 589 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/bench.h
 create mode 100644 tools/perf/bench/sched-messaging.c
 create mode 100644 tools/perf/bench/sched-pipe.c
 create mode 100644 tools/perf/builtin-bench.c

