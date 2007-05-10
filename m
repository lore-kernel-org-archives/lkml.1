Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbXEJQPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbXEJQPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXEJQPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:15:09 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:32823 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXEJQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:15:08 -0400
Date: Thu, 10 May 2007 12:14:46 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Bodo Eggert <7eggert@gmx.de>, Albert Cahalan <acahalan@gmail.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: Long file names in VFAT broken with iocharset=utf8
In-Reply-To: <Pine.LNX.4.61.0705101654480.24536@yvahk01.tjqt.qr>
Message-ID: <alpine.DEB.0.98.0705101209130.8169@sigma.j-a-k-j.com>
References: <8ipOe-5KI-3@gated-at.bofh.it> <8ityz-2Xz-31@gated-at.bofh.it>
 <8iWqS-5Ba-15@gated-at.bofh.it> <8iWKp-619-29@gated-at.bofh.it>
 <8j4eK-QR-13@gated-at.bofh.it> <E1Hm9xo-0000vV-Po@be1.lrz>
 <Pine.LNX.4.61.0705101654480.24536@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Just because you limit yourself to 80 chars minus "ls -l"-clutter, this is
> >no reason why I shouldn't use long filenames. If I need to handle these
> >filenames, I can enlarge the terminal window or read the next line.
> >
> >E.g.: I have a music file named "artist - title.ext", where the artist
> >name is 103 characters long, using abbreviations. In order to enter that
> >name, I have to press seven keys, including the escape character.
> >There is nothing unreasonable in using that name.
> 
> What name would that be? I cannot dream up any IME that outputs _that_
> many characters for that few keystrokes. Even with CJ(K), 7 keystrokes can
> make at most 21 bytes if I had to take a good guess.

Probably talking about tab-completion in the shell, countering the comment 
that names that long are too unwieldy to use.

On the other hand, limits are always bad. Haven't we seen bajillions of 
cases in computing history where we start with limits (like only N of the 
first characters of identifiers used in compilers), followed by people 
finding those limits annoying, then followed by the limits being removed? 
How about the Year-20?? limitations? Same thing: limits that were fine, 
then limits were not fine, then limits were removed.

In this era, couldn't we just skip the whole thing and stop putting limits 
in from the beginning? The only reason to have a PATH_MAX/NAME_MAX at all 
is to make life easier for programmers implementing things and people 
using things. It would require a LOT of work and changes, but life would 
be so much better if there were a (configurable, of course!) option to say 
"use standard values" or "use custom values" or "use runtime-dynamic 
values". Option 1: No change. Option 2: Alter your limits.h too, and 
recompile programs (or fix them). Option 3: Change programs from 
compile-time inclusion of limits.h to run-time checking of a /sys value.
