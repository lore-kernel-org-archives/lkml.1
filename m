Return-Path: <linux-kernel-owner+w=401wt.eu-S936953AbXG2XSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936953AbXG2XSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765001AbXG2XSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:18:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764015AbXG2XSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:18:43 -0400
Date: Sun, 29 Jul 2007 16:18:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: George Sescher <gesacs@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, George Sescher wrote:
> <chuckle>
> 
> You're advocating plugsched now?

I'd suggest people here take a look at the code. It's not what Ingo was 
saying, and it's not what the code is set up to do. He's just stating that 
the way he split up the files, it's actually easier from a patching 
standpoint to just create a new file to include instead of 
"kernel/sched_fair.c".

But quite frankly, I've seen a lot of totally stupid flamage, and very 
little actual sense in this discussion. People probably didn't even look 
at the patches. Did you?

For example, how hard is it for people to just admit that CFS actually 
does better than SD on a number of things? Including very much on the 
desktop. 

Ingo posted numbers. Look at those numbers, and then I would suggest some 
people could seriously consider just shutting up. I've seen too many 
idiotic people who claim that Con got treated unfairly, without those 
people admitting that maybe I had a point when I said that we have had a 
scheduler maintainer for years that actually knows what he's doing.

And no, it has never been about "desktop" vs "servers", or similar 
claptrap. It's been about improving the scheduler.

		Linus
