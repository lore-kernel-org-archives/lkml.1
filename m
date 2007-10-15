Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXJOJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXJOJHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXJOJHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:07:05 -0400
Received: from mx10.go2.pl ([193.17.41.74]:56532 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753751AbXJOJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:07:01 -0400
Date: Mon, 15 Oct 2007 11:10:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071015090959.GB1875@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org> <20071015074405.GA1875@ff.dom.local> <20071015080924.GA32562@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015080924.GA32562@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:09:24AM +0200, Nick Piggin wrote:
...
> Has performance really been much problem for you? (even before the
> lfence instruction, when you theoretically had to use a locked op)?
> I mean, I'd struggle to find a place in the Linux kernel where there
> is actually a measurable difference anywhere... and we're pretty
> performance critical and I think we have a reasonable amount of lockless
> code (I guess we may not have a lot of tight computational loops, though).
> I'd be interested to know what, if any, application had found these
> barriers to be problematic...

I'm not performance-words at all, so I can't help you, sorry. But, I
understand people who care about this, and think there is a popular
conviction barriers and locked instructions are costly, so I'm
surprised there is any "problem" now with finding these gains...

> The thing is that those documents are not defining what a particular
> implementation does, but how the architecture is defined (ie. what
> must some arbitrary software/hardware provide and what may it expect).

I'm not sure this is the right way to tell it. If there is no
distinction between what is and what could be, how can I believe in
similar Alpha or Itanium stuff? IMHO, these manuals sometimes look
like they describe some real hardware mechanisms, and sometimes they
mention about possible changes and reserved features too. So, when
they don't mention you could think it's a present behavior.

> It's pretty natural that Intel started out with a weaker guarantee
> than their CPUs of the time actually supported, and tightened it up
> after (presumably) deciding not to implement such relaxed semantics
> for the forseeable future.

As a matter of fact it's not natural for me at all. I expected the
other direction, and I still doubt programmers' intentions could be
"automatically" predicted good enough, so IMHO, it's not for long.
Of course, it doesn't seem to be any help for linux or bsd
programmers, which still have to think about different architectures.

Regards,
Jarek P.
