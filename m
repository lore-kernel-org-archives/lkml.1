Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXDYWTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXDYWTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXDYWTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:19:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422799AbXDYWTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:19:10 -0400
Date: Wed, 25 Apr 2007 15:18:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425214420.GG17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Pavel Machek wrote:
> 
> Not the same... but they are still related. "freeze" (for atomic
> snapshot) is actually subset of "suspend"... freeze needs DMAs off and
> saved state, and you need DMAs off and saved state for "suspend".

THEY HAVE ABSOLUTELY NOTHING IN COMMON!

Nobody in their right mind thinks that "disable DMA" and "suspend" are 
similar operations. 

> So it is actually correct to do "suspend" when you want "freeze"; it
> is just slow. That's why they only differ in parameter these days.

It is *not* correct to "suspend" when you want "freeze".

I don't understand how you can even *claim* something like that.

Here's a trivial example:
 - SCSI disk

Tell me, what does "suspend" do, and what does "freeze" (snapshot) do?

And name *one* thing that have in common.

I'll tell you: Nada. Zero. Zilch. Nothing.

"Freeze" for a disk is a total no-op. There is no DMA, there is no 
nothing. In contrast, "suspend" for a disk is a totally valid operation.

Anybody who claims that these two operations are "related" is a moron.

I'm sorry Pavel, but that's exactly how it is.

		Linus
