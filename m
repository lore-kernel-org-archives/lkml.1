Return-Path: <linux-kernel-owner+w=401wt.eu-S1030183AbXBFWmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183AbXBFWmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965575AbXBFWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:42:25 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38022 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542AbXBFWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:42:24 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206220855.GB5109@elte.hu>
References: <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1>  <20070206220855.GB5109@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 14:42:22 -0800
Message-Id: <1170801742.3455.87.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 23:08 +0100, Ingo Molnar wrote:

> sorry but that's precisely what your suggestion above results in:

I'm not trying to suggest we "fake" anything. Your just misunderstanding
me.. I'm am suggesting we change LOC to something readable. If you think
we're "faking" something by dropping the current "timer" request_irq()
then we certainly don't need to do that ..

The io-apic timer could potentially be a clock event device, that is
it's function isn't it ? It generates interrupts (note I said
interrupts) periodically .. The NMI is another example of that,
generates non-maskable interrupts based off a clock.. All are clock
based interrupt generating devices .. All could be clock event sources,
with all the other clock event sources in the system.

It makes sense (to me at least) that we should list all those interrupt
generating devices in /proc/interrupts with statistics of their usage.. 

I'm making suggestion here, you can call it "fake"'ing something or
whatever, but I'm still going to pose suggestions.

> > > > If we change the current "timer" entry to be listed as 
> > > > "lapic-timer" and not "IO-APIC-edge" (or one of the other names) 
> > > > and replace it with the count from LOC
> 
> "replace the timer entry with lapic-timer and put the LOC count there" 
> is faking something that does not reflect reality. The 'timer' count is 
> for IRQ#0, not for the local apic timer.
> 
> > [...] I'm saying list what's really happening .. In a human readable 
> > way .
> 
> we list precisely what is happening: the number of IRQ#0 interrupts and 
> the number of local APIC timer interrupts. Precisely where their 
> traditional place is.

Empirically, I know that users do not/will not understand what's
happened. so take that how ever you want, but _I_ think we should do
something so people better understand what has happened.

Daniel

