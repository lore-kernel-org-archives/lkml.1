Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZGJKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZGJKkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZGJKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:40:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:37708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZGJKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:40:42 -0400
Date: Fri, 10 Jul 2009 10:39:58 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, jaswinder@kernel.org,
       rdreier@cisco.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, jaswinder@kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090706120131.GB4391@kryten>
References: <20090706120131.GB4391@kryten>
Subject: [tip:perfcounters/core] perf_counter tools: Rename cache events to remove $
Message-ID: <tip-9590b7ba3fefdfe0c7741f5e2f61faf2ffcea19c@git.kernel.org>
Git-Commit-ID: 9590b7ba3fefdfe0c7741f5e2f61faf2ffcea19c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:39:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9590b7ba3fefdfe0c7741f5e2f61faf2ffcea19c
Gitweb:     http://git.kernel.org/tip/9590b7ba3fefdfe0c7741f5e2f61faf2ffcea19c
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 6 Jul 2009 22:01:31 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:04:06 +0200

perf_counter tools: Rename cache events to remove $

The cache events contain '$' which will hit shell variable
expansion. To avoid confusion change this to 'cache', ie
L1-d$-loads becomes L1-dcache-loads.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090706120131.GB4391@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5184959..518a33a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,8 +71,8 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
- { "L1-d$",	"l1-d",		"l1d",		"L1-data",		},
- { "L1-i$",	"l1-i",		"l1i",		"L1-instruction",	},
+ { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
+ { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
  { "LLC",	"L2"							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
