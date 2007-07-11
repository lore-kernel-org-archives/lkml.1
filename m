Return-Path: <linux-kernel-owner+w=401wt.eu-S1765002AbXGKVn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765002AbXGKVn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXGKVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:43:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbXGKVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:43:47 -0400
Date: Wed, 11 Jul 2007 14:42:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <20070711174252.GA16793@elte.hu>
Message-ID: <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Ingo Molnar wrote:
> 
> What you just did here is a slap in the face to a lot of contributors 
> who worked hard on this code :(

Ingo, I'm sorry to say so, but your answer just convinced me that you're 
wrong, and we MUST NOT take that code.

That was *exactly* the same thing you talked about when I refused to take 
the original timer changes into 2.6.20. You were talking about how lots of 
people had worked really hard, and how it was really tested.

And it damn well was NOT really tested, and 2.6.21 ended up being a 
horribly painful experience (one of the more painful kernel releases in 
recent times), and we ended up havign to fix a *lot* of stuff.

And you admitted you were wrong at the time.

Now you do the *exact* same thing.

Here's a big clue: it doesn't matter one _whit_ how much face-slapping you 
get, or how much effort some programmers have put into the code. It's 
untested. And no, we are *not* going to do another "rip everything out, 
and replace it with new code" again.

Over my dead body.

We're going to do this thing gradually, or not at all.

And if somebody feels slighted by the face-slap, and thinks he has already 
done enough, and isn't interested in doing it gradually, then good 
riddance. The "not at all" seems like a good idea, and maybe we can 
re-visit this in a year or two.

I'm not going to have another 2.6.21 on my hands.

		Linus
