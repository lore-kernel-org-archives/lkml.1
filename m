Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbYEIK2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbYEIK2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYEIK2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:28:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYEIK2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:28:33 -0400
Date: Fri, 9 May 2008 12:28:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080509102806.GH19617@elte.hu>
References: <20080504193113.GA24358@elte.hu> <20080505151202.GA17139@cs181133002.pp.htv.fi> <20080505112917.7d4548fb@ephemeral> <alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de> <20080507114137.357aca34@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507114137.357aca34@ephemeral>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andres Salomon <dilinger@queued.net> wrote:

> On Tue, 6 May 2008 14:49:07 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 5 May 2008, Andres Salomon wrote:
> > > On Mon, 5 May 2008 18:12:02 +0300
> > > Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > On Sun, May 04, 2008 at 09:35:42PM +0200, Ingo Molnar wrote:
> > > > >...
> > > > > Thomas Gleixner (2):
> > > > >...
> > > > >       x86: olpc build fix
> > > > >...
> > > > > --- a/arch/x86/Kconfig
> > > > > +++ b/arch/x86/Kconfig
> > > > > @@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
> > > > >  
> > > > >  config OLPC
> > > > >  	bool "One Laptop Per Child support"
> > > > > +	depends on MGEODE_LX
> > > > >  	default n
> > > > >  	help
> > > > >...
> > > > 
> > > > This patch not only excludes OLPC and code depending on it
> > > > (currently BATTERY_OLPC) from all{mod,yes}config builds (where it
> > > > built fine) but also makes it very hard for generic distribution
> > > > kernels to support the OLPC.
> > > > 
> > > > The commit comment does not indicate what the actual problem was,
> > > > and if this patch was sent to linux-kernel I must have missed it.
> > > > 
> > > > What exactly was the build problem?
> > > > Can we fix it in a less invasive way?
> > > 
> > > Also, it would've been nice to have been CC'd on this; I didn't see
> > > it until it was committed.
> > 
> > Sorry, this should not have gone mainline. We had your patch queued
> > (via Andrew) and it had testing failures, which we sent to you. One
> > workaround was that build patch. When we dropped your patch we forgot
> > to remove the workaround as well.
> > 
> 
> Will it be removed, then? [...]

yes, it's all lined up for the next x86 pull.

	Ingo
