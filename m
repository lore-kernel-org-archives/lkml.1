Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZJMKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZJMKZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZJMKZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:25:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34289
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbZJMKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:25:42 -0400
Date: Tue, 13 Oct 2009 03:25:38 -0700 (PDT)
Message-Id: <20091013.032538.71622552.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ctrixk@navynet.it, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AD45447.7030705@gmail.com>
References: <20091012.034224.64980795.davem@davemloft.net>
	<4AD44435.3050703@navynet.it>
	<4AD45447.7030705@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 13 Oct 2009 12:19:51 +0200

> Quick fix would be to use dev_kfree_skb_any() instead,
> because netpoll can definitly calls start_xmit()
> with irq disabled.

Indeed, because of netpoll(), that is something drivers
must be able to cope with.

> Could you please following patch ?

Indeed, let us know how Eric's patch works.

Thanks Eric!
