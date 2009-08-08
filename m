Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbZHHOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbZHHOqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZHHOqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:46:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZHHOqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:46:37 -0400
Date: Sat, 8 Aug 2009 16:45:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stefan Assmann <sassmann@suse.de>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
Message-ID: <20090808144520.GB25931@elte.hu>
References: <4A6F5670.4010405@goop.org> <20090807103318.06ed3ecd@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807103318.06ed3ecd@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 28 Jul 2009 12:50:08 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > quirk_reroute_to_boot_interrupts_intel() goes to some effort to 
> > scan for a bunch of Intel devices and set 
> > dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However, 
> > as far as I can see that's the only reference to 
> > dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the 
> > whole thing appears to have no effect.
> > 
> > Is it all dead code?  Is there something else which should be 
> > there missing?
> 
> Hm my quick look couldn't find a user either.  The initial patch 
> to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had 
> an ACPI component, but it looks like that may have vanished 
> somehow (maybe some of the IOAPIC code got shuffled around and 
> this bit was missed?).
> 
> Stefan or Ingo?

I dont remember ioapic interactions. Stefan?

	Ingo
