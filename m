Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbXGJKco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbXGJKco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbXGJKcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:32:35 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:38650 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbXGJKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CfLNOaqR5D315nPYhlMpUAU+woByU4pzVWBj5enepGJ+UjD2J5gPklzsMup+p/g1IEpnegtLl8f4oV66solXytnU5Fz/6wN/8wnRb1v3qzmICu39hgIAkh9tXgJuvarBzTmi6SkV7glw4djVN/g6wIGWoYqKFfS0WQcTCiNCj9I=
Message-ID: <ca35ce500707100332n35661e6al22edded892fbf427@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:32:33 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707101132.50815.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <200707101057.57538.duncan.sands@math.u-psud.fr>
	 <ca35ce500707100213n10b08cc1y8b09957cd3a655d4@mail.gmail.com>
	 <200707101132.50815.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/10, Duncan Sands <duncan.sands@math.u-psud.fr>:
> On Tuesday 10 July 2007 11:13:09 mikie wrote:
> > 2007/7/10, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > > > I also tried a couple of other firmwares available on the net, and
> > > > also the one from Windows XP install (which works and achieves speeds
> > > > of up to 720kbyte/sec downlink). Some of the firmwares did not work
> > > > either, and some worked the same way - it means not more than 3mbit/s
> > > > (around 400kbyte/s) could be achieved.
> > >
> > > I'm pretty sure you won't get anything faster out of a revision 2 modem.
> >
> > Too bad to hear that :/
> > Especially that windows does this with the same modem without a hitch.
>
> Really?  In that case I take it back, the hardware can clearly do it :)  Presumably
> you are using the firmware that came with windows?  Which kernel version?  Also, what
> synchronization speed is reported?

Yes, the hardware in the modem can do it for sure. I have a laptop
with a pentium4 CPU, USB2.0, windows XP installed. I attach the same
modem to this laptop and I can go up to 730..740 kbyte/s (the same
phone line of course). Windows XP had to be modified with a registry
tweak (from thomson website) to switch to isochronous mode and it
works.

However my server running linux is on a ECS motherboard (P6BAP as I
remember), Celeron 633 CPU, USB1.1. I have compiled quite fresh kernel
2.6.21.5

I am 100% sure that I use the same firmware for the modem, because I
copied it directly from windows XP from laptop.
Now since the modem itself can go as fast as 6mbit/s, I am only
concerned if the _computer_ hardware on my linux server box can do it
via USB ? I can see the usb reporting it to be at 12Mbit/s, which
should be enough to reach 6mbit/s teoretically. CPU load is normal
even during transfers.
I would have to install windows xp on that machine to be 100% sure
that both modem and computer hardware can go up to 6mbit/s via USB...

By the way, I just tried to switch sw_buffering in the speedtch module
but that did not help.


-- 
Regards,
MK
