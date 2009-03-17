Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZCQJAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZCQJAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZCQJAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:00:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZCQJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:00:33 -0400
Date: Tue, 17 Mar 2009 10:03:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: luoyi <luoyi.ly@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: w35und driver unusable
Message-ID: <20090317090322.GA24133@elf.ucw.cz>
References: <e9e614960903162141g2f272f82jee434fc6fc748544@mail.gmail.com> <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > http://ubuntuforums.org/showthread.php?t=664458
> >
> > I know that the my box's wifi is WinBound's products.
> >
> > I'm currently running kernel 2.6.28.7 now and have modprobed w35und.
> > and I also have a linksys usb wireless card on the USB port.
> >
> > Now, the situation is Linksys's card can just work well. and the
> > Winbound card can't .
> >
> > wlan1 is the WinBound card:
> >
> > root@t700:~# dmesg |grep wlan1
> > udev: renamed network interface wlan0 to wlan1
> > ADDRCONF(NETDEV_UP): wlan1: link is not ready
> >
> > root@t700:~# iwlist wlan1 scan
> > wlan1     No scan results
> >
> > root@t700:~# iwlist wlan0 scan
> > wlan0     Scan completed :
> >         Cell 01 - Address: 00:1B:FC:7E:57:51
> >                   ESSID:"default"
> >                   Mode:Master
> >                   Channel:5
> >                   Frequency:2.432 GHz (Channel 5)
> >                   Quality=56/100  Signal level:-22 dBm
> >                   Encryption key:off
> >                   IE: Unknown: 000764656661756C74
> >                   IE: Unknown: 010882848B968C929824
> >                   IE: Unknown: 030105
> >                   IE: Unknown: 0406000200000000
> >                   IE: Unknown: 2A0100
> >                   IE: Unknown: 3204B048606C
> >                   Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
> >                             9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
> >                             48 Mb/s; 54 Mb/s
> >                   Extra:tsf=00000035772ec17e
> >                   Extra: Last beacon: 52ms ago
> >
> > does this mean that the winbound drivers in the kernel tree is not
> > ready for use ? or do we have any idea for make it work ?

> The driver is known to be broken in 2.6.28. You might want to try out
> 2.6.29-rc8 which carries fixes for the driver. Note that the driver is
> in the staging directory which means it is not of production quality.

Winbond driver only supports channel 1, for now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
