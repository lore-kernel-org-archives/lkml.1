Return-Path: <linux-kernel-owner+w=401wt.eu-S939335AbZDJSNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939335AbZDJSNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbZDJSNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:13:42 -0400
Received: from www.tglx.de ([62.245.132.106]:42636 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765864AbZDJSNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:13:42 -0400
Date: Fri, 10 Apr 2009 20:11:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [git-pull -tip] x86: declaration patches
In-Reply-To: <1239384111.3169.13.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904102010220.21577@localhost.localdomain>
References: <1239381184.23116.5.camel@ht.satnam>  <alpine.LFD.2.00.0904101849060.21577@localhost.localdomain> <1239384111.3169.13.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Jaswinder Singh Rajput wrote:

> On Fri, 2009-04-10 at 18:51 +0200, Thomas Gleixner wrote:
> > On Fri, 10 Apr 2009, Jaswinder Singh Rajput wrote:
> > >  #endif /* CONFIG_X86_32 */
> > > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > > index 8499000..d1bac67 100644
> > > --- a/arch/x86/kernel/apic/io_apic.c
> > > +++ b/arch/x86/kernel/apic/io_apic.c
> > > @@ -59,6 +59,7 @@
> > >  #include <asm/setup.h>
> > >  #include <asm/irq_remapping.h>
> > >  #include <asm/hpet.h>
> > > +#include <asm/hw_irq.h>		/* smp_irq_move_cleanup_interrupt */
> > 
> >   Can we please avoid these useless comments all over the place ?
> > 
> 
> I kept these intentionally because few of these declarations I have
> already fixed earlier.
> For example during process.c unification work developers forget to
> include and fix syscalls.h :

And how does such a comment help not to forget anything ? It's useless
information and just irritating to read like all end of line comments.

Thanks,

	tglx
