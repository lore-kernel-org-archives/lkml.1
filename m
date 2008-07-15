Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYGOQAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYGOQAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYGOQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:00:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:50301 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYGOQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:00:26 -0400
Subject: Re: [PATCH] x86: Introducing asm-x86/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1216133883.27455.252.camel@shinybook.infradead.org>
References: <1216114072.21749.1.camel@jaswinder.satnam>
	 <1216127174.30096.3.camel@jaswinder.satnam>
	 <1216133883.27455.252.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:29:38 +0530
Message-Id: <1216137578.2747.16.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Tue, 2008-07-15 at 07:58 -0700, David Woodhouse wrote:

> I don't like this bit though:
> 
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -65,6 +65,10 @@ struct getcpu_cache;
> >  #include <linux/quota.h>
> >  #include <linux/key.h>
> >  
> > +#ifdef CONFIG_X86
> > +#include <asm/syscalls.h>
> > +#endif
> > +
> >  asmlinkage long sys_time(time_t __user *tloc);
> >  asmlinkage long sys_stime(time_t __user *tptr);
> >  asmlinkage long sys_gettimeofday(struct timeval __user *tv,
> 
> We're going to want to do this for all architectures, aren't we? Perhaps
> it's better to provide <asm/syscalls.h> for all architectures from the
> beginning, and not bother with the ifdef? Or if you must have an ifdef,
> perhaps make it on something like ARCH_HAS_ASM_SYSCALLS_H rather than
> having to change it every time an architecture adds its own
> <asm/syscalls.h> file?
> 

OK, I will also create asm/syscalls.h for all the architectures.

Thank you,

Jaswinder Singh.

