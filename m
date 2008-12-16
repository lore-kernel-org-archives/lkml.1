Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYLPSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYLPSMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYLPSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:11:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54428 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbYLPSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:11:40 -0500
Date: Tue, 16 Dec 2008 18:11:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0812160946410.14014@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 09:47:02 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 16 Dec 2008, Alan Cox wrote:
> >
> >   CC      arch/x86/kernel/traps.o
> >   CC      arch/x86/kernel/irq.o
> >   CC      arch/x86/kernel/irq_32.o
> > arch/x86/kernel/irq_32.c: In function ¡do_IRQ¢:
> > arch/x86/kernel/irq_32.c:211: error: ¡per_cpu__vector_irq¢ undeclared (first use in this function)
> > arch/x86/kernel/irq_32.c:211: error: (Each undeclared identifier is reported only once
> > arch/x86/kernel/irq_32.c:211: error: for each function it appears in.)
> > make[1]: ***
> > [arch/x86/kernel/irq_32.o] Error 1
> > 
> > gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) 
> 
> Hmm. That code has been like that since before -rc1. And I cannot 
> reproduce it in my 32-bit environment. That's with your config file, and 
> despite the fact that I have the same compiler version on that machine.

I built a 64bit kernel from the same source tree first, then did make
mrproper, then it broke. I'll investigate further.
