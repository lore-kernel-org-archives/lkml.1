Return-Path: <linux-kernel-owner+w=401wt.eu-S1763884AbYJJTvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763884AbYJJTvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762219AbYJJTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:50:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345AbYJJTuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:50:50 -0400
Date: Fri, 10 Oct 2008 21:50:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #9, sparse
	IRQ?support
Message-ID: <20081010195028.GC31926@elte.hu>
References: <20081010001727.GA14132@elte.hu> <20081010185912.GF21876@elte.hu> <48EFA8CA.1020600@kernel.org> <200810101234.57440.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810101234.57440.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Friday, October 10, 2008 12:11 pm Yinghai Lu wrote:
> > Ingo Molnar wrote:
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > >> Linus,
> > >>
> > >> Please pull the latest x86-v28-for-linus-phase9 git tree from:
> > >>
> > >> Sparse IRQ support - make NR_IRQS dynamic by turning it into nr_irqs,
> > >> an by creating irq descriptors in a sparse way.
> > >>
> > >> Includes a number of dependent x86 topics: timers/hpet-percpu, IO-APIC
> > >> and local APIC code unification, UV support updates.
> > >>
> > >> Has been cross-built on all architectures we could get crosscompilers
> > >> for:
> > >>
> > >>   http://www.tglx.de/autoqa/index
> > >>
> > >> It should be largely uneventful for sparse-irq unaware, non-x86
> > >> architectures.
> > >
> > > please find updated pull request below. Relative to phase-N-1. Updates
> > > from today in this class of topics:
> > >
> > >   b570868: x86: apic - unify APIC_DIVISOR
> > >
> > > And i removed:
> > >
> > >   eada62c: acpi/x86: introduce __apci_map_table, v4
> > >
> > > [ Cc:-ed Yinghai for that - we can live without that patch (i.e. we at
> > >   most get a leak warning) and can have that via acpi.git, correct? ]
> >
> > yes. we have several patches that even didn't pick up for a while.
> >
> > also please ask Linus to pull pci tree from Jesse before sparseirq.
> >
> > because we need
> > 	PCI: change MSI-x vector to 32bit
> >
> > in pci tree.
> 
> I should have my pull ready soon; I'd like to do some cross compile tests with 
> my latest bits first.  But I think Ingo has a copy of this commit anyway so 
> it may be ok for Linus to pull anyway.

Correct, it's safe to pull it, because irq/sparseirq has this commit:

  9e40236: pci: change msi-x vector to 32bit

it's content-equal with yours so your merge should be painless.

	Ingo
