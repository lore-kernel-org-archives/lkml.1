Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXKHKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXKHKsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbXKHKs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:48:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48534 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753636AbXKHKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:48:28 -0500
Date: Thu, 8 Nov 2007 10:48:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Message-ID: <20071108104813.78ca4d65@the-village.bc.nu>
In-Reply-To: <20071108071204.M66693@visp.net.lb>
References: <20071101213013.M54162@visp.net.lb>
	<20071107232045.GA26706@havoc.gtf.org>
	<20071107235548.M95675@visp.net.lb>
	<200711080130.54143.bzolnier@gmail.com>
	<20071108071204.M66693@visp.net.lb>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 09:16:35 +0200
"Denys Fedoryshchenko" <denys@visp.net.lb> wrote:

> Does it work as kernel parameter?
> 
> I tried libata_dma_mask=0x4 and to set 0xf or 0xff - doesn't help. How to 
> disable DMA in libata, if it is compiled in kernel?

libata.dma_mask=3

will leave you with CD and disk DMA but not CF DMA

(Note libata[DOT] not underscore)
