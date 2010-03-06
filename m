Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0CFMym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 07:54:42 -0500
Received: from solo.fdn.fr ([80.67.169.19]:44448 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0CFMyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 07:54:39 -0500
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Mar 2010 07:54:39 EST
Date: Sat, 6 Mar 2010 13:30:58 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl, linux-input@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd version)
Message-ID: <20100306123058.GE5203@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100224012010.GA4062@const> <20100225013840.GA5519@const.homenet.telecomitalia.it> <20100225102056.GG10823@core.coreip.homeip.net> <20100225214403.GB9378@const.homenet.telecomitalia.it> <20100226035448.GA16797@core.coreip.homeip.net> <20100226103505.GB3992@const.homenet.telecomitalia.it> <20100306065457.GE28759@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100306065457.GE28759@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Sat 06 Mar 2010 07:54:57 +0100, a écrit :
> > That being said, usermode tools which want to set up the modifiers and
> > connect the input LEDs to them need an easy and proper way to do so.
> > Having central input::numlock and such still seems a good thing.
> 
> This is something where I'm not too sure. Opening few files in
> sequence is not that hard to the userland so "group of leds"
> abstraction does not make too much sense...

But then userland has to monitor keyboard hotplug. At the moment,
neither kbd nor console-setup use a daemon to handle keyboards, and I
doubt their authors will be happy to have to.

Samuel
