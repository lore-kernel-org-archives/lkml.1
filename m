Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYEALiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYEALiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYEALir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:38:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49747 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbYEALiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:38:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 13:38:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011338.34735.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Linus Torvalds wrote:
> > 
> > You (and Andrew) have tried to argue that slowing things down results in 
> > better quality,
> 
> Sorry, not Andrew. DavidN.
> 
> Andrew argued the other way (quality->slower), which I also happen to not 
> necessarily believe in, but that's a separate argument.
> 
> Nobody should ever argue against raising quality.
> 
> The question could be about "at what cost"? (although I think that's not 
> necessarily a good argument, since I personally suspect that good quality 
> code comes from _lowering_ costs, not raising them).
> 
> But what's really relevant is "how?"
> 
> Now, we do know that open-source code tends to be higher quality (along a 
> number of metrics) than closed source code, and my argument is that it's 
> not because of bike-shedding (aka code review), but simply because the 
> code is out there and available and visible.
> 
> And as a result of that, my personal belief is that the best way to raise 
> quality of code is to distribute it. Yes, as patches for discussion, but 
> even more so as a part of a cohesive whole - as _merged_ patches!
> 
> The thing is, the quality of individual patches isn't what matters! What 
> matters is the quality of the end result. And people are going to be a lot 
> more involved in looking at, testing, and working with code that is 
> merged, rather than code that isn't.
> 
> So _my_ answer to the "how do we raise quality" is actually the exact 
> reverse of what you guys seem to be arguing.
> 
> IOW, I argue that the high speed of merging very much is a big part of 
> what gives us quality in the end. It may result in bugs along the way, but 
> it also results in fixes, and lots of people looking at the result (and 
> looking at it in *context*, not just as a patch flying around).

And we introduce bugs that nobody sees until they appear in a CERT advisory.

IMnsHO, the quick merging results in lots of code that nobody looked at,
except for the author, nobody is looking at and nobody will _ever_ look at.
Simply, because there's no time for looking at that code, since we're
supposed to be working on preparing new code for the next merge window, testing
the already merged code etc., around the clock.  Now, you may hope that this
not-looked-at-by-anyone code is of high quality nevertheless, but I somehow
doubt it.

[Note that it's not directly related to the issue at hand, which is the fact
that people affected by regressions are heavily punished by our current
process.  Never mind, though.]

And that's not to mention bugs that appear in the code everybody looked at
and happily reach the mainline because that code has not been tested well
enough before merging.  Take SLUB as an example, if you wish.

The fact is, we're merging stuff with minimal-to-no review and with minimal
testing reasonably possible.  Is _that_ supposed to produce the high quality?

Also, I'm not buying the argument that the quality of code improves over time
just because it's open and available to everyone.  That only happens to the
code which is actually looked at by someone or attempted to modify.  This
obviously doesn't apply to the whole kernel code.

For this reason, IMO, we should do our best to ensure that the code being
merged is of high quality already at the moment we merge it.  How to achieve
that is a separate issue.

BTW, we seem to underestimate testing in this discussion.  In fact, the vast
majority of kernel bugs are discovered by testing, so perhaps the way to go
is to make regular testing of the new code a part of the process.

Thanks,
Rafael
