Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZHGIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZHGIbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZHGIbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:31:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbZHGIbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:31:31 -0400
Date: Fri, 7 Aug 2009 08:30:52 GMT
From: tip-bot for Brice Goglin <Brice.Goglin@inria.fr>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brice.Goglin@inria.fr, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, Brice.Goglin@inria.fr,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A7BE35F.4060604@inria.fr>
References: <4A7BE35F.4060604@inria.fr>
Subject: [tip:perfcounters/core] perf stat: Rename -S/--scale to -c/--scale
Message-ID: <tip-d4b2db0a624500c978f14393e6933d5d6aa552d2@git.kernel.org>
Git-Commit-ID: d4b2db0a624500c978f14393e6933d5d6aa552d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 08:30:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4b2db0a624500c978f14393e6933d5d6aa552d2
Gitweb:     http://git.kernel.org/tip/d4b2db0a624500c978f14393e6933d5d6aa552d2
Author:     Brice Goglin <Brice.Goglin@inria.fr>
AuthorDate: Fri, 7 Aug 2009 10:18:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 10:26:12 +0200

perf stat: Rename -S/--scale to -c/--scale

We want to use a coherent flag for -S/--stat across all tools,
so free up -S in perf stat.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
LKML-Reference: <4A7BE35F.4060604@inria.fr>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-stat.txt |    2 +-
 tools/perf/builtin-stat.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 0d74346..484080d 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -40,7 +40,7 @@ OPTIONS
 -a::
         system-wide collection
 
--S::
+-c::
         scale counter values
 
 EXAMPLES
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f9510ee..b4b06c7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -496,7 +496,7 @@ static const struct option options[] = {
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('S', "scale", &scale,
+	OPT_BOOLEAN('c', "scale", &scale,
 		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
