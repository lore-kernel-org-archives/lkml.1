Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbYBZUOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbYBZUOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYBZUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:14:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59686 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYBZUOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:14:31 -0500
Date: Tue, 26 Feb 2008 21:14:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080226201442.GB32685@uranus.ravnborg.org>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225190241.GA23161@uranus.ravnborg.org> <20080226094451.GL9857@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226094451.GL9857@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:44:51AM +0100, Ingo Molnar wrote:
> > 
> > It is a simple equation: 10 additional defconfigs can give you more 
> > build coverage by additional people. Is it worth it?
> 
> i dont think it's worth it on x86, because it has no real meaning so it 
> will just be an arbitrary thing that deteriorates over time.
OK

> Subarchitectures on x86 are just a shortcut for the "0.1% of systems 
> that were lazy to be properly abstracted into the general PC code". We 
> are discouraging additional subarches and the one that got added 
> recently will go away soon. The rest is legacy.
So you say we would waste our time doing build test of the legacy
sub-archs. OK.

> 
> Really, we should concentrate our testing to where our _testers_ are and 
> where our developers are.
> 
> And according to lkml, http://kerneloops.org and a 300,000+ sample 
> http://smolt.fedoraproject.org/static/stats/stats.html statistics, our 
> testers are distributed like this:
> 
>  - more than 90% of all kernel developers use general PC hardware
> 
>  - more than 95% of our active testers use general PC hardware
> 
>  - more than 99.1% of our distro users that are willing to send us
>    feedback use general PC hardware as well
> 
So I will try to concentrate more on non-PC stuff from now on to
increase the developer and tester base there. Seems we have plenty
of developers and testers to hack and test PC stuff.

> (In that aspect i dont count the million(s?) of non-x86 Linux based 
> phones as "a million users", unless they become an active part of our 
> ecosystem and do things like hook into kerneloops.org. It's that simple, 
> really.)

The "everything on lkml argument"...
At my current company I cannot name a single person that I think
would be able to follow lkml - sorry!

	Sam
