Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZKLHpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZKLHpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZKLHpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:45:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZKLHpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:45:46 -0500
Date: Thu, 12 Nov 2009 08:45:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091112074531.GA16434@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <20091110193747.GB12686@suse.de>
 <1257965424.11985.9.camel@mulgrave.site>
 <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
 <1257970010.11985.17.camel@mulgrave.site>
 <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
 <4AFB301C.3050800@zytor.com>
 <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 11 Nov 2009, H. Peter Anvin wrote:
> > > 
> > > Quite frankly, I'd much rather not run hooks on my tree directly. The less 
> > > that can possibly get screwed up with my kernel.org tree, the happier I 
> > > am. So in many ways, I really prefer the whole "done separately by others" 
> > > approach.
> > > 
> > > But hey, send the hook to me, and I'll think about it.
> > 
> > One thing we might be able to do is to create an "exploder hook" on your
> > tree - something that asynchronously broadcasts a notification that
> > anyone can subscribe to.
> 
> Yeah, some minimal hook just informing any interested party about "ok, 
> Linus pushed to the main tree" (and in fact, perhaps generalized so that 
> you can show that you are interested in some particular branch of _any_ 
> tree that people can just add to their trees) certainly doesn't sound like 
> a bad idea.
> 
> That way we can get rid of "polling by cron", without having to have 
> the tree owners themselves care about who is interested in exactly 
> what..

That's already possible via the git-commits-head@vger.kernel.org email 
list. Anyone can subscribe to it and can procmail process it. It is also 
more secure (and less intrusive to the tree owner) than any post-push 
hook script running under the pusher's UID. Polling via cron is really 
not required i think.

	Ingo
