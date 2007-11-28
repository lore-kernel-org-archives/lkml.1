Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXK1THl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXK1THl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbXK1THc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:07:32 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:65398 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755245AbXK1THb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:07:31 -0500
Date: Wed, 28 Nov 2007 20:07:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128200729.121dd793@hyperion.delvare>
In-Reply-To: <20071128183720.GB697@xi.wantstofly.org>
References: <20071024162528.GX30533@stusta.de>
	<20071024164347.GN4003@csclub.uwaterloo.ca>
	<20071128112357.3828d469@hyperion.delvare>
	<20071128183720.GB697@xi.wantstofly.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 19:37:20 +0100, Lennert Buytenhek wrote:
> On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:
> (...)
> > As far as I can see, the ixp2000 platform also doesn't implement the
> > standard GPIO API yet, so of the 3 drivers that are about to be
> > removed, only i2c-ixp4xx can be removed without functionality loss at
> > the moment. Lennert, Russell, are there any plans to convert the
> > ixp2000 platform to use the generic GPIO layer?
> 
> No plans at this point from my side.
> 
> I'm not entirely sold on the GPIO API, but nevertheless I expect
> that ixp2000 will be converted sooner rather than later.
> 
> If you don't want people to use i2c-ixp2000 as an example for new
> code, maybe you can stick in a comment at the top of the file that
> says that what i2c-ixp2000 does isn't the Preferred(TM) way of doing
> it?

The driver is tagged DEPRECATED in Kconfig, that should be enough. Not
to mention that any new i2c bus driver has to go through me so I'd
intercept the offender anyway.

> (...)
> Sorry, I seem to have missed the addition of i2c-ixp2000 to
> feature-removal-schedule.txt.  I would have spoken up earlier if I
> had been aware of it being in there.
> 
> It seems odd to me to advocate removal of something which works fine
> and for which no functional replacement is available just because it
> doesn't conform to the Latest And Greatest API(TM).  That's like
> suggesting that Jan 1st 2009 we should rm -f all .c files that still
> reference the big kernel lock, or rm -f all ARM ports that don't
> use the clocksource/clockevent mechanism yet (which includes
> ixp2000 as well.)
> 
> Let's just remove i2c-ixp2000 when the GPIO API conversion happens, ok?

That's the plan, yes.

-- 
Jean Delvare
