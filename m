Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZHYSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZHYSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZHYSZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:25:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbZHYSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:25:26 -0400
Date: Tue, 25 Aug 2009 20:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
Message-ID: <20090825182510.GA6903@elte.hu>
References: <4A9407B1.6020400@nets.rwth-aachen.de> <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com> <4A94161A.2020609@nets.rwth-aachen.de> <1251219129.4852.1.camel@penberg-laptop> <4A94242E.30309@nets.rwth-aachen.de> <1251223399.13451.5.camel@penberg-laptop> <4A942BDD.70303@nets.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A942BDD.70303@nets.rwth-aachen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Hannemann <hannemann@nets.rwth-aachen.de> wrote:

> Pekka Enberg wrote:
> > On Tue, 2009-08-25 at 19:49 +0200, Arnd Hannemann wrote:
> >> Hi Pekka,
> >>
> >> Pekka Enberg wrote:
> >>> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
> >>>>> Thanks for doing the bisect! Can we also see your .config
> >>>>> also?
> >>>> Config for -rc7 is attached. My bisect configs were based on
> >>>> that
> >>> Thanks! While we wait for the Xen people, you can try the
> >>> following patch to see if we can narrow the bug down to
> >>> trap_init().
> >> Yes seems to be trap_init(). -rc7 with this patch applied boots up
> >> to the prompt.
> >
> > Thanks for testing! Ingo, what do you think of the following patch?
> > AFAICT, x86-32 is the only architecture playing with traps in
> > mem_init() so this should be the safest fix for 2.6.31.
> 
> Hmm, -rc7 + this fix does not work for me :-/
> Still hangs before any output...

does earlyprintk=vga tell you anything about precisely where it 
hangs?

	Ingo
