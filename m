Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbZCNRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbZCNRAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCNQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:59:45 -0400
Received: from www.tglx.de ([62.245.132.106]:48894 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZCNQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:59:44 -0400
Date: Sat, 14 Mar 2009 17:58:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: trampoline.c cleanup
In-Reply-To: <1237048511.4546.34.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903141757000.29264@localhost.localdomain>
References: <1237045494.4546.22.camel@ht.satnam>  <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain> <1237048511.4546.34.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
> Hello Thomas,
> 
> On Sat, 2009-03-14 at 17:20 +0100, Thomas Gleixner wrote:
> > On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
> > 
> > > Subject: [PATCH] x86: trampoline.c cleanup
> > > 
> > > Impact: cleanup
> > > 
> > >  - fix style problems
> > 
> > Err. This patch is a style problem itself.
> >  
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/kernel/trampoline.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> > > index 808031a..e3b1f2e 100644
> > > --- a/arch/x86/kernel/trampoline.c
> > > +++ b/arch/x86/kernel/trampoline.c
> > > @@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
> > >  	 * trampoline before removing it. (see the GDT stuff)
> > >  	 */
> > >  	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
> > > -#endif
> > > +#endif /* CONFIG_X86_32 */
> > 
> > There is no need for this useless comment. The #ifdef is 5 lines
> > above. Such comments are only helpful in large nested sections.
> > 
> 
> Ahh, So
> 
> 	if (ifdef < 5)
> 		Rule #1
> 	else
> 		Rule #2

Sigh. I asked for applying common sense not for creating another
stupid rule.

Thanks,

	tglx
