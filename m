Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbZJSE07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbZJSE07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 00:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZJSE07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 00:26:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37727
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZJSE06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 00:26:58 -0400
Date: Sun, 18 Oct 2009 21:27:21 -0700 (PDT)
Message-Id: <20091018.212721.27805107.davem@davemloft.net>
To: sfking@fdwdc.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] fix section mismatch in fec.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910181525.48574.sfking@fdwdc.com>
References: <200910181525.48574.sfking@fdwdc.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven King <sfking@fdwdc.com>
Date: Sun, 18 Oct 2009 15:25:48 -0700

>    */
> -int __init fec_enet_init(struct net_device *dev, int index)
> +static int
> +fec_enet_init(struct net_device *dev, int index)
>  {

Don't change coding style when fixing a bug.

Fix this up and resubmit your fix, thanks.
