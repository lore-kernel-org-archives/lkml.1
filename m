Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbZG3SQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbZG3SQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZG3SQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:16:44 -0400
Received: from kroah.org ([198.145.64.141]:59583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZG3SQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:16:43 -0400
Date: Thu, 30 Jul 2009 11:13:17 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>, Mike Galbraith <efault@gmx.de>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
Message-ID: <20090730181317.GA27543@kroah.com>
References: <1248945770.7910.24.camel@marge.simson.net>
 <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
 <200907301517.57811.bzolnier@gmail.com>
 <200907301852.28172.IvDoorn@gmail.com>
 <1248973862.22552.4.camel@johannes.local>
 <20090730172657.GA8266@kroah.com>
 <1248977083.24886.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248977083.24886.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:04:43PM -0400, Dan Williams wrote:
> On Thu, 2009-07-30 at 10:26 -0700, Greg KH wrote:
> > On Thu, Jul 30, 2009 at 07:11:02PM +0200, Johannes Berg wrote:
> > > On Thu, 2009-07-30 at 18:52 +0200, Ivo van Doorn wrote:
> > > 
> > > > [some text expressing his frustration]
> > > 
> > > This is exactly why I was against staging all the time. Now suddenly
> > > "The Crap" seems like a viable alternative. WAKE UP PEOPLE. The code is
> > > not useful. Just look at the code that Mike pasted into his email. That
> > > alone should be enough to send cold shivers down your spine!
> > 
> > Hm, "useful" is in the eye of the beholder.
> > 
> > There is no driver in the mainline kernel tree for this device, so a
> > "normal" user has no chance of getting it working, right?  That's why
> > -staging is working, there is a semi-working driver, and most
> > importantly, people willing to help out getting it working better.
> > 
> > The combination of the two is what works here.
> > 
> > So please, I understand your frustration on a lack of people helping out
> > with out-of-tree wireless drivers that don't quite work properly, but
> > please, that has NOTHING to do with the staging drivers.
> > 
> > Meanwhile, I'm off on the driver-devel list helping Mike fix this
> > problem, which seems simple enough to solve...
> 
> Except that the energy you're now investing in fixing this could have
> gone into rt2x00, and we would come out ahead in the end.  Instead, the
> energy is sapped away by something that will *never* be mainlined.

On the contrary, I would have never spent any time working on rt2x00 :)

And are you trying to tell people _what_ to work on here?  That's a
slippery slope...

thanks,

greg k-h
