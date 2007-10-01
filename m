Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXJAKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXJAKo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXJAKoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:44:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXJAKoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:44:21 -0400
Date: Mon, 1 Oct 2007 12:44:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001104406.GC15488@elte.hu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > WARNING: braces {} are not necessary for single statement blocks
> > > #5706: FILE: home/apw/git/linux-2.6/kernel/sched.c:5703:
> > > +	if (parent->groups == parent->groups->next) {
> > > +		pflags &= ~(SD_LOAD_BALANCE |
> > > +				SD_BALANCE_NEWIDLE |
> > > +				SD_BALANCE_FORK |
> > > +				SD_BALANCE_EXEC |
> > > +				SD_SHARE_CPUPOWER |
> > > +				SD_SHARE_PKG_RESOURCES);
> > > +	}
> > > 
> > > Ok, this one is "correct" at least for the rules as I have them.
> > > Perhaps the message should not be emitted for very long blocks?
> > 
> > If a statement is not single-line, then braces _are_ fine. Where does 
> > CodingStyle say that it's not fine?
> 
> I'd disagree with checkpatch there.  Again, it might be hard to fix.  
> Wanna rename it to checkpatch-and-suggest-stuff-to-think-about.pl?

i think checkpatch.pl is quite close to its most useful purpose and 
role: that of a reliable tool that i can use in an automated fashion 
too, with only very rare false positive - and not the current 50%-80% 
false positives rate. (And i'm fighting hard for Andy to realize the 
true scope and purpose of this script ;-)

	Ingo
