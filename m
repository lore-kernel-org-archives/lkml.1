Return-Path: <linux-kernel-owner+w=401wt.eu-S935790AbXLQLRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935790AbXLQLRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbXLQLRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:17:41 -0500
Received: from mail.gatrixx.com ([217.111.11.44]:48628 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbXLQLRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:17:41 -0500
Message-ID: <47665ACE.7020907@j-o-a.de>
Date: Mon, 17 Dec 2007 12:17:34 +0100
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de> <20071216201643.396fa8d7@the-village.bc.nu>
In-Reply-To: <20071216201643.396fa8d7@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alan Cox wrote:

[...]

> For the current kernel and libata you can use libata.dma=3, and it will
> select DMA for disk (1) + CD (2) but not CF cards. With the older IDE it
> should be sufficient to use hda=nodma

Thanks a lot, but it does not work:

If I use libata.dma=3 I get the following:
[    0.000000] Unknown boot option `libata.dma=3': ignoring

And if I use hda=nodma:
[    0.000000] ide_setup: hda=nodma -- BAD OPTION

I use kernel 2.6.21.5.

Any Idea?

Thanks

Olli
