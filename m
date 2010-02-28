Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031598Ab0B1Ixa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:53:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031588Ab0B1Ix2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:53:28 -0500
Date: Sun, 28 Feb 2010 09:53:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228085305.GA27946@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
 <20100228071405.GA14205@elte.hu>
 <20100228183725.80915681.sfr@canb.auug.org.au>
 <20100228075105.GC14205@elte.hu>
 <20100228081922.GO30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228081922.GO30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sun, Feb 28, 2010 at 08:51:05AM +0100, Ingo Molnar wrote:
> 
> > ( Alas, ARM doesnt tend to be a big problem, at least as far as the facilities 
> >   i'm concerned about go: it has implemented most of the core kernel 
> >   infrastructures so there's few if any 'self inflicted' breakages that i can 
> >   remember. )
> 
> FWIW, it might make sense to run cross-builds for many targets and post the 
> things that crop up + analysis to linux-arch...  Any takers?
> 
> I haven't run a lot of cross-builds lately, but IME most of the breakage 
> tends to be less dramatic - somebody relying on indirect includes in driver 
> *or* forgetting to add "depends on" to Kconfig used to be the most frequent 
> case.
> 
> "let other targets rot" attitude has a very nasty effect - it snowballs. At 
> some point people *can't* check that their patches don't break things, even 
> if they want to.  And that, IMO, sucks.  At that point architecture needs to 
> be either removed or brought to the state when it builds in mainline.

What is happening right now is that our combined _costs_ snowball: generic 
changes are burdened with the overhead of a thousand cuts ...

IMO either there's enough interest in keeping an architecture going, rooted in 
_that_ architecture's importance (or the enthusiasm/clue of their developers), 
or, after a few years of inactivity it really shouldnt be upstream.

Right now we are socializing all the costs, sometimes even pretending that all 
architectures are equal. None of the costs really looks particularly large in 
isolation, but the sum of them does exist and adds up in certain places of the 
kernel.

Thanks,

	Ingo
