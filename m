Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZKIXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZKIXUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZKIXUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:20:14 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54793 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZKIXUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:20:13 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 0/4] perf bench: Common option for specifying style formatting
Date: Tue, 10 Nov 2009 08:19:58 +0900
Message-Id: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds new option "--format" to
bench subcommand of perf.

Users of perf bench will be able to specify
style formatting with this option in common way.

Hitoshi Mitake (4):
  perf bench: Add stuffs to bench.h for unified output formatting
  perf bench: Modify builtin-bench.c for processing common options
  perf bench: Modified bench/bench-messaging.c to adopt unified output
    formatting
  perf bench: Modify builtin-pipe.c for processing common options

 tools/perf/bench/bench.h           |    9 ++++
 tools/perf/bench/sched-messaging.c |   18 +++++---
 tools/perf/bench/sched-pipe.c      |   22 ++++++----
 tools/perf/builtin-bench.c         |   79 +++++++++++++++++++++++++++++------
 4 files changed, 99 insertions(+), 29 deletions(-)

