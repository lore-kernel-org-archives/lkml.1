Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZLBIKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZLBIKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZLBIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:10:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49350 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZLBIKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:10:13 -0500
Message-ID: <4B162089.8000907@cn.fujitsu.com>
Date: Wed, 02 Dec 2009 16:08:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event: fix compile error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc1: warnings being treated as errors
builtin-probe.c: In function ‘cmd_probe’:
builtin-probe.c:163: error: unused variable ‘fd’

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-probe.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index b5d15cf..64ea038 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -160,7 +160,8 @@ static const struct option options[] = {
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, fd, ret;
+	int i, j, ret;
+	int fd __used;
 	struct probe_point *pp;
 
 	argc = parse_options(argc, argv, options, probe_usage,
-- 
1.6.1.2

