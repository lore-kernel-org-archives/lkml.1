Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZCNQfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZCNQfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCNQfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:35:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:53935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZCNQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:35:44 -0400
Subject: Re: [PATCH -tip] x86: trampoline.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain>
References: <1237045494.4546.22.camel@ht.satnam>
	 <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 22:05:11 +0530
Message-Id: <1237048511.4546.34.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Sat, 2009-03-14 at 17:20 +0100, Thomas Gleixner wrote:
> On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
> 
> > Subject: [PATCH] x86: trampoline.c cleanup
> > 
> > Impact: cleanup
> > 
> >  - fix style problems
> 
> Err. This patch is a style problem itself.
>  
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/trampoline.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> > index 808031a..e3b1f2e 100644
> > --- a/arch/x86/kernel/trampoline.c
> > +++ b/arch/x86/kernel/trampoline.c
> > @@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
> >  	 * trampoline before removing it. (see the GDT stuff)
> >  	 */
> >  	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
> > -#endif
> > +#endif /* CONFIG_X86_32 */
> 
> There is no need for this useless comment. The #ifdef is 5 lines
> above. Such comments are only helpful in large nested sections.
> 

Ahh, So

	if (ifdef < 5)
		Rule #1
	else
		Rule #2

Thanks,
--
JSR


