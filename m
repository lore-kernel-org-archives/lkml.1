Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZEIE1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZEIE1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 00:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZEIE1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 00:27:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZEIE1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 00:27:31 -0400
Date: Sat, 9 May 2009 06:27:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: updates for tip
Message-ID: <20090509042714.GE8007@elte.hu>
References: <20090508203605.361898511@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508203605.361898511@goodmis.org>
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
> The first patch fixes a uninitialized variable. What bothers me 
> about this, is that gcc did not warn about it. My gcc warns about 
> a ton of variables that might not being initialized, but missed 
> one that actually is not!
> 
> I wonder if it is only my version of gcc:  4.2.2
> :-/
> 
> Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Steven Rostedt (2):
>       tracing: initialize return value for __ftrace_set_clr_event
>       tracing: add trace_set_clr_event to export event enabling function
> 
> ----
>  include/linux/ftrace_event.h |    2 ++
>  kernel/trace/trace_events.c  |   19 ++++++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

Note, the above branch gave conflicts in ring_buffer.c. But i pulled 
at commit 4671c79 from your tree which gave the same diffstat:

 Fast forward
  include/linux/ftrace_event.h |    2 ++
  kernel/trace/trace_events.c  |   19 ++++++++++++++++++-
  2 files changed, 20 insertions(+), 1 deletions(-)

Please double-check that i got the right bits. Thanks,

	Ingo
