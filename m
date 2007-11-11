Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXKKWri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXKKWri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbXKKWra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:47:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33488 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755701AbXKKWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:47:29 -0500
Date: Sun, 11 Nov 2007 22:46:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Thomas Lindroth" <thomas.lindroth@gmail.com>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Message-ID: <20071111224643.312f8279@the-village.bc.nu>
In-Reply-To: <200711112322.15537.bzolnier@gmail.com>
References: <200711112058.28043.rjw@sisk.pl>
	<20071111200935.1384c24d@the-village.bc.nu>
	<200711112322.15537.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings
> 
> * Don't program UDMA timings when programming PIO or MWDMA modes.
> 
>   This has also a nice side-effect of fixing regression added by commit
>   681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
>   SRST reset sequences") (->set_piomode method for PIO0 is called before
>   ->cable_detect method which checks UDMA timings to get the cable type).

I'm not sure this helps as if the ACPI _GTF method is looking at the
flags and stuff but it has to be worth a try.


Works for me as a 2.6.24 band aid
