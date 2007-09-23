Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXIWOEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXIWOEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 10:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXIWOEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 10:04:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41310 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756AbXIWOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 10:04:39 -0400
Date: Sun, 23 Sep 2007 15:11:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Message-ID: <20070923151105.5d491df4@the-village.bc.nu>
In-Reply-To: <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
References: <20070921085711.GG2367@kernel.dk>
	<64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sep 18 18:50:01 treogen [   63.440000] ata1.00: status: {DRDY }
> Sep 18 18:50:01 treogen [   63.440000] ata1: hard resetting link

Timed out waiting for data transfers to complete that didn't. Does sound
like the device got told the wrong sized transfer.


It then falls off the bus because Jeff hasn't merged Mark Lord's DRQ
draining patch.

Alan
