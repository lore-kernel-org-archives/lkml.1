Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZIXTUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZIXTUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZIXTUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:20:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZIXTUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:20:05 -0400
Date: Thu, 24 Sep 2009 21:20:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Dont use openat()
Message-ID: <20090924192002.GB19225@elte.hu>
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu> <4ABB767D.6080004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABB767D.6080004@gmail.com>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Ingo Molnar a ?crit :
> > * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> >> Hi Ingo
> >>
> >> Here is a patch for perf.
> > 
> > Applied, thanks Eric!
> > 
> >> BTW, use of openat() is a nuisance, since many machines have old glibc
> >> (RHEL 4 Update 5 -> glibc-2.3.4-2.36 on my dev machine for example)
> > 
> > We can certainly remove that reliance - wanna send a patch for it?
> 
> Here it is
> 
> Thanks
> 
> [PATCH] perf tools: Dont use openat()
> 
> openat() is still a young glibc facility, better to not use it
> in a non performance critical program (perf list)
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  tools/perf/util/parse-events.c |   49 ++++++++++++-------------------
>  1 files changed, 20 insertions(+), 29 deletions(-)

Applied, thanks Eric! I think it's also significant enough to be pushed 
to 2.6.32.

	Ingo
