Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXC3LAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXC3LAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXC3LAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:00:21 -0400
Received: from ozlabs.org ([203.10.76.45]:46379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXC3LAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:00:20 -0400
Subject: Re: [PATCH] Use X86_EFLAGS_IF in x86-64/irqflags.h.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070330101209.GA79904@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain>
	 <20070329103602.GB52274@muc.de>
	 <1175166417.12230.206.camel@localhost.localdomain>
	 <20070329121958.GA35584@muc.de>
	 <1175224343.12230.368.camel@localhost.localdomain>
	 <20070330101209.GA79904@muc.de>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 20:59:54 +1000
Message-Id: <1175252394.12230.394.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 12:12 +0200, Andi Kleen wrote:
> On Fri, Mar 30, 2007 at 01:12:23PM +1000, Rusty Russell wrote:
> > On Thu, 2007-03-29 at 14:19 +0200, Andi Kleen wrote:
> > > On Thu, Mar 29, 2007 at 09:06:57PM +1000, Rusty Russell wrote:
> > 
> > [SNIP: processor-flags.h patch for i386 ]
> > 
> > > Ok. Can you do it for x86-64 too?
> > 
> > OK, here it is.  Compiles, but -rc5-mm2 doesn't link for me on x86-64 at
> > the moment.
> 
> What's the problem? 

Sorry, should have included it, I assumed a known issue:

  LD      .tmp_vmlinux1
ld: section .vsyscall_1 [0000000000533400 -> 000000000053342e] overlaps section .jiffies [0000000000533400 -> 0000000000533407]
ld: .tmp_vmlinux1: section .vsyscall_1 lma 0x533400 overlaps previous sections
make: *** [.tmp_vmlinux1] Error 1

Cheers,
Rusty.

