Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZHJIvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZHJIvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZHJIvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:51:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54685 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZHJIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:51:03 -0400
Date: Sun, 9 Aug 2009 15:01:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       swetland@google.com, linux-input@vger.kernel.org
Subject: Re: HTC Dream for staging: add support for input on GPIO pins
Message-ID: <20090809130054.GA1362@ucw.cz>
References: <20090808130315.GA12930@elf.ucw.cz> <5d5443650908080942l50d91d31qb23c494affdf6850@mail.gmail.com> <20090808214454.GB24153@elf.ucw.cz> <5d5443650908100031t5240daa4h76ef2a7863cc4403@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650908100031t5240daa4h76ef2a7863cc4403@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-08-10 13:01:28, Trilok Soni wrote:
> Hi Pavel,
> 

> >> I don't see any importance of gpio_matrix.c when we already have
> >> generic gpio matrix driver mainlined. I would suggest to remove those
> >> bits from this patch. I have added linux-input ML.
> >
> > Well, I'm trying for staging merge at this point. Reasons why
> > gpio_matrix is there are:
> >
> > 1) it is non-trivial to remove
> >
> > 2) it has some features mainline lacks
> >
> > 3) HTC Dream actually works with it
> >
> > (and 4) I'd like to submit code as Arve wrote it, then transform/clean
> > it up in staging).
> >
> > Of course, relevant features will need to be extracted from
> > gpio_matrix and merged at the right places, and that needs to happen
> > before move from staging/, but I'd like to have working keyboard in
> > the meantime.
> 
> gpio_matrix in mainline should work with HTC G1 with few proper
> platform data and input name eventhough ghost key clearance code is
> not yet in mainline driver.

I actually tried to write that platform hooks, but unfortunately I'm
quite far from being able to test them. 

> I know you want HTC dream to work through staging but I would prefer
> that such drivers should be discussed and reviewed on
> linux-input/linux-kernel ML and not just dumped in staging.

The stuff I'm submitting is not ready for proper review. It will take
a while before it is good enough. But I believe it has place in
staging: it will allow me to get Dream into usable state, and will
allow others to help with cleanups.

Of course, it will get proper review before moving to drivers/input.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
