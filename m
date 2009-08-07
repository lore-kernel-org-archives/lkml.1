Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZHGI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZHGI1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZHGI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:27:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbZHGI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:27:31 -0400
Date: Fri, 7 Aug 2009 10:27:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
Message-ID: <20090807082727.GB23910@elte.hu>
References: <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu> <4A7BD9EC.8000801@inria.fr> <20090807074525.GA20292@elte.hu> <4A7BE35F.4060604@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BE35F.4060604@inria.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> [PATCH] perf stat: change -S for --scale into -c

Applied, thanks Brice!

Find below the full changelog - i filled in the 'why' bits.

	Ingo

------------------------->
>From d4b2db0a624500c978f14393e6933d5d6aa552d2 Mon Sep 17 00:00:00 2001
From: Brice Goglin <Brice.Goglin@inria.fr>
Date: Fri, 7 Aug 2009 10:18:39 +0200
Subject: [PATCH] perf stat: Rename -S/--scale to -c/--scale

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
