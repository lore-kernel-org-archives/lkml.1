Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYI0SIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYI0SIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYI0SI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:08:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYI0SI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:08:26 -0400
Date: Sat, 27 Sep 2008 20:08:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many
	thread hang.
Message-ID: <20080927180801.GC1108@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com> <20080916084143.GC17287@elte.hu> <1221678187.13420.17.camel@bobble.smo.corp.google.com> <20080918102353.GD20967@elte.hu> <1222114936.21579.20.camel@bobble.smo.corp.google.com> <1222291416.30299.6.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222291416.30299.6.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> A couple of days ago I re-resubmitted the itimer/many thread hang. 
> Unfortunately, I had too many things going on at once and screwed it 
> up, not verifying the UP version and entirely missing a set of 
> cleanups that I had intended to include.  This rectifies that screwup.
> 
> At Ingo's request, this is an incremental patch, relative to the code 
> in his -tip tree.
> 
> These changes have been minimally tested on both UP and SMP 
> environments.  They simplify the UP code, consolidating pretty much 
> all of it with the SMP version and depending on lower-level SMP/UP 
> handling to take care of the differences.  It also cleans up some UP 
> compile errors, moves the scheduler stats-related macros into 
> kernel/sched_stats.h, cleans up a merge error in kernel/fork.c and has 
> a few other minor fixes and cleanups as suggested by Oleg and Ingo. 
> Again, thanks for the reviews, guys.

applied to tip/timers/posixtimers, thanks Frank!

the additional simplifications in v2->v3:

   3 files changed, 38 insertions(+), 90 deletions(-)

look really good. If you dont hear from me it means -tip testing goes 
fine and the patches are queued up for v2.6.28.

	Ingo
