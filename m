Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXAXTjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXAXTjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXAXTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:39:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXAXTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:39:40 -0500
Date: Wed, 24 Jan 2007 20:38:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070124193822.GA28259@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com> <20070124095157.GA21346@elte.hu> <1169634220.19471.197.camel@imap.mvista.com> <1169637237.21181.164.camel@localhost.localdomain> <1169654001.19471.231.camel@imap.mvista.com> <20070124160046.GA24798@elte.hu> <1169655076.19471.241.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169655076.19471.241.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > you are also misunderstanding the change. While the TSC is the only 
> > unstable clocksource right now, the previous code tied the TSC to 
> > the >pm-timer< clocksource. This change makes it generic, hence the 
> > TSC can be verified by a hpet-only system (no pm-timer) as well. 
> > Systems without a pm-timer and with a TSC are quite common. So it 
> > solves a real problem.
> 
> Using my patch set a TSC specific watchdog could be created that isn't 
> tied a another specific clock. [...]

in other words: Thomas was right with his approach and your criticism 
against the generic code was unjustified. (I agree with the other points 
of Thomas as well, so i'm going with his patchset for now.)

	Ingo
