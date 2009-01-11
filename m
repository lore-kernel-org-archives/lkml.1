Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZAKKDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZAKKDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 05:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZAKKDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 05:03:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:39321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZAKKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 05:03:42 -0500
Date: Sun, 11 Jan 2009 10:03:26 +0000 (GMT)
From: Alexey Korolev <akorolev@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alexander Beregalov <a.beregalov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: mtd/lpddr/qinfo_probe.c needs lpddr_cmds to be compiled
In-Reply-To: <49682F42.8070304@oracle.com>
Message-ID: <alpine.LFD.2.00.0901110958360.20119@casper.infradead.org>
References: <20090110021641.GA26951@orion> <49682F42.8070304@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

I've just checked 2.6.29-rc1. It contains LPDDR patches but does not contain this patch. 
Do you know whom I should ask to make this included?

Thanks,
Alexey

> > drivers/built-in.o: In function `lpddr_probe':
> > drivers/mtd/lpddr/qinfo_probe.c:215:
> > undefined reference to `lpddr_cmdset'
> > 
> > # CONFIG_MTD_LPDDR is not set
> > CONFIG_MTD_QINFO_PROBE=y
> > --
> 
> This patch has been posted, just needs to be merged (hint):
> ---
> 
> 
> Signed-off-by: Alexey Korolev <akorolev@infradead.org>
> ---
> diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
> index acd4ea9..5a401d8 100644
> --- a/drivers/mtd/lpddr/Kconfig
> +++ b/drivers/mtd/lpddr/Kconfig
> @@ -12,6 +12,7 @@ config MTD_LPDDR
>  	  DDR memories, intended for battery-operated systems.
>  
>  config MTD_QINFO_PROBE
> +	depends on MTD_LPDDR
>  	tristate "Detect flash chips by QINFO probe"
>  	help
>  	    Device Information for LPDDR chips is offered through the Overlay
> 
> 
