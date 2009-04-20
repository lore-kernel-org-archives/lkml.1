Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZDTSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZDTSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZDTSkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:40:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35866 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752757AbZDTSkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:40:42 -0400
Date: Mon, 20 Apr 2009 19:40:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>
Cc: Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420194017.4edd5674@lxorguk.ukuu.org.uk>
In-Reply-To: <20090420173526.GA7935@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
	<49EB1A33.7050808@rtr.ca>
	<49EB1C9C.3000105@msgid.tls.msk.ru>
	<49EB1FB3.5000609@garzik.org>
	<20090419201132.GB2891@ime.usp.br>
	<49EB9758.3020506@garzik.org>
	<20090420173526.GA7935@ime.usp.br>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you comment on the dmesg log attached? I'd like to, at least,
> understand what is happening, since I'm starting to consider using
> libata with all my computers.

Its logging a couple of transmission errors. The CRC is computed by
hardware each end and compared (by hardware).

> This computer, in particular, uses an IDE drive with a 40 ribbon cable
> (and, thus, no UDMA/66). The cable is well put (checked two times
> already) and I believe that everything is OK with this cable, since I
> substituted it was already substituting one that gave me the same
> results.

It's tuned down to UDMA33 which looks correct.

If I saw a lot of these I'd suspect something like a controller timing
setup error, but you seem to just have occasional ones in the log which
really does look like genuine CRC errors from electrical noise or similar.

You don't happen to have any amateur radio transmitters or telsa coils in
the room with it ;) ?
