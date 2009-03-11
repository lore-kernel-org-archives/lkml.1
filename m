Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZCKQKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZCKQKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZCKQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:10:05 -0400
Received: from kroah.org ([198.145.64.141]:55779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751421AbZCKQKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:10:04 -0400
Date: Wed, 11 Mar 2009 09:02:08 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: Staging, place holder for better company/community development
	model
Message-ID: <20090311160208.GA21561@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com> <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com> <1236583282.4205.71.camel@johannes.local> <20090309194132.GB15011@kroah.com> <1236633633.9658.23.camel@johannes.local> <20090311050018.GB26202@kroah.com> <1236762491.9658.85.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236762491.9658.85.camel@johannes.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:08:11AM +0100, Johannes Berg wrote:
> On Tue, 2009-03-10 at 22:00 -0700, Greg KH wrote:
> 
> > > Except it doesn't work for most of the wireless drivers you've sucked in
> > > without asking any wireless developers whether that makes any sense or
> > > not.
> > 
> > Any specific examples?
> 
> wlan-ng is the largest example, it's a load of crap, much of it being a
> driver for hardware we already have drivers for, and the remaining
> hardware being mostly unavailable these days. The driver served it's
> purpose at a time, but the authors had years and years of time to bring
> it in and never bothered. It needs to be incorporated into a
> rearchitectured orinoco driver, or so.

So you are objecting to the fact that some people are spending their own
time cleaning up this driver, which is only enabled for the devices that
are not supported by any other Linux wireless driver, because the
original developers never took the time to do the cleaning up
themselves?

Why do you want to tell others how to spend their time, when they are
trying to get devices to work properly with Linux that otherwise would
not?

> I also remember objecting to rt2860/rt2870, and the only good thing that
> has come out of adding those is a spatch that might otherwise not have
> been applied to those drivers. Afaict, no new people have helped with
> rt2800, the rt2x00 based driver for this hardware, because they've come
> in contact with rt2860/rt2870.

So you think that the staging tree is pulling away developer help for
the other "proper" kernel drivers?

> I don't remember any discussion about rtl8187se either.

Was there supposed to be some?

I sure discussed it, as I have hardware here that needs it, yet trying
to get it working in the in-kernel driver was pretty much impossible.
So I added the staging driver and lots of users are now happy that Linux
works on their hardware and they don't have to go download some random
driver to get it to work.

> All of those bring their own 802.11 stack, and changing to the Linux one
> will /necessarily/ require an entire rewrite of the drivers because the
> stacks operate /completely/ differently.

I agree, and don't see how this is a problem.

> Even the clean, in-kernel bcm43xx driver was rewritten to b43 for
> mac80211, and rtl8187se ships the old ieee80211_softmac code that I
> and a few others wrote...

Yes, these drivers are going to take a lot of work to get into "proper"
mergable shape.  But that's the whole point of the staging tree!  To do
this work, in the kernel, with lots of other developers, all the while
letting real people use their hardware with Linux today.

thanks,

greg k-h
