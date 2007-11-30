Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbXK3Pot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbXK3Pot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXK3Pog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:44:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51279 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756364AbXK3Pof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:44:35 -0500
Date: Fri, 30 Nov 2007 15:40:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: msar2020@gmail.com (Michael Robb)
Cc: dsterba@suse.cz, jeff@garzik.org, akpm@linux-foundation.org,
       benm@symmetric.co.nz, jkosina@suse.cz, jslaby@suse.cz,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Message-ID: <20071130154023.26b3c61b@the-village.bc.nu>
In-Reply-To: <20071130152019.C689B19E20E@silentrunning.homelinux.org>
References: <20071130152019.C689B19E20E@silentrunning.homelinux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 15:20:19 +0000 (GMT)
msar2020@gmail.com (Michael Robb) wrote:

> >If the -main- purpose of the hardware is wireless, it should go in via
> >John Linville, wireless maintainer...
> 
> These GPRS cards are basically wireless modems which accept a Hayes command
> set (AT+????, etc...), can send and receive SMS messages, as well as 
> support WAP and PPP internet surfing.
> 
> Hayes commands allow for measuring local signal strength (AT+CSQ), reading
> and writing SMS messages (AT+CMGF, AT+CMGW, AT+CNMI) etc...
> 
> So, it is somewhere between a serial driver and a wireless driver.

At the moment they seem to be ending up under serial, so I would prefer
consistency between the USB tty interfaces for 3G cards, the stuff like
Nozomi and any newer goodies. The new tty layer buffering is quite happy
at these speeds.
