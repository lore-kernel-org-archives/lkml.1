Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCZH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCZH4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZCZHz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:55:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41255
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbZCZHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:55:57 -0400
Date: Thu, 26 Mar 2009 00:55:45 -0700 (PDT)
Message-Id: <20090326.005545.180326952.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: Add support for the OpenCores 10/100 Mbps
 Ethernet MAC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1238053359-18896-1-git-send-email-thierry.reding@avionic-design.de>
References: <20090325.171813.19940151.davem@davemloft.net>
	<1238053359-18896-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2Q7uRqu014331

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Thu, 26 Mar 2009 08:42:39 +0100

> This patch adds a platform device driver that supports the OpenCores 10/100
> Mbps Ethernet MAC.
> 
> The driver expects three resources: one IORESOURCE_MEM resource defines the
> memory region for the core's memory-mapped registers while a second
> IORESOURCE_MEM resource defines the network packet buffer space. The third
> resource, of type IORESOURCE_IRQ, associates an interrupt with the driver.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Florian Fainelli <florian@openwrt.org>

This doesn't build:

drivers/net/ethoc.c: In function â€˜ethoc_interruptâ€™:
drivers/net/ethoc.c:510: error: implicit declaration of function â€˜netif_rx_schedule_prepâ€™
drivers/net/ethoc.c:511: error: implicit declaration of function â€˜__netif_rx_scheduleâ€™
drivers/net/ethoc.c: In function â€˜ethoc_pollâ€™:
drivers/net/ethoc.c:550: error: implicit declaration of function â€˜netif_rx_completeâ€™

You are missing some header includes.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
