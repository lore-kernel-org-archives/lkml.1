Return-Path: <linux-kernel-owner+w=401wt.eu-S965514AbXBFVUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbXBFVUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965500AbXBFVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:20:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965514AbXBFVUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:20:20 -0500
Date: Tue, 6 Feb 2007 22:20:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206212011.GA32593@elte.hu>
References: <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos> <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos> <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu> <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206210959.GC25430@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I don't have that enabled tho .. This is with HRT/dynamic tick both 
> > off..
> 
> your kernel utilizes the kernel in a more optimal way: the new 
                           ^hardware                            
> clockevents code now utilizes the local APIC timer irq (represented by 
> the LOC field) for periodic interrupts. The local APIC timer irq has a 
> cost of ~2 usecs per IRQ, while the PIT irq is ~10 usecs per irq. With 
> HZ=1000 this means savings of ~8000 usecs per second - i.e. 8 msecs per 
> second, which is 0.8% more raw CPU power available - which isnt that 
> bad.

	Ingo
