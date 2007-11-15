Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbXKOSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbXKOSl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbXKOSlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:41:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43909 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbXKOSlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:41:20 -0500
Date: Thu, 15 Nov 2007 19:42:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071115184255.GB23914@uranus.ravnborg.org>
References: <20071115161703.GR4250@stusta.de> <20071115180436.GA23517@uranus.ravnborg.org> <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 07:07:11PM +0100, Thomas Gleixner wrote:
> On Thu, 15 Nov 2007, Sam Ravnborg wrote:
> 
> > On Thu, Nov 15, 2007 at 05:17:03PM +0100, Adrian Bunk wrote:
> > > The x86 unification resulted in CONFIG_X86_HT no longer being
> > > set if (X86_32 && MK8).
> > Yup - my bad. I wrongly assumed MK8 was an X86_64 thing.
> > 
> > Thanks for fixing this.
> > > 
> > > After grep'ing through the tree I think the problem is that different 
> > > places have different assumptions about the semantics of CONFIG_X86_HT,
> > > either:
> > > - hyperthreading or
> > > - multicore
> > > and the SCHED_SMT and SCHED_MC dependencies are just one of the 
> > > symptoms.
> > > 
> > > This should be sorted out properly, but until then we should keep the 
> > > 2.6.23 status quo.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > I assume Thomas & Co will forward the patch.
> 
> After looking what does what and fixing it. 
> 
> Right now this patch is not a 1:1 replacement of the .23 status quo,
> as it now makes SCHED_SMT and SCHED_HT depend on !MK8 for 64bit.

I assumed this was intentional - Adrian?

	Sam
