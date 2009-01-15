Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbZAOJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbZAOJ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZAOJ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:56:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZAOJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:56:00 -0500
Date: Thu, 15 Jan 2009 10:55:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115095521.GD5833@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <200901151253.44016.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151253.44016.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 14 January 2009 20:08:34 Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > Tejun Heo wrote:
> > > > 
> > > > I think the two changes aren't exclusive at all.  The order of things
> > > > could be different but in the end, yeah, zero-based percpu symbols w/
> > > > mostly empty pda is the goal.
> > > > 
> > > >> Once the PDA is empty, I'll base %gs at the start of the per-cpu
> > > >> area.  I've been working out the bugs with the last patch
> > > >> (zero-basing the percpu area) before submitting, but I probably
> > > >> won't have the time until this weekend to polish it off.  I could
> > > >> submit all but the last patch if you'd like.
> > > > 
> > > > Any chance you can rebase those patches on top of mine?  If you don't
> > > > have time, just send them to me, I'll try to integrate them this week.
> > > > 
> > > 
> > > A merged tree here would be absolutely wonderful.  I've kept an eye on 
> > > the discussion so far, but it looks like you guys are handling it fine.
> > 
> > agreed, it looks really good.
> > 
> > Tejun, could you please also add the patch below to your lineup too?
> > 
> > It is an optimization and a cleanup, and adds the following new generic 
> > percpu methods:
> > 
> >   percpu_read()
> 
> I already have this in my patch series.

hm, where is that exactly? Do you have a commit ID (or could send a patch) 
that i could have a look at?

> Frankly, it starts to get marginal in generic code after percpu_read(), 
> so I didn't do them (and the per-cpu interfaces are already pretty 
> wide).
> 
> Tejun, is now a good time to rebase my alloc_percpu series on top of 
> yours?  I'm more than happy to hand them over to someone with more 
> cycles...

We can pick it up into a topic in -tip if you dont mind.

	Ingo
