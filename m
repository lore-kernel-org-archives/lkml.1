Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZCYM5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZCYM5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZCYM5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:57:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCYM5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:57:25 -0400
Date: Wed, 25 Mar 2009 13:57:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc8-rt2
Message-ID: <20090325125706.GA516@elte.hu>
References: <1237663624.3200.3.camel@localhost.localdomain> <1237687635.3424.1.camel@localhost.localdomain> <20090322130937.GA22848@elte.hu> <1237758228.18021.8.camel@localhost.localdomain> <20090323080724.GA13569@elte.hu> <1237864404.3441.8.camel@localhost.localdomain> <alpine.LFD.2.00.0903240907390.29264@localhost.localdomain> <alpine.LFD.2.00.0903240912360.29264@localhost.localdomain> <1237953290.3203.3.camel@localhost.localdomain> <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 25 Mar 2009, Fernando Lopez-Lezcano wrote:
> > > > 
> > > > That'd be very helpful.
> > 
> > Snapshot attached... (on my t61 laptop)
> 
> The crash happens in alternatives_smp_switch(). Can you check 
> whether adding "noreplace-smp" to the kernel command line helps ? 
> I boot your config on my own T61. Hopefully I can reproduce.
> 
> Thanks,

candidate bad commits would be:

f80d2d7: tracing, Text Edit Lock: Fix one sparse warning in kernel/extable.c
505f2b9: tracing, Text Edit Lock - kprobes architecture independent support, nommu fix
3945dab: tracing, Text Edit Lock - SMP alternatives support
4460fda: tracing, Text Edit Lock - kprobes architecture independent support
0e39ac4: tracing, Text Edit Lock - Architecture Independent Code

	Ingo
