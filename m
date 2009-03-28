Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZC1A2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZC1A2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZC1A14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:27:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbZC1A1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:27:55 -0400
Date: Fri, 27 Mar 2009 17:27:43 -0700 (PDT)
Message-Id: <20090327.172743.30040617.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <ac3eb2510903270521i113df787u7ac5d842ece83740@mail.gmail.com>
References: <ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com>
	<20081107.013833.147302570.davem@davemloft.net>
	<ac3eb2510903270521i113df787u7ac5d842ece83740@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 27 Mar 2009 13:21:56 +0100

> it took a while, but it happened now, so this issue is coming back. :)
> 
> The name size limit is gone, there is no BUS_ID_SIZE thing anymore in
> the driver core. BUS_ID_SIZE should go away in the 2.6.30 timeframe.
> 
> Could you please convert/remove BUS_ID_SIZE value from:
>   drivers/net/gianfar.h:	char	phy_bus_id[BUS_ID_SIZE];
>   drivers/net/ucc_geth.h:	char phy_bus_id[BUS_ID_SIZE];
>   drivers/net/pasemi_mac.h:	char	phy_id[BUS_ID_SIZE];
>   include/linux/phy.h:#define MII_BUS_ID_SIZE	(BUS_ID_SIZE - 3)
>   include/linux/phy.h:	char bus_id[BUS_ID_SIZE];
> 
> Or let me know how you want to convert it, so I can do it?

Thanks a lot Kay, I'll look into these cases and take care
of it.
