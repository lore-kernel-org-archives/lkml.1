Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXLPJXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXLPJXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXLPJXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:23:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbXLPJXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:23:42 -0500
Date: Sun, 16 Dec 2007 10:22:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       stefano.brivio@polimi.it, Ray Lee <ray-lk@madrabbit.org>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       mbuesch@freenet.de, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, Linus Torvalds <torvalds@linux-foundation.org>,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071216092243.GB27280@elte.hu>
References: <20071213003028.676998182@mvista.com> <20071214175910.GA27078@elte.hu> <200712141938.10733.mb@bu3sch.de> <200712150225.52183.rjw@sisk.pl> <20071215214300.GC3096@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215214300.GC3096@tuxdriver.com>
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


* John W. Linville <linville@tuxdriver.com> wrote:

> > It's not that simple.  For example, regression testing will be a 
> > major PITA if one needs to switch back and forth from the new driver 
> > to the old one in the process.
> 
> Not really true -- a single system can easily have firmware installed 
> for b43, b43legacy, and bcm43xx at the same time and switch back and 
> forth between them.

as long as the version 4 firmware blob is present in the system, will 
testers have a fully fluid test- and work-flow when migrating across 
from bcm43xx to b43, without any other changes to an existing Linux 
installation? (i.e. no udev tweaks, no forced upgrades of components, 
etc.)

Will it Just Work in bisection as well, when a tester's kernel 
flip/flops between bcm43xx and b43 - like it does for the other 3000+ 
drivers in the kernel?

Note that we are _NOT_ interested in "might" or "can" scenarios. We are 
interested in preserving the _existing_ bcm43xx installed base and how 
much of a seemless migration the b43 transition will be. _THAT_ is what 
the "no regressions" upstream rule is about, not the "ideal distro" 
scenario you outline above. It is YOUR total obligation as a kernel 
maintainer to ensure that you dont break old installations. How hard is 
that to understand? This is not rocket science.

	Ingo
