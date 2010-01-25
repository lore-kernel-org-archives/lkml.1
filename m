Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AYDw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AYDw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486Ab0AYDw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:52:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57000
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab0AYDw0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:52:26 -0500
Date: Sun, 24 Jan 2010 19:52:36 -0800 (PST)
Message-Id: <20100124.195236.40118964.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bonbons@linux-vserver.org, xiyou.wangcong@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: fix vlan_skb_recv()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B5CA2CA.4040307@gmail.com>
References: <4B5C74BF.5060604@gmail.com>
	<20100124201808.2bbbf0b0@neptune.home>
	<4B5CA2CA.4040307@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 24 Jan 2010 20:43:06 +0100

> [PATCH] vlan: fix vlan_skb_recv()
> 
> Bruno Prémont found commit 9793241fe92f7d930
> (vlan: Precise RX stats accounting) added a regression for non
> hw accelerated vlans.
> 
> [   26.390576] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   26.396369] IP: [<df856b89>] vlan_skb_recv+0x89/0x280 [8021q]
> 
> vlan_dev_info() was used with original device, instead of
> skb->dev. Also spotted by Américo Wang.
> 
> Reported-By: Bruno Prémont <bonbons@linux-vserver.org>
> Tested-By: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
