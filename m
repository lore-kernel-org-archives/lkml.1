Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZDOStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZDOStx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZDOSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:49:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZDOStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:49:43 -0400
Message-ID: <49E62BD5.6090508@zytor.com>
Date: Wed, 15 Apr 2009 11:47:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The thing is, I've seen totally bogus "Impact:" statements.
> 
> It just makes things look more official, without actually guaranteeing 
> that it's any more correct. For example, I've seen impact statements to 
> the effect of "cleanup", when (a) it wasn't and (b) it did other things 
> too.
> 
> At that point, it's just distraction and wrong.
> 

It's more than that: it's a red flag; an indication that the committer
didn't pay attention.  We hopefully notice and reject such patches (or
perhaps more frequently, fix their impact lines).  An error is indeed
problematic, but it can (and *should*) be recognized after the fact as
well and can be used to improve maintenance practices.

> And in fact, "cleanup" seems to be the most common one. Along with other 
> totally useless ones like "fix build" or just "Fix" .

"cleanup" is indeed the most common, as it is intended to signify a
trivial but nonzero code change.  Whether or not it's *correct* is
another matter.  "build fix" is valid and proper use: it tells that it
fixes a compilation error, which succinctly communicates both the
priority of the fix and how it needs to be validated.

> shows several "cleanuips" that are anything but. Those "cleanups" fix 
> build errors or actually change code. The "Impact:" statement is actively 
> misleading, adds absolutely _nothing_, and detracts from the real issue 
> and the real message.

One of the problems we do have is the lack of standardization; the
reason for that is that we started this out as an experiment, and
weren't really ready to crack down too hard on the exact usage.  This
of course means, too, that the meaning is slightly different for
different people, and although we can fix that for patches we commit, we
can't do that for other trees.

In short, I think we've gotten to the point that we need a spec in the
Documentation/ directory for this to continue to be useful.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

