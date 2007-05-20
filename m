Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbXETAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbXETAC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764158AbXETACu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:02:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38961 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755763AbXETACt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:02:49 -0400
Date: Sun, 20 May 2007 02:02:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520000235.GP6291@stusta.de>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <20070519230537.GI6291@stusta.de> <20070519162239.1bcb03d6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070519162239.1bcb03d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 04:22:39PM -0700, Andrew Morton wrote:
> On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Look for example at the last one in drivers/input/mouse/Kconfig:
> > 
> > config MOUSE_ATARI
> >         tristate "Atari mouse"
> >         depends on ATARI
> >         select ATARI_KBD_CORE
> > 
> > This is perfectly correct (the select'ed symbol is only unavailable when 
> > the dependency can't be fulfilled), and all things to "fix" the warning 
> > will make it worse.
> 
> If ATARI is unset then we shouldn't be generating the "'select' used by
> config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
> warnings, should we?

Exactly.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

