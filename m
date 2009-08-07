Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbZHGPJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbZHGPJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbZHGPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:09:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbZHGPJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:09:11 -0400
Date: Fri, 7 Aug 2009 17:09:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: perf-record fix and UI improvement
Message-ID: <20090807150901.GA11754@elte.hu>
References: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com> <1249650066.32113.706.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249650066.32113.706.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-08-07 at 14:15 +0200, Pierre Habouzit wrote:
> > While toying with perf, I've noticed that perf record can easily enter
> > a busy loop when doing something as silly as:
> > 
> >     $ perf record -A ls
> > 
> > I've searched why and here are the patches:
> > 
> >  [PATCH 1/2] perf util: do_read should fail on EOF instead of busy-looping.
> > 
> >    Yeah, do_read here really wants to read a known size, not being able
> >    to should die(), not busy-lopp ;)
> >    That was the cause for the bug.
> > 
> > 
> >  [PATCH 2/2] perf-record: improve -A UI for empty or non-existent perf.data
> > 
> >    Though with 1/2 `git record -A ls` would then fail miserably with
> >    some kind of "cannot read" error, which sucks. So this patch
> >    understands -A as a "append or create if file is empty or inexistant"
> > 
> >    This fact may deserve to be documented properly, if so just tell me
> >    I'll send an updated patch for Documentation/
> > 
> > 
> > I'm kind of new to the kernel world, so I hope I sent the patches to the
> > proper persons.
> 
> You did well for a first time ;-)
> 
> The things you can improve for next time are:
> 
>  - placing these nice descriptions you made above into the patches 
> themselves, as esp the first patch has an empty changelog.
> 
>  - get your email right :-)
> 
> Anyway, I think Ingo already fixed that up for you, so
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks - i've applied it.

	Ingo
