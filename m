Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbXLEJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbXLEJtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLEJtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:49:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXLEJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:49:05 -0500
Date: Wed, 5 Dec 2007 10:48:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lenb@kernel.org, ebiederm@xmission.com, protasnb@gmail.com, ak@suse.de,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Message-ID: <20071205094837.GB17911@elte.hu>
References: <200711280121.18376.lenb@kernel.org> <20071204122649.GB27286@elte.hu> <20071204163946.63ac73ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204163946.63ac73ce.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 4 Dec 2007 13:26:49 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Len Brown <lenb@kernel.org> wrote:
> > 
> > >     So while the irq compression code on i386 should really
> > >     be deleted -- even before merging the x86_64 irq-overhaul,
> > >     this patch simply disables it on all high volume systems
> > >     to avoid problems #1 and #2 on most all i386 systems.
> > >     
> > >     A large system with pin numbers >=64 will still have compression
> > >     to conserve limited IRQ numbers for sparse IOAPICS.  However,
> > >     the vast majority of the planet, those with only pin numbers < 64
> > >     will use an identity GSI -> IRQ mapping.
> > >     
> > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > thanks for the patch and the extensive description. I've applied this to 
> > x86.git.
> 
> Len applied it to his tree too.

Len, i think this belongs into x86.git a bit more (especially with the 
unification activities going on all around the tree) - do you agree? 
Andrew, i'd suggest to apply a reverted patch to between git.acpi and 
git.x86 until this gets sorted out.

	Ingo
