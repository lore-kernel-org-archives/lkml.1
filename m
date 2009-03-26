Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZCZH6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZCZH6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZCZH6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:58:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbZCZH6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:58:30 -0400
Date: Thu, 26 Mar 2009 00:58:18 -0700 (PDT)
Message-Id: <20090326.005818.46327905.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: Add support for the OpenCores 10/100 Mbps
 Ethernet MAC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326.005545.180326952.davem@davemloft.net>
References: <20090325.171813.19940151.davem@davemloft.net>
	<1238053359-18896-1-git-send-email-thierry.reding@avionic-design.de>
	<20090326.005545.180326952.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2Q7wlqu014342

From: David Miller <davem@davemloft.net>
Date: Thu, 26 Mar 2009 00:55:45 -0700 (PDT)

> This doesn't build:
> 
> drivers/net/ethoc.c: In function â€˜ethoc_interruptâ€™:
> drivers/net/ethoc.c:510: error: implicit declaration of function â€˜netif_rx_schedule_prepâ€™
> drivers/net/ethoc.c:511: error: implicit declaration of function â€˜__netif_rx_scheduleâ€™
> drivers/net/ethoc.c: In function â€˜ethoc_pollâ€™:
> drivers/net/ethoc.c:550: error: implicit declaration of function â€˜netif_rx_completeâ€™
> 
> You are missing some header includes.

Actually the problem is that you're using deprecated interfaces which
have been removed in net-next-2.6, please use napi_*() instead of
netif_rx_*().
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
