Return-Path: <linux-kernel-owner+w=401wt.eu-S1030570AbXBFX2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570AbXBFX2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030572AbXBFX2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:28:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030570AbXBFX2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:28:36 -0500
Date: Wed, 7 Feb 2007 00:28:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206232828.GA21969@elte.hu>
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

> On Wed, 2007-02-07 at 00:14 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > On Tue, 2007-02-06 at 23:56 +0100, Ingo Molnar wrote:
> > > 
> > > > changing the current 'timer' entry (which is line 2 of /proc/interrupts) 
> > > > to be 'listed as lapic-timer' and to 'replace it with the count from 
> > > > LOC' is faking a count in a line where nothing like that should be.
> > > 
> > > This point is getting irrelevant ..
> > 
> > it is very much relevant: faking a count is something we /dont/ want 
> > to do with /proc/interrupts, for (very) basic compatibility, 
> > simplicity and policy reasons. And that is precisely what your 
> > suggestion was to 'solve' this supposed 'problem' - so it's very 
> > much relevant.
> 
> As I said you are misunderstanding me .. which is why this is not 
> relevant any more ..

actually, i quoted what you said:

| If we change the current "timer" entry to be listed as "lapic-timer" 
| and not "IO-APIC-edge" (or one of the other names) and replace it with 
| the count from LOC

this is a pretty clear sentence, i dont think i misunderstood anything 
about it. If i did, please point it out specifically.

	Ingo
