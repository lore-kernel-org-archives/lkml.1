Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZG3R2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZG3R2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZG3R17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:27:59 -0400
Received: from kroah.org ([198.145.64.141]:59900 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZG3R17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:27:59 -0400
Date: Thu, 30 Jul 2009 10:26:57 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>, Mike Galbraith <efault@gmx.de>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
Message-ID: <20090730172657.GA8266@kroah.com>
References: <1248945770.7910.24.camel@marge.simson.net>
 <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
 <200907301517.57811.bzolnier@gmail.com>
 <200907301852.28172.IvDoorn@gmail.com>
 <1248973862.22552.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248973862.22552.4.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 07:11:02PM +0200, Johannes Berg wrote:
> On Thu, 2009-07-30 at 18:52 +0200, Ivo van Doorn wrote:
> 
> > [some text expressing his frustration]
> 
> This is exactly why I was against staging all the time. Now suddenly
> "The Crap" seems like a viable alternative. WAKE UP PEOPLE. The code is
> not useful. Just look at the code that Mike pasted into his email. That
> alone should be enough to send cold shivers down your spine!

Hm, "useful" is in the eye of the beholder.

There is no driver in the mainline kernel tree for this device, so a
"normal" user has no chance of getting it working, right?  That's why
-staging is working, there is a semi-working driver, and most
importantly, people willing to help out getting it working better.

The combination of the two is what works here.

So please, I understand your frustration on a lack of people helping out
with out-of-tree wireless drivers that don't quite work properly, but
please, that has NOTHING to do with the staging drivers.

Meanwhile, I'm off on the driver-devel list helping Mike fix this
problem, which seems simple enough to solve...

> What staging has achieved here is giving the crap vendor code a
> blessing, receiving it welcomingly and forgivingly instead of saying
> "well screw you, go ahead and ship this to your users but don't ever say
> you support Linux well" ... now even some hackers and just just "dumb
> users" think that the crap in staging could possibly at some point
> become useful code!

Odd, I don't seem to be giving anyone such a "blessing", you are reading
way too much into this.  The fact is this vendor does code drops and
runs away all the time, despite the code being in the staging tree or
not.  Without it in the staging tree users would be worse off, not
better, there is no pressure able to be applied here at all, so please
stop thinking that.

> It won't. EVER. No matter _how_ much you clean it up, it will NEVER fit
> into the code scheme that everything else wireless has adopted.

never say never, it will happen, just give us time :)

In the meanwhile, people like Bart and others are doing real work on
getting the staging code into shape and working for real users.  Who are
you to tell them to not do such work?

thanks,

greg "i love crap" k-h
