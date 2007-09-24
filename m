Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbXIXAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbXIXAIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXIXAIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 20:08:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:56178 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbXIXAIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 20:08:10 -0400
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Mihai Dontu <mihai.dontu@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <E1IZZ37-0001OI-8g@flower>
References: <200709220828.00078.mihai.dontu@gmail.com>
	 <200709232131.02348.mihai.dontu@gmail.com> <200709232118.09884.rjw@sisk.pl>
	 <200709232222.29066.mihai.dontu@gmail.com>  <E1IZZ37-0001OI-8g@flower>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 10:07:58 +1000
Message-Id: <1190592478.6886.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-09-23 at 23:31 +0200, Oleg Verych wrote:
> * Sun, 23 Sep 2007 22:22:28 +0300
> * Organization: Home
> 
> []
> >> > 
> >> >   So there, if one wants "ATI Radeon display support" on Radeon XPRESS 200M with
> >> >   X using radeon_drv.so, *should* put "Framebuffer Console support" to N (if it's
> >> >   not already).
> []
> >   Bottom line: no radeonfb for me :( at least, not now; but I have to be honest with
> >   you: I don't see what commit dd1447134454b169d5ae353aceb93f2368db8547 brought new
> >   into the picture. The previous radeonfb worked just great, but then, again, maybe I'm
> >   not using the console at it's full power :)
> 
> In fact, it's known statement, that there must only one hardware driver
> for graphic adapter. Be it framebuffer with X fb driver on it or legacy
> VGA text and X with its driver.so and 3D stuff.
> 
> (i choose legacy text without X for the most of my time, though :)

Not quite ... on PowerMacs, we've been routinely using radeonfb and X
together. However, for that to work, in general, one has to be careful
to switch back to console mode before suspending and back to X after
resume, which seems to have been broken by many distro lately, probably
because somebody made it optional in the kernel...

Ben.


