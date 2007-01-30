Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbXA3WIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbXA3WIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXA3WIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:08:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50891 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXA3WI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:08:29 -0500
Message-ID: <45BFC1DA.7040807@garzik.org>
Date: Tue, 30 Jan 2007 17:08:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
In-Reply-To: <ada4pq8qjpd.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > > Well, we can disagree about the majority of drivers.  My feeling is
>  > > that most of the drivers that are really used by lots of people get
>  > > support beyond just a dump of docs -- in fact often vendors are
>  > > maintaining them, eg e1000, tg3, cciss, etc., to pick some running on
>  > > the boxes I have around here.
>  > 
>  > Check your history...  tg3 was written by me and DaveM, and only after
>  > years was it picked up by the vendor as their official Linux
>  > driver. You have picked an excellent counter-example to your own
>  > argument.
> 
> OK, fair enough, I forgot about tg3.  But on the other hand, you wrote
> it without docs, actually _in spite of_ Broadcom, right?
> 
> Which I think makes my point that documentation is neither necessary
> nor sufficient for a good Linux driver.  Documentation helps, but if
> no one competent cares about the device then the driver won't get
> written.  On the other hand, if the device is important enough, the
> driver will get written without documentation or vendor support.

That's your point??  I thought your point was (quoting your words)

> it's a
> bit disingenous to suggest that all a company has to do to get a
> driver written and supported is throw some documentation over the
> wall.  And it's crazy to suggest that the driver will work on every
> platform and be supported by enterprise distros.

To repeat -- that's how most Linux drivers have been written, 
/particularly/ the ones used most by users of enterprise distros.


>  > > OK, but why isn't your army of volunteers fixing them?
>  > 
>  > Because nobody has hardware for them?
> 
> Greg said hardware wasn't necessary...

I did not say "no developers [...]"

I said "nobody"


>  > > And I seem to recall there's more SATA chipset documentation than Jeff
>  > > Garzik has time to implement support for.
>  > 
>  > I seriously doubt you can come up with even a single concrete example here.
> 
> Sorry, I thought you said there was interesting stuff to do with the
> Promise documentation you got.

Mikael took care of it already.  And its supported by enterprise distros.


> I guess Nvidia ADMA is pretty much
> done now.

Yep.  Without docs, even.  And its supported by enterprise distros.


>  > What experience?  AFAICS, pretty much all modern hardware in use
>  > outside of ATI/NVIDIA graphics is supported by Linux.
> 
> Sure, popular hardware support is pretty good.  But there are still
> pretty serious gaps, for example Ralink wireless drivers are still not
> upstream even with the vendor trying to help (and I think Ralink
> wireless is a good example of how we can't really keep the promises
> Greg is making).

How so?  They appear to be working with wireless devs to get their 
driver into the tree.


> And there's plenty of stuff in-tree with lots of users that's in
> pretty dire shape, like ISDN (and the fact that we still
> CONFIG_ISDN_I4L).  OK, it's not "modern" but Greg is also promising
> that we'll keep everything up-to-date with any upstream kernel
> changes, and there's obviously large chunks of the driver tree where
> that doesn't happen.

Yes, large chunks of legacy ISA drivers, m68k drivers, and similar 
situations where the userbase has dwindled to a handful over a decade.

	Jeff


