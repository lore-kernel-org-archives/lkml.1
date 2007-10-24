Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbXJXAX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbXJXAX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXJXAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:23:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbXJXAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:23:43 -0400
Message-ID: <471E9087.7030309@pobox.com>
Date: Tue, 23 Oct 2007 20:23:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] defxx.c: dfx_bus_init() is __devexit not __devinit
References: <Pine.LNX.4.64N.0710221809350.988@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0710221809350.988@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  The dfx_bus_uninit() call is called from dfx_unregister() which is 
> __devexit and which is ultimately the ->remove call for the device.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It should be obvious.  Please apply.
> 
>   Maciej
> 
> patch-mips-2.6.23-rc5-20070904-defxx-devexit-0
> diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c
> --- linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c	2007-09-04 04:55:41.000000000 +0000
> +++ linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c	2007-10-12 00:21:35.000000000 +0000
> @@ -806,7 +806,7 @@ static void __devinit dfx_bus_init(struc
>   *   Interrupts are disabled at the adapter bus-specific logic.
>   */
>  
> -static void __devinit dfx_bus_uninit(struct net_device *dev)
> +static void __devexit dfx_bus_uninit(struct net_device *dev)
>  {
>  	DFX_board_t *bp = netdev_priv(dev);

applied


