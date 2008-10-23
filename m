Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYJWQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYJWQKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYJWQKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:10:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbYJWQKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:10:20 -0400
Date: Thu, 23 Oct 2008 18:09:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with
	struct cpumask
Message-ID: <20081023160959.GB8853@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au> <49009639.3050603@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49009639.3050603@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Rusty Russell wrote:
> > On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
> >> Thomas has started a -tip cross-build test, and there's massive
> >> cross-build failures as well due to the cpumask changes:
> > 
> > Yes.  linux-next reported the same thing.  I've backed out various arch 
> > changes for this reason.
> > 
> >> it seems to me that this commit is massively borked:
> >>
> >>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
> > 
> > Yep.  This is the big one I dropped.  There are a few others; Mike is just 
> > porting the changes across to your tree now.
> > 
> > Cheers,
> > Rusty.
> 
> Hi Ingo,
> 
> It would seem easier to back out previous patches and apply the 
> replacements. Does this work for you?

no, it does not work fine. As i said, i reworked various small bits 
along the way of reviewing and integrating them, under the obvious 
assumption that you submitted the latest and greatest. I spent hours 
testing every single step as well. If you cannot get your workflow right 
then we cannot have this stuff in v2.6.28.

So ... please send append-only changes against tip/cpus4096-v2. We can 
squash/backmerge any bits to keep it all clean, but all changes have to 
be fully visible and fully reviewed from now on, because time is running 
short.

	Ingo
