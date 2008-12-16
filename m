Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYLPRrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYLPRrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYLPRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:47:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbYLPRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:47:12 -0500
Date: Tue, 16 Dec 2008 09:47:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
In-Reply-To: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Alan Cox wrote:
>
>   CC      arch/x86/kernel/traps.o
>   CC      arch/x86/kernel/irq.o
>   CC      arch/x86/kernel/irq_32.o
> arch/x86/kernel/irq_32.c: In function ¡do_IRQ¢:
> arch/x86/kernel/irq_32.c:211: error: ¡per_cpu__vector_irq¢ undeclared (first use in this function)
> arch/x86/kernel/irq_32.c:211: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/irq_32.c:211: error: for each function it appears in.)
> make[1]: ***
> [arch/x86/kernel/irq_32.o] Error 1
> 
> gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) 

Hmm. That code has been like that since before -rc1. And I cannot 
reproduce it in my 32-bit environment. That's with your config file, and 
despite the fact that I have the same compiler version on that machine.

			Linus
