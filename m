Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXHCPCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXHCPCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXHCPCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:02:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXHCPCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:02:16 -0400
Date: Fri, 3 Aug 2007 17:02:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "T. J. Brumfield" <enderandrew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about modularization
Message-ID: <20070803150209.GA13619@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <20070803131900.GA26203@elte.hu> <cdc89fe60708030651s54b5f0e0j938450632cf621c5@mail.gmail.com> <cdc89fe60708030652p634c6ea1y1f7b351f12a35a7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdc89fe60708030652p634c6ea1y1f7b351f12a35a7a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.1.7-deb
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* T. J. Brumfield <enderandrew@gmail.com> wrote:

> On 8/3/07, Ingo Molnar <mingo@elte.hu> wrote:
> > snip...
>
> Except that a working prototype of plugsched exists and functions 
> exactly as advertised. [...]

a prototype for dynamic syscalls exists too. A prototype for pluggable 
network IPv4 stacks exists too. A working implementation existed for 
STREAMS too. Existence of a patch still does not make any of them a good 
idea for the core kernel.

[ If existence of a patch was the only criterium for upstream merging 
  then we'd have a much poorer quality Linux kernel today. Odds are that 
  in that case you would not even know what 'Linux' means, it would 
  still be an obscure, niche hacker's toy somewhere on the 'net ;-) ]

> [...]  I understand that modules can be loaded and unloaded, where as 
> other aspects of the core kernel can't just load/unload as the kernel 
> is running, but the cpu scheduler could be selected at boot via a 
> command line, or as a kconfig option when compiling like the io 
> scheduler.

i replied to that in my previous mail:

   But the kernel core, which does not depend as much on the physical
   properties of the stuff it supports (it depends on the physics of the
   machine of course, but those rules are mostly shared between all
   machines of that architecture), and is fundamentally influenced by
   the syscall API (which is not modular either) and by our OS design
   decisions, has much less reason to be modularized.

But to put it in different words:

   _certain core kernel code should not be pluggable_

and whether it should or should not be pluggable is an entirely 
technical decision, up to the maintainers of that code.

> And while the io team may feel that it would be best to have one 
> scheduler that worked well under all circumstances, often this can't 
> simply be the case. [...]

you skipped the bit where i pointed it out how different CPU scheduling 
is from IO scheduling. Plus now you are arguing against the opinion of 
an IO maintainer too? :-)

	Ingo
