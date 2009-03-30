Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZC3EZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZC3EZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZC3EZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:25:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46480 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZC3EZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:25:44 -0400
Date: Mon, 30 Mar 2009 05:25:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090330042540.GP28946@ZenIV.linux.org.uk>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu> <20090329234839.GL28946@ZenIV.linux.org.uk> <20090330011355.GA11087@elte.hu> <20090330013355.GO28946@ZenIV.linux.org.uk> <20090330014926.GA32139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330014926.GA32139@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:49:26AM +0200, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Mon, Mar 30, 2009 at 03:13:55AM +0200, Ingo Molnar wrote:
> > 
> > > There is simply no excuse for ever having let that crap get there 
> > > into fs/proc/base.c. There is no excuse for ever letting that crap 
> > > grow. The fact that that crap is there is proof of systemic failure 
> > > over the years to keep that code clean.
> > 
> > Nothing like proof by assertion, eh?
> 
> The proof is what i quoted - see below the full dump again. Those 
> are bona fide evidence of unclean code.

This is evidence of code that triggers checkpatch.pl complaints.  Which
is not something holy.

> > And I very much object against completely unfounded assertions 
> > claiming that checkpatch noise makes a useful proxy for code 
> > quality.  You keep making those again and again, without a shred 
> > of evidence to show.
> 
> You dont have to take my word for it. Look at the output below. 
> Check the code. Compare to the CodingStyle. If it does not match, 
> then it's unclean code that should have been rejected when it got 
> there. Some of that is ancient code, some of that is recent code.

You and your... adherents have crammed into CodingStyle enough to make a mere
reference to it just about worthless.  There *are* serious things in there.
And there's a lot of generally indifferent "well, it's usually better to..."
stuff.  checkpatch.pl makes no distinction and neither do you, apparently.
"There's at least one place in CodingStyle this line doesn't match" is worth
*nothing*.  That's what you get after years of devaluation.

> It might be perfectly fine code otherwise, i made no assertion about 
> the quality of other code in that area.

Otherwise or elsewhere?  You keep using "runs afoul of something in the
current incarnation of CodingStyle" as evidence of low quality.  I see no
empirical evidence for such correlation.  AFAICT, you are actually redefining
code quality in an arbitrary way, then wave hands muttering "unclean, unclean"
and expect that substitution of notions will pass unnoticed...
