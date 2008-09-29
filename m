Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYI2Jrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYI2Jrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYI2JrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:47:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYI2JrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:47:22 -0400
Date: Mon, 29 Sep 2008 11:47:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Pekka Paalanen <pq@iki.fi>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20080929094708.GA19252@elte.hu>
References: <48DD0347.5070008@gmail.com> <20080928192909.30e0f5dd@daedalus.pq.iki.fi> <20080929090231.GD2190@elte.hu> <c62985530809290228w2aae150dk97749159bd495c3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809290228w2aae150dk97749159bd495c3b@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/9/29 Ingo Molnar <mingo@elte.hu>:
> >
> > * Pekka Paalanen <pq@iki.fi> wrote:
> >
> >> > +           return TRACE_TYPE_HANDLED;
> >> >     }
> >> >  }
> >>
> >> Otherwise, very good.
> >>
> >> As Ingo reverted the two earlier patches, you need to rebase these
> >> two. I'd like to see these in upstream. Let's handle the pipe closing
> >> bug in a different patch.
> >
> > good. Frederic, please just resubmit all fixes you have against
> > tip/master, with Pekka's Acked-by added. You can submit Pekka's patch as
> > well, so that it's a coherent series. The customary way for that is to
> > add in a From line as the first line of the changelog:
> >
> >  From: Pekka Paalanen <pq@iki.fi>
> >
> > and add your signoff to the end of the changelog. This way Git will show
> > Pekka as the author and the path of the patch is well understood.
> >
> 
> Ok so... I resend my patches (without changes?) but I adapt them to
> latest -tip master?

yeah - resend any bits not yet in tip/master, and also add Pekka's 
Acked-by line to them where he said they are OK.

> And I add the pekka's patches (whit appropriate "from" line) with 
> them?

Correct. Also mark it v2 perhaps in the announcement.

when there's NACKs and discussion it's (much) easier to pick up a new 
series than picking out the bits from the discussion. That way the 
resubmission might be redundant in a large part, but it's a summary of 
your discussion with Pekka and the result of a consensus. I.e. not 
redundant in terms of a workflow step.

	Ingo
