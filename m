Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYGKBTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYGKBTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYGKBT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:19:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbYGKBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:19:26 -0400
Date: Thu, 10 Jul 2008 18:18:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080711005243.ADE90154218@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807101806330.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
 <20080711005243.ADE90154218@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Roland McGrath wrote:
> 
> The "actual" downsides include numerous unknowns, and I always forget
> not to be surprised when you aren't scared that we have no idea what-all
> the code might actually do.

You're just grand-standing here.

The fact is, this has been "broken" for a long long time. A lot of 
applications (realistically, probably _all_ current 64-bit apps) have been 
tested with the old behaviour.

The thing is, I'm simply not the _least_ nervous about behavior that we've 
obviously had for a long time. And you shouldn't be either - nor should 
you try to make up some bogus argument to the contrary.

You should be scared about the case that IS NOT tested - which is by 
definition the new behaviour (admittedly only for 64-bit apps). Claiming 
anything else is just stupid and dishonest.

So stop making up _bad_ arguments. You do have a good one: the fact that 
x86-32 apparently works the way it works. But then you just irritate me 
with your idiotic other ones about how things are "supposed" to work.

So just be honest: you didn't have any _actual_ downsides that you knew 
about. Which was what I wondered about and asked about.

Those things make a big difference when I'm just about ready to cut a new 
release. This is _clearly_ not a regression (unless you talk about things 
from years and years ago), and apparently you don't have any actual code 
that is broken - just your expectations.

In short, it doesn't smell like something I should apply under -rc9 rules.

[ And dammit, I wish more developers would ask themselves that question: 
  "Does this patch need to go in when we're very late in the -rc 
  sequence?". Or at least not then try to grand-stand and avoid the 
  question I asked. ]

		Linus
