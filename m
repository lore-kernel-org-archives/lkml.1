Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYG1QLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYG1QLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYG1QLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:11:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55862 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbYG1QLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:11:22 -0400
Date: Mon, 28 Jul 2008 18:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: move ehci reg def
Message-ID: <20080728161102.GA18860@elte.hu>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241727.57692.yhlu.kernel@gmail.com> <200807241757.23441.david-b@pacbell.net> <86802c440807241914o3e09a1a2la1cf9345b4b0e52b@mail.gmail.com> <20080726141813.GG4401@elte.hu> <20080728154042.GC30206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728154042.GC30206@kroah.com>
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

* Greg KH <greg@kroah.com> wrote:

> On Sat, Jul 26, 2008 at 04:18:13PM +0200, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > 
> > > >> +#include <linux/usb/ehci_def.h>
> > > >>
> > > >>  /*-------------------------------------------------------------------------*/
> > > >>
> > > >> +
> > > >
> > > > Only one blank line needed please.  ;)
> > > 
> > > thanks.
> > > Greg, Do i need to resend ?
> > 
> > i've fixed it up - see updated patch below.
> > 
> > Greg, could you please pull this change from the tip/usb-for-greg git 
> > tree:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git usb-for-greg
> > 
> > so that we can share the commit ID, without you having to carry 
> > unrelated x86 fixes? I'll merge this tree too into x86/early-printk.
> 
> I only use git for sending stuff to Linus, so that will not really 
> work.

oh, didnt know that.

> I have no objection for you keeping this in your tree, as that 
> probably makes it easier.

okay - i just wanted to keep your options maximally flexible, it's code 
you maintain, we are just trespassing :)

the commit will eventually show up in linux-next via tip/auto-x86-next. 

Given that it's all pretty uncontroversial, we might as well send it 
upstream after -rc1 - this is an isolated debug feature. (and a much 
desired one to begin with. We could even get printks out of terminally 
hung suspend/resume laptops this way i think!)

Any objections to that course of action?

	Ingo
