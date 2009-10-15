Return-Path: <linux-kernel-owner+w=401wt.eu-S934908AbZJOI4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbZJOI4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZJOI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:56:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZJOI4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:56:10 -0400
Date: Thu, 15 Oct 2009 10:55:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/13] [GIT PULL] perf tools: updates to parsing events
Message-ID: <20091015085508.GA10546@elte.hu>
References: <20091014194330.980165492@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014194330.980165492@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> perf/core
> 
> 
> Steven Rostedt (13):
>       perf tools: handle print concatinations in event format file
>       perf tools: fix backslash processing on trace print formats
>       perf tools: handle trace parsing of '<' and '>'
>       perf tools: handle arrays in print fields for trace parsing
>       perf tools: handle '*' as typecast in trace parsing
>       perf tools: handle newlines in trace parsing better
>       perf tools: handle the case with and without the "signed" trace field
>       perf tools: still continue on failed parsing of an event
>       perf tools: fix bprintk reading in trace output
>       perf tools: handle both versions of ftrace output
>       perf tools: add latency format to trace output
>       perf tools: handle '-' and '+' in parsing trace print format
>       perf tools: remove all char * typecasts and use const in prototype
> 
> ----
>  tools/perf/Makefile                 |    2 +-
>  tools/perf/builtin-trace.c          |    2 +
>  tools/perf/util/trace-event-parse.c |  533 +++++++++++++++++++++++++----------
>  tools/perf/util/trace-event.h       |   25 ++-
>  4 files changed, 405 insertions(+), 157 deletions(-)

Applied, thanks Steve! Very nice changes/fixes!

	Ingo
