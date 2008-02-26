Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYBZJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYBZJp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBZJpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:45:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYBZJpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:45:15 -0500
Date: Tue, 26 Feb 2008 10:44:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080226094451.GL9857@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225190241.GA23161@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225190241.GA23161@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> And asking me to do randconfig is not an option. I have only this 
> machine to work on and with a -j8 build it gets unresponsive at least 
> so much that it irritates me.

> > More defconfigs would just be a constant maintenance drag, they are 
> > rather pointless on PC hardware anyway (we'd have to have at least a few 
> > hundred of them for it to be meaningful as a "default config") and it 
> > does not really solve the problem either.
>
> 10 different configs would cover what I have in mind. This is not all 
> sort of combinations of dirvers and kernel haching options multiplied 
> with the arch specific options. This is the typical set of options 
> that is used to build a kernel to the relevant sub-architectures.
> 
> And an occasional defconfig update are not a maintanence burden.
> 
> It is a simple equation: 10 additional defconfigs can give you more 
> build coverage by additional people. Is it worth it?

i dont think it's worth it on x86, because it has no real meaning so it 
will just be an arbitrary thing that deteriorates over time.

Subarchitectures on x86 are just a shortcut for the "0.1% of systems 
that were lazy to be properly abstracted into the general PC code". We 
are discouraging additional subarches and the one that got added 
recently will go away soon. The rest is legacy.

Really, we should concentrate our testing to where our _testers_ are and 
where our developers are.

And according to lkml, http://kerneloops.org and a 300,000+ sample 
http://smolt.fedoraproject.org/static/stats/stats.html statistics, our 
testers are distributed like this:

 - more than 90% of all kernel developers use general PC hardware

 - more than 95% of our active testers use general PC hardware

 - more than 99.1% of our distro users that are willing to send us
   feedback use general PC hardware as well

(In that aspect i dont count the million(s?) of non-x86 Linux based 
phones as "a million users", unless they become an active part of our 
ecosystem and do things like hook into kerneloops.org. It's that simple, 
really.)

	Ingo
