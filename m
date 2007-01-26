Return-Path: <linux-kernel-owner+w=401wt.eu-S1030534AbXAZOcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534AbXAZOcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030533AbXAZOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:32:14 -0500
Received: from nic2.axis.se ([193.13.178.10]:34090 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030606AbXAZOcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:32:13 -0500
Date: Fri, 26 Jan 2007 15:31:49 +0100
Message-Id: <200701261431.l0QEVnbL003112@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net
In-reply-to: <200701250459.37728.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 04:59:37 -0800)
Subject: Re: 5 patches: updates to SPI and mmc_spi, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Thu, 25 Jan 2007 04:59:37 -0800

> So to summarize ... you now have MMC-over-SPI working on CRIS
> hardware, with these patches?

Yes.  FWIW, we'll ship with our ETRAX FS developer boards, soon
enough (in a week or so, knock-on-wood).

>   Can you yet run filesystem
> stress tests with ext3 on such an MMC card,

I'd have to configure it in, but I guess I could, if you're not
happy with just vfat.  I just copied (tarred both to file, and
separately copied the tree through tar) 174 MeB from a USB stick
to separately a 512 MeB SDcard and a 2 GiB MMC card and they
both read out correctly from an (USB) SDcard reader connected to
my PC.  Is there a specific test you have in mind?

(I finally hashed out the "DMA" problems I've had.  I mistakenly
thought that a wait_for_completion_timeout return of 0 meant
that the completion didn't happen, grr!  Buggy or just confusing
API?  Kind-of the same problem as with your scanbyte timeout!
Looks like this kind of bug is elsewhere in the kernel too.)

> or is this more at
> the level of everything working with light/early test loads,
> so it's time to see if other folk can reproduce your results?

What's the difference? :-)  (Don't forget, it's considered ok to
include experimental drivers on developer boards.)

brgds, H-P
