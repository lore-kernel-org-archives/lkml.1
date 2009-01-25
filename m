Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZAYPEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZAYPEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZAYPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:04:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZAYPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:04:28 -0500
Date: Sun, 25 Jan 2009 16:03:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: john stultz <johnstul@us.ibm.com>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090125150349.GB19168@elte.hu>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com> <20090124091404.GA32032@elte.hu> <200901251218.33255.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901251218.33255.florian.fainelli@telecomint.eu>
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


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Le Saturday 24 January 2009 10:14:04 Ingo Molnar, vous avez écrit :
> > * john stultz <johnstul@us.ibm.com> wrote:
> > > On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > * john stultz <johnstul@us.ibm.com> wrote:
> > > >> I'd think this would ideally be more of a subarch in the config
> > > >> selection like the AMD Elan is, so folks know it really is not just a
> > > >> extra-support feature and in fact limits what hardware you can use the
> > > >> resulting kernel on.
> > > >
> > > > a better solution is that if RDC is set [it is unset by default] we
> > > > should turn PIT_TICK_RATE into a variable, defaulting it to 1193182. If
> > > > a real RDC or ELAN system is running, that variable is changed during
> > > > early bootup, in the init functions for those platforms.
> > >
> > > Took a quick look at this, and I don't see any detection code for either
> > > RDC. The X86_ELAN config also has no conditionals, but maybe the elan
> > > cpufreq code can help here.
> >
> > i'd suggest to just remove the #ifdef for now (it's causing problems) and
> > add the variable - we can add the quirks for those two platforms later on,
> > separately from your patch(es).
> 
> Fine with me. Ingo, is there any infrastructure yet to get an early 
> quirk set the PIT tick rate accordingly ?

Not yet but it should be easy - do you have the time to implement it?

	Ingo
