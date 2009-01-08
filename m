Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZAHPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZAHPLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZAHPLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:11:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZAHPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:11:03 -0500
Date: Thu, 8 Jan 2009 16:10:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090108151046.GK18120@elte.hu>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Hmm. Where in Kconfig is SMP for M386 not allowed?
> > 
> > Dunno, kconfig is too much of a jungle for a simple person like me ;-)
> > 
> > But afaik i386 (and possibly i486) don't support nearly enough for a
> > modern SMP system.
> > 
> > Alan used to have i486-smp I think, one of the very few ever made.
> 
> The first systems that supported the Intel MP standard are 486 based 
> with external APIC. The prior systems used various proprietary MP 
> interfaces from the simple stuff in the Compaq (which Linux doesn't 
> support as Compaq refused to allow Thomas Radke to contribute it) to the 
> fairly extreme end of things with the Sequent boxes.
> 
> In addition our FPU emulation and some of our handling for x86 
> processors where we have to do the WP bit in software is also not SMP 
> safe.
> 
> So our minimal spec for SMP is probably 486DX + external Intel APIC.
> 
> In practice I doubt there is a single Intel APIC type 486 SMP box on the 
> planet running Linux (or quite possibly running at all)

yeah, that's very likely true. I think we could eliminate some of the SMP 
complications by requiring cmpxchg presence for CONFIG_SMP, agreed?

	Ingo
