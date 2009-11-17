Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZKQPPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZKQPPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZKQPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:15:10 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56790 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZKQPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:15:05 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH v2 4/4] perf bench: Modify Makefile for new source file mem-memcpy.c
Date: Wed, 18 Nov 2009 00:15:03 +0900
Message-Id: <1258470903-29577-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091118.001135.11492872.mitake@dcl.info.waseda.ac.jp>
References: <20091118.001135.11492872.mitake@dcl.info.waseda.ac.jp>
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
index 5d1a8b0..b356987 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,6 +430,7 @@ BUILTIN_OBJS += builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
+BUILTIN_OBJS += bench/mem-memcpy.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
-- 
1.6.5.2

