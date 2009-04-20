Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZDTRz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZDTRz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZDTRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:55:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZDTRzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:55:46 -0400
Date: Mon, 20 Apr 2009 19:55:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
Message-ID: <20090420175533.GA22449@elte.hu>
References: <20090420173819.957332585@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420173819.957332585@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The first patch is a fix to a change to late_initcall that was 
> somehow dropped. Probably due to the issues that the patch was 
> causing and it may have conflicted with your temporary disabling 
> of the selftests.
> 
> The next patch is a compile fix for all tracing disabled.
> 
> The last two are recursive testing fixes.
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (4):
>       tracing/events: call the correct event trace selftest init function
>       tracing: remove dangling semicolon
>       tracing: fix recursive test level calculation
>       tracing: remove recursive test from ring_buffer_event_discard
> 
> ----
>  include/linux/trace_seq.h   |    2 +-
>  kernel/trace/ring_buffer.c  |    5 +++--
>  kernel/trace/trace_events.c |    2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> -- 

Pulled, thanks Steve!

	Ingo
