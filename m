Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXBFXhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXBFXhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXBFXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:37:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXBFXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:37:54 -0500
Date: Wed, 7 Feb 2007 00:37:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206233745.GB21969@elte.hu>
References: <20070206210959.GC25430@elte.hu> <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu> <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu> <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu> <1170803070.3455.93.camel@dwalker1> <20070206231421.GA18654@elte.hu> <1170804177.3455.109.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170804177.3455.109.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > > the kernel simply displays reality: IRQ#0 isnt increasing 
> > > > because it's not used, and LOC (local apic timers) is 
> > > > increasing.
> > > 
> > > What about the statistics for the other interrupts in the system ? 
> > > It clearly doesn't list all interrupts in the system .
> > 
> > what is your point?
> 
> Isn't the listing inconsistent ? /proc/interrupts only showing some 
> special interrupts, and not others .. For example it shows NMI which 
> is not related to request_irq() .. It shows some clock driver devices 
> (timer, NMI, LOC) and not others (clock event devices) ..

it's not inconsistent. /proc/interrupts lists registered interrupts plus 
some special hardcoded platform interrupts that are not explicitly 
registered - with the goal of providing a list of all active interrupt 
sources. /proc/interrupts has been doing that for more than 10 years. 
Clock event devices themselves are not 'interrupt lines', why should 
they be listed in /proc/interrupts?

	Ingo
