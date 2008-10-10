Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbYJJTf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbYJJTf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbYJJTfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:35:18 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:58467 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760356AbYJJTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:35:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=kkH25HLLHSVKqGmzPAH3RDqLmiXKURN+WLDd44UHajuBqLSAmOXlHd5f1BNqsWWo9bxuavTvSIPq7tEcRubLQGA37Ir8b9I7rhleomJJwf0aGeB7Sq+ij/nOuK8nXpgH;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #9, sparse =?iso-8859-1?q?IRQ=09support?=
Date: Fri, 10 Oct 2008 12:34:56 -0700
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20081010001727.GA14132@elte.hu> <20081010185912.GF21876@elte.hu> <48EFA8CA.1020600@kernel.org>
In-Reply-To: <48EFA8CA.1020600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101234.57440.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 10, 2008 12:11 pm Yinghai Lu wrote:
> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >> Linus,
> >>
> >> Please pull the latest x86-v28-for-linus-phase9 git tree from:
> >>
> >> Sparse IRQ support - make NR_IRQS dynamic by turning it into nr_irqs,
> >> an by creating irq descriptors in a sparse way.
> >>
> >> Includes a number of dependent x86 topics: timers/hpet-percpu, IO-APIC
> >> and local APIC code unification, UV support updates.
> >>
> >> Has been cross-built on all architectures we could get crosscompilers
> >> for:
> >>
> >>   http://www.tglx.de/autoqa/index
> >>
> >> It should be largely uneventful for sparse-irq unaware, non-x86
> >> architectures.
> >
> > please find updated pull request below. Relative to phase-N-1. Updates
> > from today in this class of topics:
> >
> >   b570868: x86: apic - unify APIC_DIVISOR
> >
> > And i removed:
> >
> >   eada62c: acpi/x86: introduce __apci_map_table, v4
> >
> > [ Cc:-ed Yinghai for that - we can live without that patch (i.e. we at
> >   most get a leak warning) and can have that via acpi.git, correct? ]
>
> yes. we have several patches that even didn't pick up for a while.
>
> also please ask Linus to pull pci tree from Jesse before sparseirq.
>
> because we need
> 	PCI: change MSI-x vector to 32bit
>
> in pci tree.

I should have my pull ready soon; I'd like to do some cross compile tests with 
my latest bits first.  But I think Ingo has a copy of this commit anyway so 
it may be ok for Linus to pull anyway.

-- 
Jesse Barnes, Intel Open Source Technology Center
