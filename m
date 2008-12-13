Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYLMFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYLMFTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLMFT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:19:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56298
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbYLMFTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:19:25 -0500
Date: Fri, 12 Dec 2008 21:19:26 -0800 (PST)
Message-Id: <20081212.211926.239388789.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/9][v2] mISDN: timerdev: use __user for mISDN_read's
 buffer argument
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a3f.0710660a.4800.7087@mx.google.com>
References: <49419a3f.0710660a.4800.7087@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Fix this warning:
> 
>   drivers/isdn/mISDN/timerdev.c:264:11: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
>   drivers/isdn/mISDN/timerdev.c:264:11:    expected int ( *read )( ... )
>   drivers/isdn/mISDN/timerdev.c:264:11:    got int ( static [toplevel] *<noident> )( ... )
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
