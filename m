Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbXESRCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbXESRCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXESRCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:02:07 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51268 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbXESRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:02:06 -0400
Date: Sat, 19 May 2007 11:01:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_sil: Greatly improve DMA support
In-reply-to: <fa.SqfRJHzGgf3m6sdJPwJTwHDPSuw@ifi.uio.no>
To: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org
Message-id: <464F2D83.6000506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.SqfRJHzGgf3m6sdJPwJTwHDPSuw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Since Alan expressed a desire to see Large Block Transfer (LBT) support
> in pata_sil680, I though I would re-post my patch for adding LBT support
> to sata_sil.
> 
> Silicon Image's Large Block Transfer (LBT) support is a vendor-specific
> DMA scatter/gather engine, which enables 64-bit DMA addresses (where
> supported by platform) and eliminates the annoying 64k DMA boundary
> found in legacy PCI IDE BMDMA engines.

Looks like it doesn't allow 64-bit DMA addresses, it only gets rid of 
the 64K boundary limitation.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

