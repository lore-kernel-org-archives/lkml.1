Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZFYT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZFYT6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZFYT6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:58:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:47814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbZFYT6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:58:12 -0400
Date: Thu, 25 Jun 2009 19:57:33 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, efault@gmx.de, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245945462.9157.11.camel@hpdv5.satnam>
References: <1245945462.9157.11.camel@hpdv5.satnam>
Subject: [tip:perfcounters/urgent] perf_counter tools: Add alias for 'l1d' and 'l1i'
Message-ID: <tip-4418351f06d9ce73acc846158c20186965f920f3@git.kernel.org>
Git-Commit-ID: 4418351f06d9ce73acc846158c20186965f920f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4418351f06d9ce73acc846158c20186965f920f3
Gitweb:     http://git.kernel.org/tip/4418351f06d9ce73acc846158c20186965f920f3
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Thu, 25 Jun 2009 21:27:42 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:54:53 +0200

perf_counter tools: Add alias for 'l1d' and 'l1i'

Add 'l1d' and 'l1i' aliases again as shortcuts - just dont make them
the primary display alias.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1245945462.9157.11.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 430f060..4d042f1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,8 +71,8 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
- { "L1-d$",	"l1-d",		"L1-data",				},
- { "L1-i$",	"l1-i",		"L1-instruction",			},
+ { "L1-d$",	"l1-d",		"l1d",		"L1-data",		},
+ { "L1-i$",	"l1-i",		"l1i",		"L1-instruction",	},
  { "LLC",	"L2"							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
