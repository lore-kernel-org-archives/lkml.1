Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYBYNNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYBYNNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYBYNNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:13:01 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60787 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYBYNNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:13:00 -0500
Date: Mon, 25 Feb 2008 15:12:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225131202.GF32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225113235.GC32450@cs181133002.pp.htv.fi> <20080225115022.GA16376@elte.hu> <20080225122526.GE32450@cs181133002.pp.htv.fi> <20080225125707.GA27202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225125707.GA27202@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 01:57:07PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > the existing 32-bit and 64-bit defconfigs should be enough for that. 
> > > For better/full coverage, randconfig should be used.
> > 
> > The two big problems with randconfigs are:
> > - either you build each .config both with and without your patch or you
> >   have to manually check which of the failures are caused by your patch
> > - you require at least an order of magnitude more builds for having the
> >   same amount of common configurations covered
> > 
> > And any solution that only works on x86 (e.g. based on the expectation 
> > that all randconfig configurations normally build) is of zero value 
> > for me since x86 is only one out of 23 architectures.
> 
> so if an arguably sane testing method "only" works on x86 then the right 
> solution is to fix the other architectures to be sanely testable too. 

If you want to fix them I won't stop you...

Until they are fixed I'm staying at using the defconfigs.

But then there's still the other problem that at least I simply don't 
want to wait two weeks for having the test compiles of a patch finish.

> I've seen architectures that were build-tested for the _first time_ at 
> around 2.6.24-rc8...

That can't be true.

Can you name what architectures you think of and why you think noone 
tried to compile them before?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

