Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYLZIMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYLZIMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYLZIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:12:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53373
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbYLZIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:12:12 -0500
Date: Fri, 26 Dec 2008 00:12:14 -0800 (PST)
Message-Id: <20081226.001214.02292973.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/27] drivers/net/wan/z85230.c: fix sparse warnings:
 un-EXPORT symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191813.11807.144.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191813.11807.144.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:18:13 +0100

> The symbols are only references within the translation unit they are
> defined in, so un-EXPORT them und make them 'static'.
> 
> Fix this sparse warnings:
> 
>   drivers/net/wan/z85230.c:604:25: warning: symbol 'z8530_dma_sync' was not declared. Should it be static?
>   drivers/net/wan/z85230.c:613:25: warning: symbol 'z8530_txdma_sync' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
