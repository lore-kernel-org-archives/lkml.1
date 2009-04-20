Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZDTUmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZDTUmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZDTUmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:42:23 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:35475 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbZDTUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:42:22 -0400
Date: Mon, 20 Apr 2009 17:41:39 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420204139.GA15230@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru> <49EB1FB3.5000609@garzik.org> <20090419201132.GB2891@ime.usp.br> <49EB9758.3020506@garzik.org> <20090420173526.GA7935@ime.usp.br> <20090420194017.4edd5674@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090420194017.4edd5674@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan. Thanks for your mail.

On Apr 20 2009, Alan Cox wrote:
> > Can you comment on the dmesg log attached? I'd like to, at least,
> > understand what is happening, since I'm starting to consider using
> > libata with all my computers.
> 
> Its logging a couple of transmission errors. The CRC is computed by
> hardware each end and compared (by hardware).

Right. I don't remember the kernel logging out errors when I was using a
custom kernel and pure Debian userland with the promise IDE controller
on this ASUS K7V motherboard (which has a VIA KT-133 chipset, not a
KT-133A).

I can try to test that again, but now I have installed Ubuntu for my
girlfriend. I have two spare IDE HDs here that I can use for testing
purposes and trash everything. If more testing is desired, please let me
know.

> > This computer, in particular, uses an IDE drive with a 40 ribbon
> > cable (and, thus, no UDMA/66). The cable is well put (checked two
> > times already) and I believe that everything is OK with this cable,
> > since I substituted it was already substituting one that gave me the
> > same results.
> 
> It's tuned down to UDMA33 which looks correct.

Yes, that looks fine, as I only have the 40 ribbon cable.

> If I saw a lot of these I'd suspect something like a controller timing
> setup error, but you seem to just have occasional ones in the log which
> really does look like genuine CRC errors from electrical noise or
> similar.

Hummm, now that you mention it, I will see if the loudspeakers installed
may have any impact on it.

> You don't happen to have any amateur radio transmitters or telsa coils in
> the room with it ;) ?

No, I don't. :-) But I do have an open embedded computer (with its own
IDE HD) at less than 10cm of this desktop and said speakers. I will try
to find any other source of electromagnetic noise.

I can try many things here to try to fix that. I want libata to not have
that experimental warning for IDE devices.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
