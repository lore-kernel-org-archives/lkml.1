Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYAHT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYAHT0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYAHT0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:26:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46536 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754318AbYAHT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:26:16 -0500
Date: Tue, 8 Jan 2008 19:23:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080108192313.1c2d222a@lxorguk.ukuu.org.uk>
In-Reply-To: <4783CBD9.7020709@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
	<4783CBD9.7020709@reed.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As well you should. I am honestly curious (for my own satisfaction) as 
> to what the natsemi docs say the delay code should do  (can't imagine 
> they say "use io port 80 because it is unused").  I don't have any 

They say you must allow 4 bus clocks for the address decode. They don't
deal with the ISA side as the chip itself has no ISA glue.


> copies anymore. But mere curiosity on my part is not worth spending a 
> lot of time on - I know you are super busy.   If there's a copy online 
> at a URL ...

Not that I know of. There may be. A good general source of info is Russ
Nelson's old DOS packet driver collection.

