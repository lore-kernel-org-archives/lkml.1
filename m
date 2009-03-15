Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZCOEfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZCOEfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZCOEf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:35:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZCOEf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:35:28 -0400
Date: Sun, 15 Mar 2009 05:35:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: trampoline.c cleanup
Message-ID: <20090315043508.GA11150@elte.hu>
References: <1237045494.4546.22.camel@ht.satnam> <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain> <1237048511.4546.34.camel@ht.satnam> <alpine.LFD.2.00.0903141757000.29264@localhost.localdomain> <1237054312.3144.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237054312.3144.12.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-03-14 at 17:58 +0100, Thomas Gleixner wrote:
> > On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
> > > Hello Thomas,
> > > 
> > > On Sat, 2009-03-14 at 17:20 +0100, Thomas Gleixner wrote:
> > > > On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
> > > > 
> > > > > Subject: [PATCH] x86: trampoline.c cleanup
> > > > > 
> > > > > Impact: cleanup
> > > > > 
> > > > >  - fix style problems
> > > > 
> > > > Err. This patch is a style problem itself.
> > > >  
> > > > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > > > ---
> > > > >  arch/x86/kernel/trampoline.c |    3 ++-
> > > > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> > > > > index 808031a..e3b1f2e 100644
> > > > > --- a/arch/x86/kernel/trampoline.c
> > > > > +++ b/arch/x86/kernel/trampoline.c
> > > > > @@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
> > > > >  	 * trampoline before removing it. (see the GDT stuff)
> > > > >  	 */
> > > > >  	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
> > > > > -#endif
> > > > > +#endif /* CONFIG_X86_32 */
> > > > 
> > > > There is no need for this useless comment. The #ifdef is 5 lines
> > > > above. Such comments are only helpful in large nested sections.
> > > > 
> > > 
> > > Ahh, So
> > > 
> > > 	if (ifdef < 5)
> > > 		Rule #1
> > > 	else
> > > 		Rule #2
> > 
> > Sigh. I asked for applying common sense not for creating another
> > stupid rule.
> 
> Who made this stupid rule ?

What Thomas is saying is that instead of you trying to create 
some sort of rigid rule, you should apply common sense instead.

	Ingo
