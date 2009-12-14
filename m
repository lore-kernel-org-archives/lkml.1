Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZLNEAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZLNEAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZLND76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:59:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34147
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539AbZLND5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:57:54 -0500
Date: Sun, 13 Dec 2009 19:57:56 -0800 (PST)
Message-Id: <20091213.195756.102569162.davem@davemloft.net>
To: julia@diku.dk
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/cpmac.c: Correct code taking the size of a
 pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912131635110.27767@ask.diku.dk>
References: <Pine.LNX.4.64.0912131635110.27767@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 13 Dec 2009 16:35:45 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(dev->dev_addr) is the size of a pointer.  On the other hand,
> sizeof(pdata->dev_addr) is the size of an array, so use that instead.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
