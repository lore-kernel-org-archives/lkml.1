Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZF0Qqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZF0Qqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZF0QqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:46:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZF0QqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:46:24 -0400
Date: Sat, 27 Jun 2009 18:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] perf stat: Fix multi-run stats
Message-ID: <20090627164551.GB17638@elte.hu>
References: <tip-566747e6298289c5cb02d4939cb3abf1c4fe7e5a@git.kernel.org> <1246091190.2961.10.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246091190.2961.10.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-06-27 at 04:36 +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  566747e6298289c5cb02d4939cb3abf1c4fe7e5a
> > Gitweb:     http://git.kernel.org/tip/566747e6298289c5cb02d4939cb3abf1c4fe7e5a
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Sat, 27 Jun 2009 06:24:32 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 27 Jun 2009 06:34:37 +0200
> > 
> > perf stat: Fix multi-run stats
> > 
> > In multi-run (-r/--repeat) printouts, print out the noise of
> > the wall-clock average as well.
> > 
> > Also, fix a bug in printing out scaled counters: if it was not
> > scaled then we should not update the average with -1.
> > 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  tools/perf/builtin-stat.c |   15 +++++++++++----
> >  1 files changed, 11 insertions(+), 4 deletions(-)
> > 
> 
> 
> hmm, why you are keep on changing tools/perf/builtin-stat.c you 
> know my patches are in queue which I prepared on your request and 
> send pull request:
> 
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=commitdiff;h=4e3340cd3087c4228350af04c2fc8f6502eb6ad6
> 
> In spite of adding the patches you keep on changing the original 
> file ??

Two things:

 - My changes and your changes do not conflict - i was able to
   apply your patches on top of my changes.

 - I could have applied all three patches of yours but i only
   applied the first one because the second and third did not
   implement the feature you are trying to add in an adequate
   way.

Also, i do not 'request' things from you, i am not your boss. I 
review patches and i reject patches i find inadequate. You are
free to submit new versions - or you are free to not do so. If
you submit new versions i will review them too and will merge
them or tell why i didnt merge them.

	Ingo
