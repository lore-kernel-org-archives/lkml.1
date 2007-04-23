Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXDWAIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXDWAIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 20:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXDWAIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 20:08:04 -0400
Received: from ozlabs.org ([203.10.76.45]:56313 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXDWAIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 20:08:02 -0400
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ulrich Drepper <drepper@gmail.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
In-Reply-To: <a36005b50704220916u1ac5bd35gd1fa978761f02ab8@mail.gmail.com>
References: <20070421154614.GA26169@elte.hu>
	 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
	 <20070421164241.GF2986@holomorphy.com>
	 <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
	 <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
	 <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org>
	 <a36005b50704211846g4ed1256fpad6a3a5670318314@mail.gmail.com>
	 <20070422070238.GH2986@holomorphy.com>
	 <a36005b50704220017y664eef89u5f78f1e089c5014@mail.gmail.com>
	 <20070422084843.GJ2986@holomorphy.com>
	 <a36005b50704220916u1ac5bd35gd1fa978761f02ab8@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 10:07:20 +1000
Message-Id: <1177286840.17026.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 09:16 -0700, Ulrich Drepper wrote:
> On 4/22/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> > On Sun, Apr 22, 2007 at 12:17:31AM -0700, Ulrich Drepper wrote:
> > > For futex(), the extension is needed for the FUTEX_WAIT operation.  We
> > > need a new operation FUTEX_WAIT_FOR or so which takes another (the
> > > fourth) parameter which is the PID of the target.
> > > For FUTEX_LOCK_PI we need no extension.  The futex value is the PID of
> > > the current owner.  This is required for the whole interface to work
> > > in the first place.
> >
> > We'll have to send things out and see what sticks here. There seems to
> > be some pickiness above.
> 
> I know Rusty will shudder since it makes futexes yet more complicated
> (although only if the user wants it) but if you introduce the concept
> of "yield to" then this extension makes really sense and it is a quite
> simple extension.  Plus: I'm the most affected by the change since I
> have to change code to use it and I'm fine with it.

Hi Uli,

	I wouldn't worry: futexes long ago jumped the shark.

	I think it was inevitable that once we started endorsing programs
bypassing the kernel for IPC that we'd want some form of yield_to().
And yield_to(p) has much more sane semantics than yield().

Cheers,
Rusty.


