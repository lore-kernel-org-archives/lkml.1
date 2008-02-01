Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYBAURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYBAURV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYBAURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:17:12 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48106 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbYBAURK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:17:10 -0500
Date: Fri, 1 Feb 2008 21:17:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
Message-ID: <20080201201713.GA15905@uranus.ravnborg.org>
References: <20080201104718.GA11717@uranus.ravnborg.org> <20080201030329.9b760777.akpm@linux-foundation.org> <47A34C47.9040306@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A34C47.9040306@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another way to look at it...  All of a sudden, different from 2.6.24, 
> kernel 2.6.25-git build spews so many warnings that I need to disable 
> section mismatch checking completely, because there is so much noise 
> that __normal build messages scroll off the screen__.

One can ignore or one can fix...
I decided to spend some of my friday on fixing section mismatch
warnings as I've got a bit irritated over people spending time
complaining but failing to provide patches.

My work approach was to seelct a directory and fix all warnings
there before moving on. So I did not as such pick the easy ones
or anything like that.

Despite this I managed with a one day effort to bring down
the number of warnings in my build from 106 to 50 warnings.
And yesterday the figure was 136.

So when complaining about the number of warnings I can only say
that we would all benefit if they are fixed.
Just ignoring them will not sort it out.

I did not pull your latest patches so my numbers are outdated
for net/drivers/ which alone count for 11 out of 50 warnings
in my tree.

I am also eagerly awaiting Andrew to push as he has a few
patches pending all over but the section mismatch warnings
are the least of his worries these days.

I hope to get down to less than 20 warnings in my allyesconfig
build before the merge window closes.
And with just a bit of assistance from others this
is doable.

	Sam - who expected more people to actually fix this stuff :-(
