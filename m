Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYIXJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYIXJIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIXJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:08:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:55037 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYIXJIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:08:43 -0400
Subject: Re: [git pull] timers fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1222246186.8277.69.camel@pasglop>
References: <200809240137.40403.rjw@sisk.pl> <20080924074038.GD3655@elte.hu>
	 <20080924074245.GA11474@elte.hu>  <1222246186.8277.69.camel@pasglop>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 18:51:31 +1000
Message-Id: <1222246291.8277.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 18:49 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2008-09-24 at 09:42 +0200, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > ------------------>
> > Marc Dionne (1):
> >       x86: prevent stale state of c1e_mask across CPU offline/online, fix
> 
> Is that all the changeset comment ? Am I the only one to find that
> totally useless ? Or is that the mail doesn't contain the actual
> comment, only the title followed by the patch ?

Allright, so in fact, it's more like the log doesn't match
the patch in the email..

Ben.

> Cheers,
> Ben.
> 
> > 
> >  arch/x86/kernel/process_32.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > index 4b3cfdf..31f40b2 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -55,6 +55,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/cpu.h>
> >  #include <asm/kdebug.h>
> > +#include <asm/idle.h>
> >  
> >  asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

