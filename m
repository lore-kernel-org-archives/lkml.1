Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZKJTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZKJTnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZKJTnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:43:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:55233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913AbZKJTnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:43:20 -0500
Date: Tue, 10 Nov 2009 11:39:19 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110193919.GC12686@suse.de>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF98C36.9040405@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 04:52:22PM +0100, Stefan Richter wrote:
> James Bottomley wrote:
> [...]
> >> On Tue, Nov 10, 2009 at 04:48:31AM +0100, Ingo Molnar wrote:
> >> > FYI, today i committed a scheduler performance fix that has a number of 
> >> > commit prerequisites for -stable integration. Those commits are not 
> >> > marked -stable.
> [...]
> >> > we can move this into the Git commit space too, and minimize the 
> >> > work for the -stable team, via a new -stable tag variant.
> [...]
> > The question is, how important is this?
> > 
> > One of the assumptions behind the current setup is that I assume
> > backports are independent (so the order of transmission doesn't matter
> > that much).  This isn't always true, but the exceptions tend to get
> > handled manually.  Part of what the above is requesting is an
> > implementation that starts to care about ordering.
> 
> More importantly, isn't this against the character of the -stable kernel
> branches as _safe and simple_ hotfix branches?
> 
> If a fix has a number of prerequisites which ar not -stable fixes
> themselves, then it is more than a hint that this fix is not really well
> suited for -stable.

Not true, we have been doing this kind of thing for quite some time now.
Sometimes it's just a simple "this patch cleans up the code, and the
second one fixes it in an obvious manner" type thing.  It is easier for
me and everyone else for us to apply 2 commits to the -stable tree,
instead of rewriting the second patch that actually does the fix and
hope I got it all correct in doing so.

It's also easier to review stuff, which is the most important thing.

thanks,

greg k-h
