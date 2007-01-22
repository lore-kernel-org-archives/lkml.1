Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXAVVUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXAVVUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXAVVUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:20:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51464 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932786AbXAVVUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:20:04 -0500
Date: Mon, 22 Jan 2007 21:31:09 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
Message-ID: <20070122213109.21e4e805@localhost.localdomain>
In-Reply-To: <45B51E83.1010904@ru.mvista.com>
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>
	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>
	<45B4FFBD.40507@ru.mvista.com>
	<20070122184620.1c8b87ac@localhost.localdomain>
	<45B51E83.1010904@ru.mvista.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>    Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver... 
> 
> > Thats long been broken. Should be correct in the libata driver
> 
>     Here's a surprise for you. pata_cmd64x copied the SW/MW DMA setup code 
> from the IDE driver.  No way it could be working.  You may check against the 
> PC64x datasheets (if you have them -- if you don't I think I may share) and 
> see for yourself -- it's abolutely idiotic.

Not a suprise to be honest. I fixed some of the ALi stuff when I did it
and I think that was pushed back into drivers/ide. The CMD64x hasn't had
much love really.

Wouldn't mind the older 64x (not 640) data sheets if they are sharable.

