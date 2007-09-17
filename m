Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXIQCux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXIQCux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 22:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXIQCup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 22:50:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16519 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXIQCun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 22:50:43 -0400
X-IronPort-AV: i="4.20,262,1186372800"; 
   d="scan'208"; a="39732162:sNHT32439344"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: bryan.wu@analog.com
Subject: Re: [PATCH 3/3] Blackfin EMAC driver: Add phyabstraction layer supporting in bfin_emac driver
Date: Sun, 16 Sep 2007 22:51:01 -0400
User-Agent: KMail/1.9.5
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1189911475.9901.8.camel@roc-laptop>
In-Reply-To: <1189911475.9901.8.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162251.01558.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Sep 2007 02:50:42.0530 (UTC) FILETIME=[89B34C20:01C7F8D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 15 Sep 2007 22:57, Bryan Wu pondered:
> 
>  - add MDIO functions and register mdio bus
>  - add phy abstraction layer (PAL) functions and use PAL API
>  - test on STAMP537 board

Today, the Kconfig for the Blackfin just includes:

> config BFIN_MAC
>         tristate "Blackfin 536/537 on-chip mac support"
>         depends on NET_ETHERNET && (BF537 || BF536) && (!BF537_PORT_H)
>         select CRC32
>         select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
>         help
>           This is the driver for blackfin on-chip mac device. Say Y if you
> want it compiled into the kernel. This driver is also available as a module
> ( = code which can be inserted in and removed from the running kernel
> whenever you want). The module will be called bfin_mac.

Since you are adding requirement for the PHYLIB with this patch, should there
be a select for that?

-Robin
