Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbXKKUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbXKKUDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXKKUDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:03:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54094 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756145AbXKKUDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:03:14 -0500
Date: Sun, 11 Nov 2007 20:02:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi
 M5229 secondary channel
Message-ID: <20071111200236.4cece127@the-village.bc.nu>
In-Reply-To: <200711112223.13542.arvidjaar@mail.ru>
References: <200710262130.03567.arvidjaar@mail.ru>
	<20071026202559.01161aa9@the-village.bc.nu>
	<200711112223.13542.arvidjaar@mail.ru>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW in rc2 it does not even boot - it babbles something about
> Unable to determine IRQ for 00:04.0  (which is IDE controller) and that is
> the end of story. No IDE device is found.

Thats not an IDE breakage I suspect. Various people are reporting IRQ
related breakage with -rc2 so you should probably report that to the main
linux-kernel list

Doesn't explain the ALi DMA problem but I think its unrelated

Alan
