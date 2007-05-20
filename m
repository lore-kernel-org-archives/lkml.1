Return-Path: <linux-kernel-owner+w=401wt.eu-S1762769AbXETAxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769AbXETAxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXETAx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:53:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21016 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbXETAx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kcZuF8I6Zu4CwN+VpWFqDDYQrNKuwPeNGPjclxTDNT5mawLBkTeB/HBwYaHcBEQoj7UswIwN35Kt5ID5zbGhz028rvJfaEvRX/mAUrqQc3U1R14slars4apXuBGjReQyYOG4l9jGn3ndIjWnlWFauHzrRu6LjfkwTB8WTorFdFg=
Message-ID: <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
Date: Sun, 20 May 2007 06:23:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <464F9A7B.1030708@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <464F9A7B.1030708@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > A combined patch for all of those on top of 22-rc2 (adding Signed-off-by's
> > for original authors too):
> >
> > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>
> [...]
>
> > diff -ruNp a/drivers/input/keyboard/Kconfig
> > b/drivers/input/keyboard/Kconfig
> > --- a/drivers/input/keyboard/Kconfig    2007-05-20 04:11:55.000000000 +0530
> > +++ b/drivers/input/keyboard/Kconfig    2007-05-20 04:24:54.000000000 +0530
> > @@ -167,7 +167,6 @@ config KEYBOARD_AMIGA
> > config KEYBOARD_ATARI
> >     tristate "Atari keyboard"
> >     depends on ATARI
> > -    select ATARI_KBD_CORE
> >     help
> >       Say Y here if you are running Linux on any Atari and have a keyboard
> >       attached.
> > diff -ruNp a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> > --- a/drivers/input/mouse/Kconfig    2007-05-20 04:11:55.000000000 +0530
> > +++ b/drivers/input/mouse/Kconfig    2007-05-20 04:25:09.000000000 +0530
> > @@ -179,7 +179,6 @@ config MOUSE_AMIGA
> > config MOUSE_ATARI
> >     tristate "Atari mouse"
> >     depends on ATARI
> > -    select ATARI_KBD_CORE
> >     help
> >       Say Y here if you have an Atari and want its native mouse
> >       supported by the kernel.
> > diff -ruNp a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
> > --- a/drivers/macintosh/Kconfig    2007-05-20 04:11:55.000000000 +0530
> > +++ b/drivers/macintosh/Kconfig    2007-05-20 04:18:57.000000000 +0530
> > @@ -113,7 +113,6 @@ config PMAC_SMU
> >
> > config PMAC_APM_EMU
> >     tristate "APM emulation"
> > -    select SYS_SUPPORTS_APM_EMULATION
> >     select APM_EMULATION
> >     depends on ADB_PMU && PM
> >
> > diff -ruNp a/drivers/net/Kconfig b/drivers/net/Kconfig
> > --- a/drivers/net/Kconfig    2007-05-20 04:11:56.000000000 +0530
> > +++ b/drivers/net/Kconfig    2007-05-20 04:22:15.000000000 +0530
> > @@ -2280,7 +2280,6 @@ config GFAR_NAPI
> > config UCC_GETH
> >     tristate "Freescale QE Gigabit Ethernet"
> >     depends on QUICC_ENGINE
> > -    select UCC_FAST
> >     help
> >       This driver supports the Gigabit Ethernet mode of the QUICC Engine,
> >       which is available on some Freescale SOCs.
>
> Adrian already commented on this.  Let me just add that these above
> changes are in so far *totally wrong* as they remove the "depends on
> XYZ" which is implied by "select XYZ".

Did you even try this patch?

Did you try to select UCC_GETH and see if UCC_FAST got
automatically selected or not?

Did you get any build problems (or bogus warnings, for that matter)?

Have you ever looked into arch/.../Kconfig's?

> Remember, "select" is like "depends on", just with the added twist that
> the 'make snafuconfig' scripts are instructed to (a) not hide the
> depending option from the user and (b) try to enable the dependency for
> the user if he tries to enable the depending option.

This is precisely what happens with this patch too.

Believe me, just go ahead and try it.

Report any errors, dissatisfaction, etc, if any.

Thanks.
