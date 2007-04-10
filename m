Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXDJWVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXDJWVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXDJWVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:21:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60314 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030400AbXDJWVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:21:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461C0DD0.5040805@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 00:21:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Ben Collins <bcollins@debian.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Use menuconfigs instead of menus, so the whole menu can be disabled at        
> once instead of going through all options.

If you excuse the nitpicking:  The patch description is not very
precise.  You don't have to go through all options in the IEEE 1394 menu
if you don't need them.  Once the first entry in the menu is disabled,
all other options vanish.  (Of course with your patch you don't have to
enter the submenu in the first place if you switch it off.)  I suppose
it's the same with some more of the menus you edited.

But even though, keeping such groups of options in a menu _without_ the
possibility to switch the menu off helps to focus on these options.
Less clutter in the display one is working with in a moment.  IMO,
kernel configuration is not a sport where speed matters but a task where
we want to present the user a very cleaned-up, calm display.

In general though, I'm impartial on this kind of change.

> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> Index: linux-2.6.21-rc5/drivers/ieee1394/Kconfig
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/ieee1394/Kconfig
> +++ linux-2.6.21-rc5/drivers/ieee1394/Kconfig
> @@ -1,8 +1,6 @@
>  # -*- shell-script -*-
>  
> -menu "IEEE 1394 (FireWire) support"
> -
> -config IEEE1394
> +menuconfig IEEE1394
>  	tristate "IEEE 1394 (FireWire) support"
>  	depends on PCI || BROKEN
>  	select NET
> @@ -19,12 +17,12 @@ config IEEE1394

[...]

For the readers of linux1394-devel:

Jan Engelhardt wrote at lkml:
Subject: [PATCH 0/30] Use menuconfig objects
> Hello list,
>
>
> the following patch series turns some menus into menuconfigs, so they
> can be disabled whilst "walking" thorugh the parent menu (check the
> videos [1], [2] to see what I mean), enabling for disabling lots of
> options _quickly_.
>
> I'll send the patches (as a reply to this mail) piece by piece out
> when I figure out the maintainers to Cc for each.
>
> [1] 6.04 MB(1000s) 70 sec http://jengelh.hopto.org/mc/without.ogg
> [2] 1.96 MB(1000s) 44 sec http://jengelh.hopto.org/mc/with.ogg
> (Ogg container, Theora Video, no audio)
>
> I have not poked on all subsystems (it is quite a lot), but I can
> already give a glimpse (`ls -1`) of who gets one and who does not.
> And, I am not completely finished changing some subsystems - but
> the patches are already big enough for a first wave. I want to get
> some feedback first. Thanks!
>


-- 
Stefan Richter
-=====-=-=== -=-- -=-==
http://arcgraph.de/sr/
