Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXDOFRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXDOFRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 01:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXDOFRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 01:17:08 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:49847
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXDOFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 01:17:07 -0400
Date: Sat, 14 Apr 2007 22:16:45 -0700
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415051645.GA28438@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704151327.13589.kernel@kolivas.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 01:27:13PM +1000, Con Kolivas wrote:
...
> Now that you're agreeing my direction was correct you've done the usual Linux 
> kernel thing - ignore all my previous code and write your own version. Oh 
> well, that I've come to expect; at least you get a copyright notice in the 
> bootup and somewhere in the comments give me credit for proving it's 
> possible. Let's give some other credit here too. William Lee Irwin provided 
> the major architecture behind plugsched at my request and I simply finished 
> the work and got it working. He is also responsible for many IRC discussions 
> I've had about cpu scheduling fairness, designs, programming history and code 
> help. Even though he did not contribute code directly to SD, his comments 
> have been invaluable.

Hello folks,

I think the main failure I see here is that Con wasn't included in this design
or privately in review process. There could have been better co-ownership of the
code. This could also have been done openly on lkml (since this is kind of what
this medium is about to significant degree) so that consensus can happen (Con
can be reasoned with). It would have achieved the same thing but probably more
smoothly if folks just listened, considered an idea and then, in this case,
created something that would allow for experimentation from outsiders in a
fluid fashion.

If these issues aren't fixed, you're going to stuck with the same kind of creeping
elitism that has gradually killed the FreeBSD project and other BSDs. I can't
comment on the code implementation. I'm focus on other things now that I'm at
NetApp and I can't help out as much as I could. Being former BSDi, I had a first
hand account of these issues as they played out.

A development process like this is likely to exclude smart people from wanting
to contribute to Linux and folks should be conscious about this issues. It's
basically a lot of code and concept that at least two individuals have worked
on (wli and con) only to have it be rejected and then sudden replaced by
code from a community gatekeeper. In this case, this results in both Con and
Bill Irwin being woefully under utilized.

If I were one of these people. I'd be mighty pissed.
 
bill

