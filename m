Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXLBWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXLBWiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXLBWiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:38:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXLBWiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:38:15 -0500
Message-ID: <475333CB.9000800@garzik.org>
Date: Sun, 02 Dec 2007 17:38:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: Re: 2.6.24-rc3-git6: Reported regressions from 2.6.23
References: <200712012312.42136.rjw@sisk.pl> <200712020347.01769.bzolnier@gmail.com>
In-Reply-To: <200712020347.01769.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> [PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings
> 
> * Don't program UDMA timings when programming PIO or MWDMA modes.
> 
>   This has also a nice side-effect of fixing regression added by commit
>   681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
>   SRST reset sequences") (->set_piomode method for PIO0 is called before
>   ->cable_detect method which checks UDMA timings to get the cable type).
> 
> * Bump driver version.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Tested-by: "Thomas Lindroth" <thomas.lindroth@gmail.com>
> Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


I'll add this to the queue.  Sorry for missing it.

	Jeff


