Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZBTMed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZBTMed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZBTMeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:34:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZBTMeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:34:24 -0500
Date: Fri, 20 Feb 2009 13:34:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090220123402.GA26418@elte.hu>
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220115357.GE4834@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
> > Borislav Petkov wrote:
> > > On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
> > >> Andreas Herrmann wrote:
> > >>> Hi Mark,
> > >>>
> > >>> Can you please provide us output of lspci -vvxxx.
> > >>> (Please run this as root.)
> > >>>
> > 
> > Attached...
> > 
> > 
> > >>> Furthermore you can try booting your 1000HZ kernel
> > >>> with following kernel command lines:
> > >>>
> 
> Thanks for trying this out.
> But nothing suspicious found. I.e. timer/hpet interrupt is enabled
> and its routing seems to be ok.
> 
> Here's one more check that's worth trying: In one of your logs I've
> seen that HPET id reports 3 timers but later on 4 timers were detected
> for HPET.
> 
> To check what's going on I'd like to see the HPET 
> configuration in the course of booting your system.  Please 
> apply attached patch and boot with hpet=debug -- both with 
> 250HZ and with 1000HZ -- and provide dmesg output.

Mind sending this patch as a hpet=verbose feature patch which we 
could queue up for upstream merging? We have hpet problems 
frequently, so some built-in debug/verbosity trigger would be 
nice.

	Ingo
