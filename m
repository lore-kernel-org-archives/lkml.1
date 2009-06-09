Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZFISHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZFISHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZFISHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:07:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZFISHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:07:10 -0400
Date: Tue, 9 Jun 2009 11:06:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <4A2E7B40.4070608@zytor.com>
Message-ID: <alpine.LFD.2.01.0906091103080.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
 <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <4A2E7B40.4070608@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, H. Peter Anvin wrote:
> 
> A major problem is that distros don't seem to be willing to push 64-bit
> kernels for 32-bit distros.  There are a number of good (and
> not-so-good) reasons why users may want to run a 32-bit userspace, but
> not running a 64-bit kernel on capable hardware is just problematic.

Yeah, that's just stupid. A 64-bit kernel should work well with 32-bit 
tools, and while we've occasionally had compat issues (the intel gfx 
people used to claim that they needed to work with a 32-bit kernel because 
they cared about 32-bit tools), they aren't unfixable or even all _that_ 
common.

And they'd be even less common if the whole "64-bit kernel even if you do 
a 32-bit distro" was more common.

The nice thing about a 64-bit kernel is that you should be able to build 
one even if you don't in general have all the 64-bit libraries. So you 
don't need a full 64-bit development environment, you just need a compiler 
that can generate code for both (and that should be the default on x86 
these days).

			Linus
