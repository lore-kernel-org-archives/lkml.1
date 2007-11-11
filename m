Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbXKKUKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbXKKUKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXKKUJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:09:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48764 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbXKKUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:09:58 -0500
Date: Sun, 11 Nov 2007 20:09:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Message-ID: <20071111200935.1384c24d@the-village.bc.nu>
In-Reply-To: <200711112058.28043.rjw@sisk.pl>
References: <200711112058.28043.rjw@sisk.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject		: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> References	: http://marc.info/?l=linux-kernel&m=119342005216716&w=2
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9252
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Patch		: 
> Note		: pata_acpi was not present in 2.6.23

As I said before pata_acpi was not present in 2.6.23 -> Not a regression.
WONTFIX for 2.6.24. Not actually clear it is even a bug, the interactions
between using pata_acpi and simplex controllers are not documented
anywhere 8(

> Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
> Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
> References	: http://lkml.org/lkml/2007/11/7/152
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9322

Tejun is looking into this - its not trivial so may be 2.6.25 material.
Similar reports for some other controllers (notably VIA).

> Subject		: cd/dvd inaccessible in 2.6.24-rc2
> Submitter	: Will Trives <will@trivescon.com.au>
> References	: http://lkml.org/lkml/2007/11/9/290
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 		  Jeff Garzik <jeff@garzik.org>

Not sure who is handling this now - seems to be an IRQ routing bug
introduced in -rc2. I've got a pile of similar breakage reports for
random ATA controllers.

Thanks

Alan
