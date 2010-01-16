Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0APG4R (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632Ab0APG4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:56:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0APG4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:56:15 -0500
Date: Sat, 16 Jan 2010 07:56:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH 0/8][GIT PULL][v2.6.33] tracing: fixes
Message-ID: <20100116065608.GA29176@elte.hu>
References: <20100115035726.462940848@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115035726.462940848@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> The patches fix one recordmcount.pl bug, and the rest fix
> the filters for ftrace and the events.
> 
> Please pull the latest tip/tracing/urgent-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent-1
> 
> 
> Jan Kiszka (1):
>       tracing/x86: Derive arch from bits argument in recordmcount.pl
> 
> Li Zefan (7):
>       ftrace: Fix MATCH_END_ONLY function filter
>       tracing/filters: Fix MATCH_FRONT_ONLY filter matching
>       tracing/filters: Fix MATCH_END_ONLY filter matching
>       lib: Introduce strnstr()
>       tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
>       tracing/filters: Fix MATCH_FULL filter matching for PTR_STRING
>       tracing/filters: Add comment for match callbacks
> 
> ----
>  include/linux/string.h             |    5 ++++-
>  kernel/trace/ftrace.c              |    6 +++---
>  kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
>  lib/string.c                       |   27 ++++++++++++++++++++++++++-
>  scripts/recordmcount.pl            |    2 +-
>  5 files changed, 54 insertions(+), 15 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
