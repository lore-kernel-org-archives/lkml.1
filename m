Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYK1NST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYK1NST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYK1NSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:18:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYK1NSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:18:07 -0500
Date: Fri, 28 Nov 2008 14:17:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: uv bau interrupt -- use proper interrupt number
Message-ID: <20081128131756.GA28138@elte.hu>
References: <20081126210210.GA8671@localhost> <20081126211841.GA20309@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126211841.GA20309@sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> On Thu, Nov 27, 2008 at 12:02:10AM +0300, Cyrill Gorcunov wrote:
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > CC: Andi Kleen <andi@firstfloor.org>
> > ---
> >  arch/x86/kernel/entry_64.S |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6.git/arch/x86/kernel/entry_64.S
> > ===================================================================
> > --- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
> > +++ linux-2.6.git/arch/x86/kernel/entry_64.S
> > @@ -945,7 +945,7 @@ apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
> >  	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
> >  #endif
> >  
> > -apicinterrupt 220 \
> > +apicinterrupt UV_BAU_MESSAGE \
> >  	uv_bau_message_intr1 uv_bau_message_interrupt
> >  apicinterrupt LOCAL_TIMER_VECTOR \
> >  	apic_timer_interrupt smp_apic_timer_interrupt
> > --
> 
> The interrupt handler does not use the hardcoded 220, but
> the declaration should indeed be fixed as above.
> (such a fix was once submitted
>  http://marc.info/?l=linux-kernel&m=122350309029050&w=2  but didn't
>  go anywhere)
> Thanks for the follow-up.

applied to tip/x86/irq, thanks guys!

	Ingo
