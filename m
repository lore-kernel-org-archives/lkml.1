Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXBVUpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXBVUpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXBVUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:45:21 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:1998 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXBVUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:45:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CVsbTMhRc5ZgwKGx9UWYcE9/vRiloqVEtndJ/j03s2Ca/kc7TOhScm+0juDVTjcyq/sMC7EuNb8KfjGA2iXfsUxr0HDdmv/1Snp6lr/lrCLBTCxvnEY42Cr6uOVuMswK607VytSy1c8LBXVkFovIRLd6BHbX0RqDrdLMAG2PEr0=
Message-ID: <f2b55d220702221245j17b0383tb6045e211f7cb1fb@mail.gmail.com>
Date: Thu, 22 Feb 2007 12:45:16 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: x86 hardware and transputers (Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1HKJzc-0001pk-Fe@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221225711.GB32031@elte.hu>
	 <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
	 <20070222065125.GA862@elte.hu>
	 <f2b55d220702220059t7487a0a4mbe88b91dc033de4b@mail.gmail.com>
	 <E1HKJzc-0001pk-Fe@flower>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> > Yes, I will go back and read the code for myself.  This will take me
> > some time because I have only a hand-waving level of knowledge about
> > task_structs and pt_regs, and have largely avoided the dark corners of
> > the x86 architecture.
>
> This architecture was brought to us by windows on our screens. And it
> took years (a decade?) for them to use all hardware features:
>
>               (IA-32, i386) --> (MS Windows NT,9X)
>
> Yet you must still do much system programming to use that features.

Actually, this architecture was brought to us largely by WordPerfect,
VisiCalc, and IEEE754.  Nobody really cares what bloody operating
system the thing is running; they cared then, and care now, about
being able to write reports and memos that print cleanly and to build
spreadsheets that calculate correctly.  Both of these things are made
much more practical by predictable floating point semantics, which
meant at first that you had to write your own floating point library.
The first (and for a long time the only) piece of hardware to put
_usable_ hardware floating point within reach of the desktop was the
Intel 80387.  Usable, not because it was more accurate than the soft
version (it wasn't, actually quite the reverse), but because it got
the exception semantics right.

The '387 is what made the PC architecture the _only_ choice for the
corporate desktop, pretty much immediately upon its release in 1987.
My first corporate job was porting an electric utility's in-house
revenue requirements application -- written in Fortran with assembly
display routines -- from a Prime mini to the PC.  I still have the
nice leather coffee coaster with the Prime logo on my desk.  The rest
of Prime is dead and forgotten, largely because of the '387.

> transputers were (AFAIK) completely orthogonal to any today's x86 CPU
> architecture -- hardware parallelism, special programming language and
> technique to match this hardware. And they were chosen to work on Mars in
> mid-90th, while crowd wanted more stupid windows on cheap CPUs.

Y'know, what goes around comes around.  The HyperTransport CPU
interconnect from AMD that all the overclocker types are so excited
about is just the Transputer ports warmed over, with a modern cache
coherency protocol stacked on top.  Worked on one of those too, on the
Intel HyperCube -- it's not my fault that the i860 (predecessor of the
Itanic, in a way) lost its marbles so comprehensively on IRQ that you
couldn't do anything I/O intensive with it.

My first government job (at NASA) started with a crash course in Occam
and explicit parallelism, but it was so blindingly obvious that this
had no future outside its little niche that I looked around for other
stuff to do.  The adjacent console belonged to a Symbolics LISP
machine -- also clearly a box with no future, since the only
applications for it that still mattered (expert systems) were in the
last stages of being ported to a C-based expert system engine
developed down the hall (which is now open source, and which I have
had occasion to use for many purposes since).  I was a Mac weenie at
the time, so I polished my C skills working on the Mac port of CLIPS
and writing a genetic algorithm engine.  Had I stuck to the
Transputer, I would probably know a lot more about faking NUMA using a
cache coherency protocol than I do today.

> Thus, i think, you are thinking mostly on hardware level, while it's
> longstanding software problem, i.e. to use x86 (:.

I don't think much about hardware or software.  I think about shipping
products in volume at positive gross margin, even when what's coming
out of my fingertips is source code and shell commands.  That's why
I've worked mostly on widgets with ARMs inside in recent years.  But
I'm kinda bored with that, and Niagara or Octeon may wind up cheap in
volume if somebody with extra fab capacity scoops up the wreckage of
Sun or Cavium, so I'm here harassing people more competent than I
about what it takes to make them programmable by mere mortals.

Cheers,
- Michael
