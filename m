Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYBXFMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYBXFMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYBXFLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:11:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50445 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYBXFLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:11:54 -0500
Message-ID: <47C0FC94.6030102@garzik.org>
Date: Sun, 24 Feb 2008 00:11:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macb: Fix speed setting
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
> conversion to generic PHY layer in kernel 2.6.23.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/net/macb.c b/drivers/net/macb.c
> index 81bf005..1d210ed 100644
> --- a/drivers/net/macb.c
> +++ b/drivers/net/macb.c
> @@ -148,7 +148,7 @@ static void macb_handle_link_change(struct net_device *dev)
>  
>  			if (phydev->duplex)
>  				reg |= MACB_BIT(FD);
> -			if (phydev->speed)
> +			if (phydev->speed == SPEED_100)
>  				reg |= MACB_BIT(SPD);

applied


