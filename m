Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbXKJIX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbXKJIX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXKJIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:23:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48608 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXKJIXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:23:47 -0500
Message-ID: <47356A84.9020106@garzik.org>
Date: Sat, 10 Nov 2007 03:23:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org>
In-Reply-To: <20071110075444.GA5707@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Keeping ARCH=i386 and ARCH=x86_64 around is just a way to pretend
> this is two diffrent architectures which is no longer the case.

They _are_ different in the real world...  that's why

	make ARCH=i386

is so often used.


> Do we need a way to say "build a kernel that is 64 bit"?
> If we need this then we should look at the most intuitive way
> to say so and this should work across x86, powerpc and s390.
> 
> 	make 64BIT=y ARCH=x86
> 
> looks so much more intuitive. And it is generic.
> This is just a proposal.

Or the short and straightforward

	make ARCH=x86_64

to do the same thing (and incidentally what we've been doing up until 
this point).

Don't get so hung up on "architecture" and actually look at what people 
do _today_.

All other solutions proposed are simply _longer_ ways to do exact the 
same thing.  "more work for same outcome" isn't optimal.

	Jeff


