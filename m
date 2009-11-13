Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZKMEXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZKMEXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 23:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZKMEXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 23:23:11 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50383 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbZKMEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 23:23:07 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH 2/4] perf bench: Modify bench/bench.h for new prototype: bench_mem_memcpy()
Date: Fri, 13 Nov 2009 13:23:04 +0900
Message-Id: <1258086186-32317-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts new prototype of bench_mem_memcpy().

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/bench/bench.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 9fbd8d7..1670e32 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -3,6 +3,7 @@
 
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
+extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
-- 
1.6.5.2

