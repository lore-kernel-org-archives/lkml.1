Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXERVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXERVx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXERVxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:53:21 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1462 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXERVxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:53:20 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 17:53:20 EDT
From: Mariusz =?iso-8859-2?q?Koz=B3owski?= <m.kozlowski@tuxland.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] net driver updates
Date: Fri, 18 May 2007 23:46:21 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20070508063337.GA12474@havoc.gtf.org>
In-Reply-To: <20070508063337.GA12474@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705182346.21835.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> index 7053026..111f23d 100644
> --- a/drivers/net/smc91x.h
> +++ b/drivers/net/smc91x.h
> @@ -279,6 +279,40 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)

...

> +#define SMC_outb(v, a, r)      outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) + ((r)&~1))

This one has unbalanced parenthesis.

Regards,

	Mariusz
