Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZKJNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZKJNRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZKJNRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:17:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZKJNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:17:49 -0500
Date: Tue, 10 Nov 2009 14:17:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] perf bench: Clean and add document for perf-bench
Message-ID: <20091110131738.GA31158@elte.hu>
References: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch series cleans bench/bench.h for readability and
> adds new document describing perf-bench.
> 
> Hitoshi Mitake (3):
>   perf bench: Clean bench/bench.h
>   perf bench: Add new document of perf-bench
>   perf bench: Modify command-list.txt for the entry of perf-bench
> 
>  tools/perf/Documentation/perf-bench.txt |  120 +++++++++++++++++++++++++++++++
>  tools/perf/bench/bench.h                |   16 ++---
>  tools/perf/command-list.txt             |    1 +
>  3 files changed, 128 insertions(+), 9 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-bench.txt

Applied, thanks!

Btw., a small detail i noticed when running the pipe benchmark:

earth4:~/tip/tools/perf> ./perf bench sched pipe
(executing 1000000 pipe operations between two tasks)

	Total time:5.076 sec
		5.076232 usecs/op
		196996 ops/sec

when i typed 'perf bench sched pipe' nothing happened for several 
seconds. The command did not finish and no output was printed.

This might surprise users - it's always good to print a single line that 
we are processing a benchmark. Maybe this could be printed from the 
generic subcommand, something like:

  running sched/pipe benchmark ...

What do you think?

	Ingo
