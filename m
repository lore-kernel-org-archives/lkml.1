Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbZFLLts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbZFLLts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZFLLtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:49:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:39086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZFLLti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:49:38 -0400
Date: Fri, 12 Jun 2009 11:49:02 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, yong.y.wang@intel.com,
       yong.y.wang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com,
       a.p.zijlstra@chello.nl, yong.y.wang@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090612031706.GA22126@ywang-moblin2.bj.intel.com>
References: <20090612031706.GA22126@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter tools: Remove one L1-data alias
Message-ID: <tip-faafec1e61e61d350248af2a7e5f047606adab6e@git.kernel.org>
Git-Commit-ID: faafec1e61e61d350248af2a7e5f047606adab6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 11:49:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  faafec1e61e61d350248af2a7e5f047606adab6e
Gitweb:     http://git.kernel.org/tip/faafec1e61e61d350248af2a7e5f047606adab6e
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Fri, 12 Jun 2009 11:17:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 13:45:09 +0200

perf_counter tools: Remove one L1-data alias

Otherwise all L1-instruction aliases will be recognized as
L1-data by strcasestr() when calling function parse_aliases.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090612031706.GA22126@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9d5f1ca..5a72586 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -75,7 +75,7 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache [][MAX_ALIASES] = {
-	{ "L1-data"		, "l1-d", "l1d", "l1"				},
+	{ "L1-data"		, "l1-d", "l1d"					},
 	{ "L1-instruction"	, "l1-i", "l1i"					},
 	{ "L2"			, "l2"						},
 	{ "Data-TLB"		, "dtlb", "d-tlb"				},
