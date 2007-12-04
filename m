Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXLDTMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXLDTMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXLDTMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:12:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53910 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXLDTMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:12:44 -0500
Message-ID: <4755A6A3.5060302@garzik.org>
Date: Tue, 04 Dec 2007 14:12:35 -0500
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
> On Saturday 01 December 2007, Rafael J. Wysocki wrote:
> 
>> Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
>> Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
>> References	: http://lkml.org/lkml/2007/11/7/152
>> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9322
>> Handled-By	: Tejun Heo <htejun@gmail.com>
>> 		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Patch		: http://lkml.org/lkml/2007/11/11/115
> 
> Tejun's rework of cable detection code which fixes the problem has
> been just applied into "upstream" (not "upstream-fixes") so it is
> destined for 2.6.25 (I wasn't on cc: BTW) and since I got no feedback
> on my patch (below) which also happens to fix the regression, was
> acked by Alan, tested by Thomas and has been in -mm for 3 weeks now
> I assume that everybody is happy with it (Jeff/Tejun: you were also
> on cc: when the patch was merged into -mm)...
> 
> Linus, please apply.
> 
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

applied #upstream-fixes


