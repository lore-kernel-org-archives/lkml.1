Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYLMFUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYLMFUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYLMFUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:20:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56302
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbYLMFUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:20:10 -0500
Date: Fri, 12 Dec 2008 21:20:12 -0800 (PST)
Message-Id: <20081212.212012.212498095.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/9][v2] mISDN: hfcmulti: use __iomem address space
 modifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a44.09c5660a.39e6.65f7@mx.google.com>
References: <49419a44.09c5660a.39e6.65f7@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Impact: make use of the __iomem address space modifier, and change u_char *,
> u_short * and u_int * to void *
> 
> Fix more than 30 sparse warnings of this or similar type:
> 
>   drivers/isdn/hardware/mISDN/hfcmulti.c:261:31: warning: incorrect type in argument 2 (different address spaces)
>   drivers/isdn/hardware/mISDN/hfcmulti.c:261:31:    got unsigned char [usertype] *
>   drivers/isdn/hardware/mISDN/hfcmulti.c:261:31:    expected void volatile [noderef] <asn:2>*addr
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
