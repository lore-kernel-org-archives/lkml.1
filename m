Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbXGPXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbXGPXI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbXGPXHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:07:47 -0400
Received: from waste.org ([66.93.16.53]:48589 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765399AbXGPXHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:07:46 -0400
Date: Mon, 16 Jul 2007 18:07:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070716230719.GC11115@waste.org>
References: <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469BF768.6040200@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 12:55:36AM +0200, Rene Herman wrote:
> On 07/17/2007 12:37 AM, Ray Lee wrote:
> 
> >On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> 
> >>Seeing as how single-page stacks are much easier on the VM so that 
> >>creating those zillion threads should also be faster, at _some_
> >>percentage we get to say "and now to hell with the rest".
> >
> >This is the core dispute here. Stated differently, I hope you never
> >design a bridge that I have to drive over.
> >
> >Correctness first, optimization second. Introducing random and
> >difficult to trace crashes upon an unsuspecting audience of sysadmins
> >and users is not a viable option.
> 
> Quite. But unfortunately you didn't actually go into the bit on how given 
> seperate interrupt stacks, available stackspace might not actually _be_ 
> less after selecting CONFIG_4KSTCKS nor into Fedora and RHEL shipping it 
> already.
> 
> >If at some point one of the pro-4k stacks crowd can prove that all
> >code paths are safe
> 
> I'll do that the minute you prove the current shared 8K stacks are safe. Do 
> we have a deal?
> 
> >or introduce another viable alternative (such as Matt's idea for
> >extending the stack dynamically), then removing the 8k stacks option
> >makes sense.
> 
> I'm still waiting for larger soft-pages... does anyone in this thread have 
> a clue on their status?

Given that most x86 users won't want anything to do with them, it's
not going to help us at all here.

-- 
Mathematics is the supreme nostalgia of our time.
