Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZADMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZADMEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZADMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:04:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33227 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751066AbZADMEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:04:10 -0500
Date: Sun, 4 Jan 2009 12:04:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090104120415.33e32c6b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0901031854320.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
	<20090102102152.GA26603@rhlx01.hs-esslingen.de>
	<20090102172407.GD1555@ucw.cz>
	<alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
	<20090103204329.GD1666@elf.ucw.cz>
	<20090103204535.1a91cbcb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0901031306150.3179@localhost.localdomain>
	<20090103231013.3591d027@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0901031854320.3179@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't believe "auto-destroy my music collection" is a sane default...
> 
> You are missing the point.

Nope.

> You have one totally made-up example of something that may happen as a 
> result of a default I didn't even advocate (but you didn't read my email). 

Actually I went and verified the behaviour of the iRiver iHP20.

> There really was nothing theoretical in my issue. On a certain class of 
> hardware, you absolutely _have_ to make your /home or / partition be 
> behind a USB thing, because nothing else has enough space on it.

Yes clearly.

> And your made-up example wouldn't even trigger if we just made a per-mount 

What made up example ?

> decision to mark devices persistent.

The distribution question is 'how do you make that decision reliably and
correctly ?'. That is closely followed by 'what state should it end up in
if the relevant scripts don't run for some reason ?' - which is clearly
"not persistent" for safety reasons.

> So why are you arguing?

I'm not aware I was. I was simply pointing out that

- the general distribution default cannot be one that harms user data on
music players
- that you can fix it more elegantly by quiescing and validating file
systems across a suspend/resume

neither of which appears to disagree with the point that you want USB (or
increasingly SD card) to be able to autoresume when it holds file
systems. It does however make clear which way around any kernel default
should be.

Alan
