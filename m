Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZDTUqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZDTUqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZDTUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:45:55 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:35537 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbZDTUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:45:54 -0400
Date: Mon, 20 Apr 2009 17:45:02 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420204502.GB15230@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB9758.3020506@garzik.org> <20090420173526.GA7935@ime.usp.br> <200904202231.25670.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200904202231.25670.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20 2009, Bartlomiej Zolnierkiewicz wrote:
> DISCLAIMER: I'm not handling this bugreport, this is best
> done by pata_pdc202xx_old Maintainer or libata Maintainer.

Right.

> Rogério, if the issue is reproducible you can give this patch a try...

100% reproducible at each and every boot.

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_pdc202xx_old: fix UDMA33 handling
> 
> The original driver doesn't use 66 MHz clock for UDMA33.
> 
> [ The alternative solution would be to adjust UDMA33 timings
>   for 66 MHz clock but I think that it is safer to stick with
>   old & tested behavior for now. ]

Untarring the kernel right now. Will report back in a few minutes.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
