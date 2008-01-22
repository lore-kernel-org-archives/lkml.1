Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbYAVBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbYAVBNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYAVBNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:13:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:2447 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYAVBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YtgsaUOjCePOqNunB2gKLd5YMgiwkSDLo5i1G1Shj0ZeROQpmNt1R4rGcio6b9s9EPdU3jJkniy1frtBXzDuf2r/OHhpZ34goAIdKJ0l/Omfd+ju0WbFKdWJWV4JAyfydmRMMEnijl9bVRbEUCjzmALmXK6FrJPflj8s6ipfNDg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_pdc202xx_old: Fix crashes with ATAPI
Date: Tue, 22 Jan 2008 02:25:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: jeff@garzik.org, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
References: <20080119155126.180a010d@lxorguk.ukuu.org.uk> <200801220013.53545.bzolnier@gmail.com> <20080122000034.3e3f6dbb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080122000034.3e3f6dbb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801220225.10168.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008, Alan Cox wrote:
> > IDE pdc202xx_old host driver supports ATAPI DMA just fine and in line
> > with the PDC2026x programming guide.
> 
> News to me. It didn't last time I tried it the driver selected PIO.

Hmmm...

commit f3d5b34caae393f13a9486036f98c81cac1595c4
Author: Tobias Oed <tobiasoed@hotmail.com>
Date:   Tue Oct 3 01:14:17 2006 -0700

    [PATCH] Enable cdrom dma access with pdc20265_old

    This patch allows me to use dma with my cd/dvd attached to my on board
    pdc20265 ide controller
...
    Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
...

Are you by any chance using PDC20263?

[ PDC2026{5,7} should be fine (unless somebody broke it but then git-bisect
  should do the job)... ]

> > > So turn it ATAPI DMA off, these are disk optimised controllers.
> > 
> > This is an acceptable workaround for 2.6.24 but it probably just hides
> > some deeper pata_pdc202xx_old or/and libata problem.
> 
> Hard to be sure. No docs here for the older ones.

I lack the docs for PDC20263...

Bart
