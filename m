Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbXE1TSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbXE1TSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXE1TRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:17:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49822 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452AbXE1TRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:17:54 -0400
Date: Mon, 28 May 2007 20:22:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Message-ID: <20070528202254.67eabe73@the-village.bc.nu>
In-Reply-To: <m31wh18eel.fsf@ursa.amorsen.dk>
References: <200705261505.38109@gj-laptop>
	<200705261746.01568@gj-laptop>
	<2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>
	<200705271222.30169@gj-laptop>
	<20070527130228.3731ff4d@the-village.bc.nu>
	<m31wh18eel.fsf@ursa.amorsen.dk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> That's a big if right there. For servers it isn't a problem, few
> people can get capacity right to withing 10%, so you never let a
> server run full. Desktops/laptops on the other hand spend most of
> their lives between 80% and 100%.

Modern desktop patterns are very different to older ones - the disk fill
is almost entirely continuous writes of large files (OGG, MP3, Movies
etc). In addition the default ext3 behaviour reserves the last part of
the disk for root - so usually it doesn't get below 5% free as only root
can steal that space.

Back when you had a 40MB /home the usage tended to be multiple parallel
writers, permanently at 90%+ (with a "please remove unused files" motd).

Alan
