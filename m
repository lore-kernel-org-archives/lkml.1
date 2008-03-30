Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYC3Ui0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYC3Ui0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYC3UiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:38:20 -0400
Received: from www.tglx.de ([62.245.132.106]:52043 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbYC3UiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:38:19 -0400
Date: Sun, 30 Mar 2008 22:37:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chr <chunkeey@web.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
 2.6.25-rc7
In-Reply-To: <200803302218.52549.chunkeey@web.de>
Message-ID: <alpine.LFD.1.10.0803302236180.3219@apollo.tec.linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <200803302125.10817.rjw@sisk.pl> <alpine.LFD.1.10.0803302156210.3219@apollo.tec.linutronix.de> <200803302218.52549.chunkeey@web.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Chr wrote:
> On Sunday 30 March 2008 21:59:51 Thomas Gleixner wrote:
> > On Sun, 30 Mar 2008, Rafael J. Wysocki wrote:
> > > > So. take a look at stuck_task... that's best backtrace I could get...
> > > > (I have other logs too. (Task-list / Lockdep / ... ) but it's too much
> > > > and I hope the _logs_ are already enough.
> > > >
> > > > BTW: I noticed that the clock seems to jump forward and backwards.
> > > > Is this because the CPU-Cores aren't syncronized? (And why are they
> > > > out of sync?)
> >
> > The cores of those AMD beasts are never in sync. That's a chip feature :)
> >
> > Can you please provide the output of:
> >   /sys/devices/system/clocksource/clocksource0/current_clocksource
> >
> > for both 2.6.24 and 2.6.25-rc7
> it's "hpet" (in both cases...)

Hmm. That should be stable. Which clock is jumping back and forth ?
The one in the logs or the system clock ?

Thanks,
	tglx
