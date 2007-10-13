Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbXJMWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbXJMWZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbXJMWZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:25:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47912 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757044AbXJMWZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:25:10 -0400
Date: Sat, 13 Oct 2007 23:29:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 2)
Message-ID: <20071013232922.3ff6a464@the-village.bc.nu>
In-Reply-To: <200710140009.06260.bzolnier@gmail.com>
References: <200710131825.24768.bzolnier@gmail.com>
	<200710132259.53574.bzolnier@gmail.com>
	<20071013224452.71d6f61f@the-village.bc.nu>
	<200710140009.06260.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 		/* Probably a PCI interface... */
> > > 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> > > 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> > > 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;

Ok so in actual fact

- The piece of code above can't be executed anyway
- The ctrl_port argument is not needed ?

Alan
