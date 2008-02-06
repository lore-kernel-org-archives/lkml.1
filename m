Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYBFUfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYBFUfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYBFUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:34:53 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:41434 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbYBFUev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:34:51 -0500
Date: Wed, 6 Feb 2008 21:34:49 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Diego Zuccato <diego@otello.alma.unibo.it>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206213449.6614efea@weinigel.se>
In-Reply-To: <1202161091.15090.84.camel@violet>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<47A764ED.8030605@weinigel.se>
	<1202161091.15090.84.camel@violet>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 22:38:11 +0100
Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Christer,
> 
> while the HAL case of Atheros might be still true despite the fact
> that an OpenHAL has been around for a long time now. The Intel
> argument is out of the picture since quite some time. The regulatory
> daemon was an interim solution and has been replaced by a proper
> firmware solution. So please get your examples up-to-date.

So how does that invalidate my point?  Intel did jump through a lot of
hoops to avoid giving away the code that controls their radio.  When
the regulatory daemon stuff got too much complaints, they finally
redid their firmware to avoid the daemon.  But they still have not
exposed the details on how to control their radio.

> You might wanna now point to hiding something in firmware, but the
> hardware, firmware, driver separation (with being hardware and
> firmware closed source) is an accepted solution. It is a clean
> separation. Interface wise and license wise. 

Yes, that is a nice solution.  Provided that you have any firmware at
all.  But price is everything, chips become dumber and dumber and more
control functions are pushed to the host.  If you want to sell a device
in Korea, price is everything; if you can shave off 30 cents by putting
the firmware in ROM, or by using 1.5 mbits of flash instead of 2 mbits,
that means an increase in market share or profit margins.  

> Remember that nobody inside the community ever asked for any kind of
> IP or trade secrets. We only want specifications so we can write the
> drivers under an appropriate open source license. If the
> specification describes an API exposed via firmware then that is
> perfectly fine.

I definitely agree.  I think it's stupid of companies to hide away
their documentation out of fear of, well, something.  I find it
extremely frustrating when I bought a device touted as "the first open
Linux mobile", just to find out that it used a binary-only kernel module
for the M-Systems DiskOnChip.  A quite nice phone, but due to that one
module, it was completely impossible to use anything but the ancient
2.4 kernel it came with.

I also think that my customers, that decided to keep their kernel
modules binary only, made a big mistake and have told them so.  But I
still think it's better for the Linux community to be a bit soft on
such companies for a while.  It's better to let them get away with it
for a while, and slowly try to convince them about the error of their
ways, rather than see them go with Windows CE or a BSD.

  /Christer


