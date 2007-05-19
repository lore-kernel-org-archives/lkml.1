Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXESXSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXESXSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbXESXRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:17:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6660 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbXESXRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MbUwKWQ+JruOkPAu0FtuWlU1yY+UA5CMugJzUFAbM6+pVjahYSVHAIvrWj1FkmBmnxkySvF0qe88sBs0jMtI9AMdfEGe8gzOAzdbMMuFOhSr5sAn6Yny0JFm4DYABeS6e/wmpbTH/i0S94tpI5Qfz1H7xrLvQ9xUkW57gLh8piA=
Message-ID: <a781481a0705191617v901ac64nfa7040ff302d2da1@mail.gmail.com>
Date: Sun, 20 May 2007 04:47:52 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>
In-Reply-To: <20070519230940.GJ6291@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <20070519230940.GJ6291@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, May 20, 2007 at 04:19:12AM +0530, Satyam Sharma wrote:
> >...
> > A combined patch for all of those on top of 22-rc2 (adding Signed-off-by's
> > for original authors too):
> >...
> > --- a/arch/m68k/Kconfig       2007-05-20 04:11:47.000000000 +0530
> > +++ b/arch/m68k/Kconfig       2007-05-20 04:23:57.000000000 +0530
> > @@ -411,6 +411,7 @@ config STRAM_PROC
> >
> > config ATARI_KBD_CORE
> >       bool
> > +     default y if KEYBOARD_ATARI || MOUSE_ATARI
> >...
> > --- a/drivers/input/keyboard/Kconfig  2007-05-20 04:11:55.000000000 +0530
> > +++ b/drivers/input/keyboard/Kconfig  2007-05-20 04:24:54.000000000 +0530
> > @@ -167,7 +167,6 @@ config KEYBOARD_AMIGA
> > config KEYBOARD_ATARI
> >       tristate "Atari keyboard"
> >       depends on ATARI
> > -     select ATARI_KBD_CORE
> >       help
> >         Say Y here if you are running Linux on any Atari and have a keyboard
> >         attached.
> > diff -ruNp a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> > --- a/drivers/input/mouse/Kconfig     2007-05-20 04:11:55.000000000 +0530
> > +++ b/drivers/input/mouse/Kconfig     2007-05-20 04:25:09.000000000 +0530
> > @@ -179,7 +179,6 @@ config MOUSE_AMIGA
> > config MOUSE_ATARI
> >       tristate "Atari mouse"
> >       depends on ATARI
> > -     select ATARI_KBD_CORE
> >       help
> >         Say Y here if you have an Atari and want its native mouse
> >         supported by the kernel.
> >...
>
> This is a good example how "fixing" the warnings makes things worse...

How?
