Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbXHAHFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbXHAHFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbXHAHFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:05:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXHAHFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:05:35 -0400
Subject: RE: [ck] Re: Linus 2.6.23-rc1 -- It does not matter who's code
	gets merged!
From: Arjan van de Ven <arjan@infradead.org>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Carlo Florendo'" <subscribermail@gmail.com>,
       "'Roman Zippel'" <zippel@linux-m68k.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'jos poortvliet'" <jos@mijnkamer.nl>,
       "'Michael Chang'" <thenewme91@gmail.com>,
       "'Kasper Sandberg'" <lkml@metanurb.dk>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
In-Reply-To: <005001c7d403$8d7601a0$a86204e0$@com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <200707282003.45142.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
	 <200707282128.39906.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0708010539230.1818@scrub.home> <46B01E3F.6050401@gmail.com>
	 <005001c7d403$8d7601a0$a86204e0$@com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 01 Aug 2007 00:05:01 -0700
Message-Id: <1185951901.2754.12.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 23:16 -0700, Hua Zhong wrote:
> > Did Ingo have the obligation to improve Con's work? Definitely not.
> > Did Con have a right to get Ingo's improvements or
> > suggestions? Definitely not.
> 
> Yes, and that's where the inequality is.
> 
> Unless the maintainer does a really bad job or pisses off Linus,
> anyone who wants to merge his code into mainline pretty much
> has to get the blessing of the maintainer. On the other hand,
> as you just said, the maintainer has no such obligation.


I think a lot of people are missing some key things here:

It does not matter who's code gets merged.

The CFS-SD competition was a GOOD THING. Both sides were in heavy, fast
improvement mode, and competed on all fronts and borrowed heavily from
eachother in terms of ideas that worked, and innovated to stay ahead.
The end result is that both were good schedulers, and Linux won by
getting the fruit of this competition. Think of it as a mini-evolution
of scheduler ideas compressed into a short time period.

Now compare this to a single patch without competition/the need to
survive in the habitat, say the first SD or the first CFS patch....
whatever your poison is. If there had been no competition element, we
would have ended up with either one of those, and it would have been not
nearly as good as they both ended up as in the end.

Who wrote the code is not relevant in the large picture, the fact that
the problem at hand (2.6 scheduler behavior) got solved is. 

I wish people would focus less on who wrote the actual code that got
merged in the end, and more on the problem that got solved.... People
who care about the desktop should be happy that the scheduler improved a
lot due to the competition where the two new schedulers were hair-close
in most aspects. Again.. think about the problem being solved. Not who
wrote the code or which of the competitive patches got merged in the
end.

Let me repeat the key message:

It does not matter who's code gets merged.
It does not matter who's code gets merged.
It does not matter who's code gets merged.
It does not matter who's code gets merged.

What matters is that the problem gets solved and that the Linux kernel
innovates forward.


I've had several cases myself where I spent quite some time solving a
problem, just to get some random remark from someone smart on lkml
saying "if you had done <this simple thing> you would have had <this
simple and superior solution>". Was I pissed off that my patch didn't
get merged but that this better approach got picked? NO! The problem
that I needed to solve got solved in a really good way. Mission
accomplished.

(and merging the code that is cleaning up/smallest is a reasonable one
to pick for someone like Linus, likewise for the "which is likely to be
maintained best" arguments)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

