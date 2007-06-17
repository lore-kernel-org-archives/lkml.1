Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbXFQA7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbXFQA7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 20:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbXFQA7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 20:59:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900AbXFQA7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 20:59:14 -0400
Date: Sat, 16 Jun 2007 17:58:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Alexandre Oliva <aoliva@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070616233251.GA17270@brong.net>
Message-ID: <alpine.LFD.0.98.0706161728070.14121@woody.linux-foundation.org>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
 <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615072322.GA7594@brong.net>
 <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616021630.GA30660@brong.net>
 <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616103130.GD32405@brong.net>
 <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070616233251.GA17270@brong.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Jun 2007, Bron Gondwana wrote:
> 
> No, I'm arguing that it's not "mere aggregation" - the kernel is useless
> on that machine unless the BIOS is present or replaced with something
> else with equivalent functionality.

That's *not* a valid argument!

I know, I know, it's a common one, but it is *nonsense*.

The thing is, "mere aggregation" doesn't mean what you think it means.

"Mere aggregation" doesn't mean that they cannot depend on each other. It 
means that they are not *based* on each other in the sense of GPLv2.

In other words, "mere aggregation" is about two pieces that are not 
derivative works under copyright law.

For example, on a Red Hat DVD, *every*single*binary* on that DVD requires 
a kernel to run on. And the kernel image itself "depends" on the user 
programs to actually do something _useful_. 

But it's all still "mere aggregation", because they are not related to 
each other in the sense of being derived works!

So "mere aggregation" is not about intimacy. OF COURSE high-tech products 
depend intimately on each other. The Linux kernel cannot boot on a PC 
without a BIOS or something equivalent. You cannot run your graphical 
environment without a kernel, an X server, the CPU, the memory, the 
display, the BIOS, the power company (or an equivalent hand-crank) etc etc 
etc, and these things are all very much dependent on each other to make a 
"usable system", that has absolutely _zero_ relevance to whether they are 
"mere aggregation" or not.

So the only thing the "mere aggregation" phrase in the GPLv2 means is 
simply: "putting together two or more pieces that are not derived works of 
each other". That's what that

	mere aggregation of another work not based on the Program
	                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

part of the license is all about.  The BIOS is "another work", and it 
clearly is "not based on the Program". The "aggregation" just means 
"putting them together", and the "mere" is there just to show that as far 
as the license is concerned, that is not even interesting!

In other words, the sentence in section 2 about mere aggregation says one 
thing only: the fact that you lump things together storage-wise does not 
matter *at*all* for the license. The _only_ thing that matters for the 
GPLv2 is whether something is a derived work, _not_ whether it is lumped 
together, and depends on something else.

This is why the BIOS is irrelevant. You can put it in the same flash chip 
as the kernel: it still isn't a derived work of Linux (and Linux is not a 
derived work of the BIOS), and the GPLv2 explicitly makes it clear that 
the license holds no sway over the BIOS, even though it's physically on 
the same chip.

The BIOS can do whatever it wants to, and the GPLv2 has *nothing* to say 
about it. The GPLv2 makes that very clear indeed. It is just "mere 
aggregation", and the fact that they  are in the same machine, on the same 
harddisk, on the same flash rom, or on the same DVD doesn't bring them any 
closer from a *copyright* angle.

Copyright in general (and the GPLv2 in the specific) isn't about how 
things are *physically* tied together. It's not even about how things 
interconnect, and how "important" they are for each other. It is _purely_ 
about whether they are derived works.

So when the GPLv2 talks about "mere aggregation", it talks about it 
specifically to say that it does not matter, and that the license _only_ 
affects the actual derived work!

This is why the BIOS, the hardware, the programs you run under Linux etc 
etc are all totally irrelevant. The GPLv2 explicitly says that they are 
irrelevant as far as that license is concerned.

			Linus
