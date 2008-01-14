Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYANKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYANKYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYANKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:24:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754015AbYANKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:23:59 -0500
Date: Mon, 14 Jan 2008 10:21:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
 won't drain
Message-ID: <20080114102108.1e2aaa89@lxorguk.ukuu.org.uk>
In-Reply-To: <20080114093525.GA22818@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk>
	<20080108115703.GA27179@flint.arm.linux.org.uk>
	<20080111101721.GA4463@ucw.cz>
	<20080114002912.GA19195@flint.arm.linux.org.uk>
	<20080114090459.GB4024@elf.ucw.cz>
	<20080114093525.GA22818@flint.arm.linux.org.uk>
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

> - what if its a port with 256 characters in the FIFO, and its programmed
>   for 110 baud?
> - what if loopback isn't supported?
> - what if, while doing this operation, the remote end is sending characters
>   because you can't deassert RTS?

More importantly it is unlikely that serial state will or should survive
across a suspend/resume cycle this way. The chances are you modem did not
suspend and resume the phone call.

Alan
