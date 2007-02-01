Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXBAQmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXBAQmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161193AbXBAQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:42:05 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:53258 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161187AbXBAQmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:42:04 -0500
Date: Thu, 1 Feb 2007 11:42:01 -0500
To: Michael Buesch <mb@bu3sch.de>
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201164201.GI7584@csclub.uwaterloo.ca>
References: <20070130012904.GA9617@kroah.com> <45BFC2CF.8010603@garzik.org> <20070130222344.GF7584@csclub.uwaterloo.ca> <200702011646.38762.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011646.38762.mb@bu3sch.de>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 04:46:38PM +0100, Michael Buesch wrote:
> Nah, why do you think it will screw up the eeprom?
> Did you try to completely power off the machine before rebooting
> into windows?

No at the time I don't think I powered it off, and I suspect that is
probably what went wrong.  The windows driver probably didn't like the
state of the chip after linux had poked it.

> I _really_ _really_ _really_ think that there is no chance of writing
> the eeprom by accident. It is protected by some write-enable bit in
> PCI config space. There is only one place where we enable that bit
> and where we actually _write_ to the eeprom shadow mmio space. That's
> the eeprom writing code. It will output _lots_ of kernelmessages that
> you really can't miss when that happens. And it's only called on behalf
> of a private ioctl user request. _And_ it verifies the data with a CRC
> check. So you really can't call it by accident.

Well it must have just been the state of some registers then.

> But prove me wrong and show the code that writes to eeprom. :)

I suspect I can't.  I still can't make it connect successfully to
anything yet, but that could just be a configuration problem, or it not
liking WPA encryption yet.

> Are you suggesting that bcm43xx people don't, or what?

I have just mainly seen messages about devicescape from the ralink
driver.

> Are you living on another planet than me? Mine is called "Earth".

Sometimes I might be.  At least on the days I have to deal with problems
in Windows (it's not even my machine, so I don't get to pick what it
runs all the time. :)  I haven't had particularly much luck getting a
stable wireless going on linux yet, although I haven't put much effort
into it yet either.  I figure in a couple of years there will be so many
wifi devices around that wireless won't work anymore anyhow so it isn't
a high priority.  I like simple trustworthy wires.

--
Len Sorensen
