Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZBII3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZBII3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZBII3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:29:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZBII3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:29:00 -0500
Date: Mon, 9 Feb 2009 09:28:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.29-rc4
Message-ID: <20090209082816.GA14808@elte.hu>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <20090208172111.6941cd3e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208172111.6941cd3e@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 8 Feb 2009 13:01:04 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > Another week (and a half), another -rc.
> > 
> > Arch updates (sparc, blackfin), driver updates (dvb, mmc, ide), ACPI 
> > updates, FS updates (ubifs, btrfs), you name it. It's all there.
> > 
> > But more importantly, people really have been working on regressions,
> > and hopefully this closes a nice set of the top one, and hopefully
> > without introducing too many new ones.
> > 
> > 			Linus
> 
> 
> I just looked at the top -rc3 oopses/warnings/etc
> 
> quick summary of the top ones:
> (manual rather than the normal automated scripts, so the format is
> different)
> "regulars" that happened a lot prior to  .29 (eg clearly non-regressions) I marked with a *
> 
> Oopses: 78 oopses reported
> --------------------------
> 12 times	i915_driver_irq_handler		http://www.kerneloops.org/searchweek.php?search=i915_driver_irq_handler
> 8 times		apic_mmio_read			http://www.kerneloops.org/searchweek.php?search=apic_mmio_read

The last one seems KVM related.

	Ingo
