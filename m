Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBFUz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBFUz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYBFUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:55:25 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56051 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444AbYBFUzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:55:23 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: Diego Zuccato <diego@otello.alma.unibo.it>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080206213449.6614efea@weinigel.se>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D895.20300@davidnewall.com> <47A6E742.80408@otello.alma.unibo.it>
	 <47A764ED.8030605@weinigel.se> <1202161091.15090.84.camel@violet>
	 <20080206213449.6614efea@weinigel.se>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 21:55:45 +0100
Message-Id: <1202331345.15090.235.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christer,

> > while the HAL case of Atheros might be still true despite the fact
> > that an OpenHAL has been around for a long time now. The Intel
> > argument is out of the picture since quite some time. The regulatory
> > daemon was an interim solution and has been replaced by a proper
> > firmware solution. So please get your examples up-to-date.
> 
> So how does that invalidate my point?  Intel did jump through a lot of
> hoops to avoid giving away the code that controls their radio.  When
> the regulatory daemon stuff got too much complaints, they finally
> redid their firmware to avoid the daemon.  But they still have not
> exposed the details on how to control their radio.

find an Intel engineer that worked on it. There is a bigger story behind
it and I am not telling it.

And btw. it is perfectly fine that Intel is not giving full access to
their radios. Why should they?

> > You might wanna now point to hiding something in firmware, but the
> > hardware, firmware, driver separation (with being hardware and
> > firmware closed source) is an accepted solution. It is a clean
> > separation. Interface wise and license wise. 
> 
> Yes, that is a nice solution.  Provided that you have any firmware at
> all.  But price is everything, chips become dumber and dumber and more
> control functions are pushed to the host.  If you want to sell a device
> in Korea, price is everything; if you can shave off 30 cents by putting
> the firmware in ROM, or by using 1.5 mbits of flash instead of 2 mbits,
> that means an increase in market share or profit margins.  

I heard this all before and I don't buy it anymore. At some point the
companies in Asia will understand that the whole picture looks different
and that not always cheap, cheap, cheap is best for their margins.

And btw. the fully supported Linux hardware is in a lot of cases not
more expensive than the other ones.

> > Remember that nobody inside the community ever asked for any kind of
> > IP or trade secrets. We only want specifications so we can write the
> > drivers under an appropriate open source license. If the
> > specification describes an API exposed via firmware then that is
> > perfectly fine.
> 
> I definitely agree.  I think it's stupid of companies to hide away
> their documentation out of fear of, well, something.  I find it
> extremely frustrating when I bought a device touted as "the first open
> Linux mobile", just to find out that it used a binary-only kernel module
> for the M-Systems DiskOnChip.  A quite nice phone, but due to that one
> module, it was completely impossible to use anything but the ancient
> 2.4 kernel it came with.

You got one of the Greenphones ;)

> I also think that my customers, that decided to keep their kernel
> modules binary only, made a big mistake and have told them so.  But I
> still think it's better for the Linux community to be a bit soft on
> such companies for a while.  It's better to let them get away with it
> for a while, and slowly try to convince them about the error of their
> ways, rather than see them go with Windows CE or a BSD.

I disagree here. They either play by the roles or they really do pay
Microsoft or go with BSD. I really couldn't care less.

Regards

Marcel


