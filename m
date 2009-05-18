Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZERIVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZERIVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZERIVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:21:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZERIVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:21:05 -0400
Date: Mon, 18 May 2009 10:20:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] tracing/stat: cleanups, latency
Message-ID: <20090518082051.GB10687@elte.hu>
References: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Here are two patches for the stat tracing. I would also like to do 
> more work on the stat tracing to make it able to manage by itself 
> the entries for the tracers, ie: the memory allocation, accesses, 
> locking, releases, etc...
> 
> And the workqueue tracer would be a good base to work on it. Then 
> Ingo, if you pull this, could you please also merge tracing/core 
> into tracing/workqueue, so that I can continue the work with these 
> patches and prepare pull requests against tracing/workqueue. It 
> should be mergeable without conflicts, I just applied the raw 
> patches from this pull-request into tracing/workqueue and it was 
> fine.

sure, i've done that!

> The following changes since commit 5872144f64b34a5942f6b4acedc90b02de72c58b:
>   Li Zefan (1):
>         tracing/filters: fix off-by-one bug
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Frederic Weisbecker (2):
>       tracing/stat: replace trace_stat_session by stat_session
>       tracing/stat: replace linked list by an rbtree for sorting
> 
>  kernel/trace/trace_stat.c |  166 ++++++++++++++++++++++++++++++--------------
>  1 files changed, 113 insertions(+), 53 deletions(-)

Pulled, thanks Frederic.

Note, i've rebased this on top of the tracing/workqueues topic and 
have merged both into tip:master. You can use tracing/stat as a Git 
basis. (assuming it survives today's testing in -tip without 
requiring a rebase)

	Ingo
