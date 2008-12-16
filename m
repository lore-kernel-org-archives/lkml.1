Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYLPSg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYLPSg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYLPSgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:36:50 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57081 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYLPSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:36:50 -0500
Date: Tue, 16 Dec 2008 19:38:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081216183817.GA25108@uranus.ravnborg.org>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain> <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 06:11:33PM +0000, Alan Cox wrote:
> On Tue, 16 Dec 2008 09:47:02 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Tue, 16 Dec 2008, Alan Cox wrote:
> > >
> > >   CC      arch/x86/kernel/traps.o
> > >   CC      arch/x86/kernel/irq.o
> > >   CC      arch/x86/kernel/irq_32.o
> > > arch/x86/kernel/irq_32.c: In function ‘do_IRQ’:
> > > arch/x86/kernel/irq_32.c:211: error: ‘per_cpu__vector_irq’ undeclared (first use in this function)
> > > arch/x86/kernel/irq_32.c:211: error: (Each undeclared identifier is reported only once
> > > arch/x86/kernel/irq_32.c:211: error: for each function it appears in.)
> > > make[1]: ***
> > > [arch/x86/kernel/irq_32.o] Error 1
> > > 
> > > gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) 
> > 
> > Hmm. That code has been like that since before -rc1. And I cannot 
> > reproduce it in my 32-bit environment. That's with your config file, and 
> > despite the fact that I have the same compiler version on that machine.
> 
> I built a 64bit kernel from the same source tree first, then did make
> mrproper, then it broke. I'll investigate further.

Smells like a kbuild issue.
Please copy me and linux-kbuild@vger.kernel.org on any findings.

[My 64 bit toolchain is br0ken atm so I could not try to reproduce]

	Sam
