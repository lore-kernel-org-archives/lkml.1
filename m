Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZADDAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZADDAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZADC75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:59:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbZADC74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:59:56 -0500
Date: Sat, 3 Jan 2009 18:59:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
In-Reply-To: <20090103231013.3591d027@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0901031854320.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz> <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain> <20090103204329.GD1666@elf.ucw.cz>
 <20090103204535.1a91cbcb@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0901031306150.3179@localhost.localdomain> <20090103231013.3591d027@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Alan Cox wrote:
> 
> I don't believe "auto-destroy my music collection" is a sane default...

You are missing the point.

You have one totally made-up example of something that may happen as a 
result of a default I didn't even advocate (but you didn't read my email). 

And you use that as an argument against another case that wasn't even made 
up, but a real issue where suspend simply didn't work, because the /home 
partition no longer worked afterwards.

There really was nothing theoretical in my issue. On a certain class of 
hardware, you absolutely _have_ to make your /home or / partition be 
behind a USB thing, because nothing else has enough space on it.

And your made-up example wouldn't even trigger if we just made a per-mount 
decision to mark devices persistent.

So why are you arguing? 

			Linus
