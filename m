Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbXKHWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbXKHWlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXKHWlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:41:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56754 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751552AbXKHWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:41:03 -0500
Date: Thu, 8 Nov 2007 22:40:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Cc: Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Message-ID: <20071108224043.4e0bd7b6@the-village.bc.nu>
In-Reply-To: <20071108195605.M20599@visp.net.lb>
References: <20071101213013.M54162@visp.net.lb>
	<20071107232045.GA26706@havoc.gtf.org>
	<20071107235548.M95675@visp.net.lb>
	<200711080130.54143.bzolnier@gmail.com>
	<20071108071204.M66693@visp.net.lb>
	<20071108104813.78ca4d65@the-village.bc.nu>
	<20071108164320.M82021@visp.net.lb>
	<20071108173139.GA1932@havoc.gtf.org>
	<20071108195605.M20599@visp.net.lb>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 21:56:32 +0200
"Denys Fedoryshchenko" <denys@visp.net.lb> wrote:

> Thanks, it works like that.
> 
> Seems in libata there is no fall-back to non-DMA mode, if DMA didn't work.


It should be falling back from UDMA or MWDMA to PIO, if not please file a
bug

Alan
