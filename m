Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZJSHQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZJSHQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZJSHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:16:23 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:59005 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZJSHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:16:22 -0400
Date: Mon, 19 Oct 2009 09:16:21 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091019071621.GZ28832@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
 <1255863412.27878.136.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255863412.27878.136.camel@ted>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 11:56:52AM +0100, Richard Purdie wrote:
> On Fri, 2009-10-16 at 15:03 +0200, Daniel Mack wrote:
> > for a project I was working on, we used the J15 connector of the ALIX.2D
> > board (which is connected to a GPIO of the CS5536 Geode companion chip)
> > for an external button switch.
> > 
> > I thought it might be worth sharing this piece of code, so others can do
> > the same.
> > 
> > There is, however, a small hardware modification is necessary as the pin
> > is also shared as buzzer output. I noted that in the Kconfig entry.
> > 
> > The patch should go thru Richard's led-2.6.git as it depends on another
> > one that has been queued there already.
> 
> How common is this modification? I'm just trying to get a feel for the
> number of users out there of this feature...

Hmm, hard to say. One can either use that IO as output to control a
buzzer (which isn't placed on the board, but there are solder pads for
it), as output for other purpose or as input.

Don't know what other people use it for, though, but we needed an
external button in our case and use this IO pin for that purpose.

Anyway - I don't insist in that patch to be taken. The idea was more to
share it so others won't have to hack the same thing.

I'll still submit a new version with Dmitry's suggestions addressed.

Thanks,
Daniel
