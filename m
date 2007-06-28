Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbXF1QZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbXF1QZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXF1QY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:24:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44154 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760042AbXF1QYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:24:55 -0400
Date: Thu, 28 Jun 2007 17:30:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: William D Waddington <william.waddington@beezmo.com>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070628173051.4a3422c0@the-village.bc.nu>
In-Reply-To: <4683D3B0.1040708@beezmo.com>
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>
	<oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>
	<4683983E.5020103@aitel.hist.no>
	<4683D3B0.1040708@beezmo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Fair enough:
> http://www.tahomatech.com/downloads/drivers/linux_2.6/pci/x86/compressed_tarfiles/
> or for your browsing pleasure:
> http://www.tahomatech.com/downloads/drivers/linux_2.6/pci/x86/files/
> 
> But I really don't see much hope :(  Coding style, masses of ioctls,
> build and install technique,  limited user base, etc, etc, etc...  Most
> of the above to keep API compatibility with other OS/older drivers -
> back to SunOS 4.1.3.  (BTW, it does seem to work...)

Its small, its relatively sanely structured and its not that bad
stylewise. Nothing a few seds, an indent and a polish wouldn't cure. As
to the ioctls - its a specialised driver for specialised purposes so the
ioctls are not IMHO an issue beyond worrying about compat_ and if you
want compat_ interfaces for them or not.

> And I probably have the license wrong.  The code has always been in
> the public domain.  (Advice welcome...)

Public domain is GPL compatible. 

> My (mild) beef is more like what I take to be Al's point: it feels like
> there is a kind of hostility toward out-of-tree maintainers.  Why not

Some of that comes about because a lot of them are out of tree
maintaining non-free stuff, shipping binary products - often entirely
binary without a Linux or GPL label - until the man in black catches them
and sues them in Germany.

> encourage _all_ of us who are beavering away at open-source code?  My
> stuff doesn't belong in mainline, but it _is_ open, and in some minor
> way allows more folks to run Linux.

Quite honestly your stuff is *less* obscure than some of the hardware we
have in-tree drivers for, and rather cleaner.

> A cleaned-up, consistent, and out-of-tree friendly way of handling API
> changes might help us all.

The problem is that its very impractical. If I change a kernel API I fix
up the in tree users and test those I can, that's "accepted practice" -
you make mess doing a job you clean it up. I can't do that for out of
tree code because its out of tree.
