Return-Path: <linux-kernel-owner+w=401wt.eu-S1765045AbXEYUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765045AbXEYUrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXEYUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:47:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42001 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXEYUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:47:27 -0400
Date: Fri, 25 May 2007 22:47:48 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
Message-ID: <20070525204748.GA4686@aepfle.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.575306000@sonycom.com> <20070525114550.GA32552@aepfle.de> <Pine.LNX.4.62.0705252143070.2657@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705252143070.2657@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, Geert Uytterhoeven wrote:

> On Fri, 25 May 2007, Olaf Hering wrote:
> > On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:
> > > Add a Disk Storage Driver for the PS3:
> > 
> > There is no device symlink in /sys/block/ps3da/
> 
> Interesting... Do you know how to create it?

No, that was not obvious.
But for gelic it goes like this:

+++ b/drivers/net/gelic_net.c
@@ -1364,6 +1364,7 @@ static int gelic_net_setup_netdev(struct
        u64 v1, v2;
 
        SET_MODULE_OWNER(netdev);
+       SET_NETDEV_DEV(netdev, &card->dev->core);
        spin_lock_init(&card->tx_dma_lock);
 
        card->rx_csum = GELIC_NET_RX_CSUM_DEFAULT;

