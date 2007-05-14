Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbXENUe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbXENUe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbXENUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:34:05 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50781 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbXENUeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:34:02 -0400
Date: Mon, 14 May 2007 22:33:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <4648A3DF.7040004@imap.cc>
Message-ID: <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
 <4648A3DF.7040004@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 20:01, Tilman Schmidt wrote:
>> 
>> "Patches welcome" ;-)
>
>Sure. Just tell me exactly what those options are intended to do
>and I'll happily write up a patch adding help texts trying to
>express that in bad English. :-)

They are just a menu that can be switched on or off.
It is for those people that start with an arbitrary .config and
work their way through menuconfig to disable all the parts they
do not want. So, point no. 1:

  * Disabling this menu disables all the fluff inside it,
    without needing to enter the menu and disable each
    option one by one (as was the case previously)

Then of course, one can also turn these menuconfig on (apparently!)
to be able to descend into them and select some drivers they like.
Point no. 2:

  * Since Jens Axboe's stance ["default y idiocy"] is to have
    these menus disabled by default, people should most likely
    enable them first before they will be able to enter them.

    (I would have wanted them to be always 'y' - it does not affect
    the build, just opens all menus by default)

>Seriously, it might be a tad more efficient if the help texts were
>written by those who invented the options in the first place.

menuconfig NETDEV_10000
	bool "Ethernet (10GbE)"
	---help--
	Say Y here to actually be able to go into this menu
	and select some drivers that we think belong to the
	"10 Gigabit Ethernet" family.

	If unsure, it is unwise to say N!

See, this looks so fundamentally basic to me that I find it
almost funny. YMMV, hence I asked for suggestions from
other people.

>> As for NETDEV_1000 and _10000, I really wonder if we need anymore
>> help text than the option. I do not know what the minimum level
>> of user knowledge is that kconfig help texts need to support,
>> but maybe you can tell?
>
>For a start, it shouldn't require users to grep through Kconfigs
>and Makefiles in order to find out what effects an option has.

menuconfigs are some special kind in that they combine an option
with a menu. Perhaps now that some ->menuconfig patches have gone
in, more people will get to know these constructs.


	Jan
-- 
