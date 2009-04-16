Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZDPBIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZDPBIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZDPBIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:08:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZDPBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:08:15 -0400
Date: Wed, 15 Apr 2009 18:03:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090416004430.GA22616@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu>
 <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
> 
> So would a:
> 
>    The impact of this change: it is a pure cleanup.
> 
> Formalization be acceptable? We tried to make it short and fit into 
> a single line - but we can certainly make it longer.

Language is not a "fit to one string" thing.

It doesn't matter what the string is: if you haev a fixed format, it's not 
human language. It's that easy.

Don't make up stupid fixed-format rules, and most certainly don't make 
them make the real payload harder to tread.

If people write "The impact of this is to fix compilation", then that's 
fine as an occasional thing, although it's damned stilted English, and I 
certainly wouldn't ever recommend it. Why not just say

	This fixes a compile problem in file so-and-so.

instead? Much clearer to everybody.

> You just dont seem to understand why i find it useful. You also seem 
> to try to deprive us the basic right of creating new, field-specific 
> language variants we find useful in our everyday work. And that 
> sucks.

YOU HAVE NEVER GIVEN A COHERENT REASON FOR FINDING IT USEFUL!

Yes, you bring up the same reason every time: namely that you want to know 
what the patch does. But never _once_ have you given a reason fo why that 
fixed-format string helps at all.

That's what i've been trying to tell you: don't use stilted and artificial 
fixed formats where it doesn't make sense.

Instead of

	Impact: cleanup

just write

	Cleanup xyz by doing abc

which is MORE informational, and much easier for everybody to read.

That's all I'm asking. Stop making the commit messages harder to read, 
uglier, and less informative. 

[ And if it's purely for "grep", then you can damn well hide it at the end 
  where nobody sane cares any more, but you seem to not have been able to 
  acknowledge that if it's for 'grep', then you're _missing_ all the 
  changes that don't have that string in the first place, so that's not a 
  very good reason _either_. ]

			Linus
