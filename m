Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZKQLmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZKQLmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZKQLmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:42:39 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55062 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZKQLmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:42:37 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH 4/4] perf bench: Modify Makefile for new source file mem-memcpy.c
Date: Tue, 17 Nov 2009 20:42:33 +0900
Message-Id: <1258458153-25700-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091117112148.GA32578@elte.hu>
References: <20091117112148.GA32578@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Makefile to build new source file mem-memcpy.c,
benchmark suite for memcpy() performance.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cd42c97..9b25bca 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -428,6 +428,7 @@ BUILTIN_OBJS += builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
+BUILTIN_OBJS += bench/mem-memcpy.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
-- 
1.6.5.2

