Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbXLSNtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbXLSNtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXLSNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:49:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbXLSNt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:49:28 -0500
Date: Wed, 19 Dec 2007 14:48:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, Larry Finger <larry.finger@lwfinger.net>,
       mvtodevnull@gmail.com, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, Ray Lee <ray-lk@madrabbit.org>,
       n <odie@cs.aau.dk>,
       SimonHolm=?iso-8859-1?q?Th=F8gerse?=@mail.berlios.de,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, kjwinchester@gmail.com, linux@bohmer.net
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071219134805.GC21282@elte.hu>
References: <20071213003028.676998182@mvista.com> <520b60a90712181812l3fd6c4cbicece82a4487d0587@mail.gmail.com> <4768D216.3000904@lwfinger.net> <200712191046.54147.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712191046.54147.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> On Wednesday 19 December 2007 09:11:02 Larry Finger wrote:
> > > 
> > > or could tsc being marked as unstable have anything to do with the
> > > speed of network transfers?
> > 
> > Absolutely not.
> 
> Well, if the clocksource of the machine is unstable it _can_ cause all 
> kinds of weird things. If you think something is broken in the tsc 
> stuff, please switch to using another clocksource.

also, if it gets marked unstable (which is typical on laptops) then the 
kernel switches to a more stable, non-TSC clocksource automatically. 
(hpet or pit)

	Ingo
