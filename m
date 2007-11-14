Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXKNB4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXKNB4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXKNB4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:56:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35182
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758740AbXKNB4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:56:17 -0500
Date: Tue, 13 Nov 2007 17:56:16 -0800 (PST)
Message-Id: <20071113.175616.129918600.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: liml@rtr.ca, mingo@elte.hu, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, akpm@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071113234033.GL1356@flint.arm.linux.org.uk>
References: <20071113193750.GD1356@flint.arm.linux.org.uk>
	<473A067F.3090007@rtr.ca>
	<20071113234033.GL1356@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Tue, 13 Nov 2007 23:40:33 +0000

> ARM ep93xx defconfig has been broken since 2.6.23-git1 due to:
> 
> drivers/net/arm/ep93xx_eth.c:420: error: implicit declaration of function '__netif_rx_schedule_prep'
> 
> caused by: [NET]: Make NAPI polling independent of struct net_device objects.
> 
> ARM netx defconfig has been broken since 2.6.23-git1 due to:
> 
> drivers/net/netx-eth.c: In function 'netx_eth_hard_start_xmit':
> drivers/net/netx-eth.c:131: error: 'dev' undeclared (first use in this function)
> drivers/net/netx-eth.c:131: error: (Each undeclared identifier is reported only once
> drivers/net/netx-eth.c:131: error: for each function it appears in.)
> drivers/net/netx-eth.c: In function 'netx_eth_receive':
> drivers/net/netx-eth.c:158: error: 'dev' undeclared (first use in this function)
> 
> caused by: [NET] drivers/net: statistics cleanup #1 -- save memory and shrink code
> 

I'll fix these up, thanks for the report.
