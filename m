Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXJBOHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXJBOHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXJBOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:07:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXJBOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:07:37 -0400
Date: Tue, 2 Oct 2007 16:07:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002140711.GA29395@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <200710021121.36443.ak@suse.de> <47021F83.4070609@garzik.org> <200710021248.06050.ak@suse.de> <alpine.LRH.0.999.0710021250510.23586@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0710021250510.23586@www.tglx.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2 Oct 2007, Andi Kleen wrote:
> > On Tuesday 02 October 2007 12:37:55 Jeff Garzik wrote:
> > > Andi Kleen wrote:
> > > > On Tuesday 02 October 2007 11:17:02 Thomas Gleixner wrote:
> > > >>> This is also a good time to warn about the fact that we're doing the x86 
> > > >>> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> > > >>> have pending patches for the next series that touch arch/i386 or x86-64, 
> > > >>> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> > > >>> keepers of the merge scripts, and will help you prepare..
> > > > 
> > > > 
> > > > Yes I have ~100 patches for arch/x86_64, arch/i386
> > > > 
> > > > Should I just drop them?
> > > 
> > > Why don't you work with Thomas and Ingo to make sure everything is in 
> > > sync and prepped for 2.6.24?
> > 
> > The easiest way to do that would be to first merge all the queued 
> > and collected patches from the last months. Once they are in people 
> > can then create whatever mess they like.
> > 
> > The other way round (adapting 100+ patches to a possibly completely 
> > different tree) will be a huge amount of work which I am frankly not 
> > very motivated to do because I think it's quite unnecessary.
> > 
> > I would probably just push the work back to all the patch submitters 
> > -- that is what I meant with dropping the patches.
> 
> I picked up your queue at
> 
> 	ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/current.tar.gz
> 
> and converted it with the fixup script to:
> 
> 	http://www.tglx.de/~tglx/patches-ak.tar.bz2
> 
> Hope that helps,

thanks Thomas - i have applied this queue ontop of the unified arch/x86 
tree (i skipped vdso-text-offset which change is already upstream) and 
it built and booted fine on a couple of x86 systems - 32-bit and 64-bit 
alike. So your script worked like a charm.

Andi, could you please send us the list of patches from the 
current.tar.gz queue above that you consider 2.6.24 candidates? (and 
please add to the list if there's anything else pending) Thanks,

	Ingo
