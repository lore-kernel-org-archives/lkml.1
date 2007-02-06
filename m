Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXBFXOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXBFXOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXBFXOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:14:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbXBFXOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:14:35 -0500
Date: Wed, 7 Feb 2007 00:14:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206231421.GA18654@elte.hu>
References: <20070206205231.GA25430@elte.hu> <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu> <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu> <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu> <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu> <1170803070.3455.93.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170803070.3455.93.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4805]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-02-06 at 23:56 +0100, Ingo Molnar wrote:
> 
> > changing the current 'timer' entry (which is line 2 of /proc/interrupts) 
> > to be 'listed as lapic-timer' and to 'replace it with the count from 
> > LOC' is faking a count in a line where nothing like that should be.
> 
> This point is getting irrelevant ..

it is very much relevant: faking a count is something we /dont/ want to 
do with /proc/interrupts, for (very) basic compatibility, simplicity and 
policy reasons. And that is precisely what your suggestion was to 
'solve' this supposed 'problem' - so it's very much relevant.

> > the kernel simply displays reality: IRQ#0 isnt increasing because 
> > it's not used, and LOC (local apic timers) is increasing.
> 
> What about the statistics for the other interrupts in the system ? It 
> clearly doesn't list all interrupts in the system .

what is your point?

	Ingo
