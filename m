Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXFXUvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXFXUvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXFXUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:51:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49097 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbXFXUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:51:30 -0400
Date: Sun, 24 Jun 2007 21:57:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomasz =?UTF-8?B?S8WCb2N6a28=?= <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070624215724.025a5de5@the-village.bc.nu>
In-Reply-To: <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	<20070624200837.16e11305@the-village.bc.nu>
	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sory Alan but I don't want philosophical/historical discuss.
> Try to answer on question "ALSA or OSS ?" using *only* technical arguments.

We dropped OSS for ALSA for technical reasons. Those being that ALSA
- has a better audio API
- is more flexible
- provides OSS as emulation
- supports more hardware

I used to maintain the kernel OSS code (the fork when Hannu and friends
took their project non-free). I did the work to make the sound layer
modular when the vendors realises that the open one needed to be modular
and that since that was the main play of the non-free one that Hannu
wasn't going to be doing it. From a technical perspective ALSA is the
better design especially for flexible devices.

At the desktop level these days it doesn't really matter much, the
desktops use their own sound servers which sit on top of OSS, ALSA and
other sound systems.

Alan
 
