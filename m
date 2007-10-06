Return-Path: <linux-kernel-owner+w=401wt.eu-S1765282AbXJFUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765282AbXJFUtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763670AbXJFUto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:49:44 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45544 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476AbXJFUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:49:43 -0400
Date: Sat, 6 Oct 2007 23:03:49 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 0/2] Colored kernel output (run2)
Message-ID: <20071006210349.GG22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006194820.GA30579@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 09:48:20PM +0200, Ingo Molnar wrote:
> > 
> > This is a "kernel messages color-l10n".
> > 
> > * text code size, that cannot be zero if config option is not set;
> 
> not really an issue. Changing the inline function to non-inline will get 
> rid of most of the text cost. Embedded wont build in a console.

I'm trying to say "text size *and* config option is not set". That
have nothing to do with other text size reductions.

> > * completely useless, if properly implemented in userspace (with much
> >   reacher functionality).
> 
> that's hogwash. No user-space runs during early bootup. (and yes i want 
> a color code at glance if something hangs in early bootup) Nothing will 
> color-code crashes, etc., etc. Control of the _kernel_ console by 
> user-space is complete nonsense.

If it is so important for major kernel developer like you, Ingo, then
why there's no scrollback at first place? Why nothing like that was
not implemented up until now?   

My first ever Linux hack was changing default console output color. I
think it was seven years ago. I though, it was not serious, if nobody
did that already (in the 2.2.14).

Please, don't mix important stuff here. I know, what kernel console is.

> The kernel console is one of the most important information channels of
> the kernel towards the user.

I'd say: towards hard OOPs-handling developer.

> this is nice and robust functionality that i personally welcome. The 
> default is not changed in any way.
> 
> (btw., i corrected the subject line to remove the 'NAK'. Why do you 
> think you can 'NAK' a patch in this field?)

I added comment (like this), so anyone can skip reading body, if headers
are "Oleg Verych && NAK". In case if `NAK' have a magic meaning in the
LKML, like control characters in the tty, i'm sorry.

But how to express opinion quickly and easily?
____
