Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbXJGGHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbXJGGHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 02:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXJGGHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 02:07:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXJGGHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 02:07:22 -0400
Date: Sun, 7 Oct 2007 08:07:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 0/2] Colored kernel output (run2)
Message-ID: <20071007060706.GA18768@elte.hu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006210349.GG22435@flower.upol.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0031]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Verych <olecom@flower.upol.cz> wrote:

> > > * completely useless, if properly implemented in userspace (with 
> > >   much reacher functionality).
> > 
> > that's hogwash. No user-space runs during early bootup. (and yes i 
> > want a color code at glance if something hangs in early bootup) 
> > Nothing will color-code crashes, etc., etc. Control of the _kernel_ 
> > console by user-space is complete nonsense.
> 
> If it is so important for major kernel developer like you, Ingo, then 
> why there's no scrollback at first place? Why nothing like that was 
> not implemented up until now?

even if it were true (which it isnt), that is not an argument against 
including a useful change that exists now and that people are interested 
in. (and yes, i have implemented kernel console improvements in the past 
and vga scrollback support was in fact amongst one of my first ever 
Linux kernel hacks so your comment is doubly wrong.)

> My first ever Linux hack was changing default console output color. I 
> think it was seven years ago. I though, it was not serious, if nobody 
> did that already (in the 2.2.14).
> 
> Please, don't mix important stuff here. I know, what kernel console 
> is.

your arguments are not an answer to my technical points, which i'll 
repeat here:

| | [...] No user-space runs during early bootup. (and yes i want a 
| | color code at glance if something hangs in early bootup) Nothing 
| | will color-code crashes, etc., etc. Control of the _kernel_ console 
| | by user-space is complete nonsense.

today's console code development goes in exactly the opposite direction: 
we are including (formerly-) user-space console functionality in the 
kernel so that we can for example print oopses even if we are in X mode.

> > this is nice and robust functionality that i personally welcome. The 
> > default is not changed in any way.
> > 
> > (btw., i corrected the subject line to remove the 'NAK'. Why do you 
> > think you can 'NAK' a patch in this field?)
> 
> I added comment (like this), so anyone can skip reading body, if 
> headers are "Oleg Verych && NAK". In case if `NAK' have a magic 
> meaning in the LKML, like control characters in the tty, i'm sorry.

yes, a 'NAK' has a particular meaning on lkml.

> But how to express opinion quickly and easily?

by writing a quick email expressing your opinion and waiting to see the 
discussion play out itself ...

but it is very rude to 'NAK' a patch and it should only be done 
carefully.

	Ingo
