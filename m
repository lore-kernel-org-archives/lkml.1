Return-Path: <linux-kernel-owner+w=401wt.eu-S935979AbXLQLte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935979AbXLQLte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbXLQLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:49:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:39353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412AbXLQLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YRgajCrTSSXF+zZnt92YFfA7C6M/hGAFajLtVDEe2P06WkE5dGtnWpcaRT5IEq/mceX3qjlC+4ZAbdFGtQ+lS/CrEwPYVXsV92wunF2l1VNa2RhAlVuUKMMyCJYnoJ+QJnMfPAGrPM3sGo1wu5rkcKMV7XO8RjbV7Jc0rVkxMZM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Oliver Joa <oliver@j-o-a.de>
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
Date: Mon, 17 Dec 2007 12:58:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <4765690C.6010605@j-o-a.de> <20071216201643.396fa8d7@the-village.bc.nu> <47665ACE.7020907@j-o-a.de>
In-Reply-To: <47665ACE.7020907@j-o-a.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712171258.59585.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 December 2007, Oliver Joa wrote:
> Hi,
> 
> Alan Cox wrote:
> 
> [...]
> 
> > For the current kernel and libata you can use libata.dma=3, and it will
> > select DMA for disk (1) + CD (2) but not CF cards. With the older IDE it
> > should be sufficient to use hda=nodma
> 
> Thanks a lot, but it does not work:
> 
> If I use libata.dma=3 I get the following:
> [    0.000000] Unknown boot option `libata.dma=3': ignoring
> 
> And if I use hda=nodma:
> [    0.000000] ide_setup: hda=nodma -- BAD OPTION
> 
> I use kernel 2.6.21.5.
> 
> Any Idea?

"hdx=nodma" was added in 2.6.24-rc1, older kernels have only "ide=nodma"

Also "ide=nodma" may not work in older kernel with some buggy host drivers
(they were fixed in 2.6.24-rc1).

Bart
