Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbYLMFQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbYLMFQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYLMFQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:16:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42640
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbYLMFQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:16:19 -0500
Date: Fri, 12 Dec 2008 21:16:21 -0800 (PST)
Message-Id: <20081212.211621.232812118.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9][v2] mISDN: un-export symbol 'plx_lock'
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a2d.06a1660a.5c0a.ffff908c@mx.google.com>
References: <49419a2d.06a1660a.5c0a.ffff908c@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> 'plx_lock' is only used within hfcmulti.c.
> 
> Fix this warning:
> 
>   drivers/isdn/hardware/mISDN/hfcmulti.c:176:1: warning: symbol 'plx_lock' shadows an earlier one
>   drivers/isdn/hardware/mISDN/hfcmulti.c:175:19: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
