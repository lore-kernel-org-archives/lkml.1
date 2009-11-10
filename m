Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZKJUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZKJUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZKJUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:45:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbZKJUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:45:51 -0500
Date: Tue, 10 Nov 2009 21:45:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110204537.GB18509@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de>
 <20091110193919.GC12686@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110193919.GC12686@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> > More importantly, isn't this against the character of the -stable 
> > kernel branches as _safe and simple_ hotfix branches?
> > 
> > If a fix has a number of prerequisites which ar not -stable fixes 
> > themselves, then it is more than a hint that this fix is not really 
> > well suited for -stable.
> 
> Not true, we have been doing this kind of thing for quite some time 
> now. Sometimes it's just a simple "this patch cleans up the code, and 
> the second one fixes it in an obvious manner" type thing.  It is 
> easier for me and everyone else for us to apply 2 commits to the 
> -stable tree, instead of rewriting the second patch that actually does 
> the fix and hope I got it all correct in doing so.
> 
> It's also easier to review stuff, which is the most important thing.

Yeah. This new tagging scheme doesnt really allow anything 'new' per se 
- it just helps the existing practice some more. All these commits were 
-stable candidates anyway, in exactly the same order - the only 
difference the new tagging scheme adds here is a more organized, 
in-upsream-Git way of communicating it to you.

This is also easier and less error prone for me than using email: i can 
do all the -stable tagging when i create a commit - or if i see that a 
commit has prereqs and those should be in -stable too. In those 
situations i check out the last stable kernel version, and cherry-pick 
the prereqs and the target commit, to see that it cherry-picks without 
conflicts.

But i cannot send you an email to stable@kernel.org just yet: as i 
havent fully tested the last commit yet, and have not pushed it out yet. 
The commit ID is not stable yet.

So without the in-commit tagging, i'd have to remember to send you an 
email in an hour (or in a day - whenever testing is done) - and that is 
error prone and easy to forget. The prereqs might be lost, etc. It's 
better to do this all in one well-focused moment of time, gather the 
information and mention it in the changelog.

	Ingo
