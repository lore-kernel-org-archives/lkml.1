Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZJVMOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZJVMOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZJVMOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:14:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43768 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbZJVMOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:14:42 -0400
Date: Thu, 22 Oct 2009 12:29:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091022102937.GA3981@ucw.cz>
References: <20091016130315.GT28832@buzzloop.caiaq.de> <1255863412.27878.136.camel@ted> <20091019071621.GZ28832@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019071621.GZ28832@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > for a project I was working on, we used the J15 connector of the ALIX.2D
> > > board (which is connected to a GPIO of the CS5536 Geode companion chip)
> > > for an external button switch.
...
> Hmm, hard to say. One can either use that IO as output to control a
> buzzer (which isn't placed on the board, but there are solder pads for
> it), as output for other purpose or as input.
> 
> Don't know what other people use it for, though, but we needed an
> external button in our case and use this IO pin for that purpose.
> 
> Anyway - I don't insist in that patch to be taken. The idea was more to
> share it so others won't have to hack the same thing.

So its gpio pin... if you teach gpio framework about it, you should be
able to just use gpio_button driver to handle it, no?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
