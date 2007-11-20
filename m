Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbXKTF0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbXKTF0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXKTF0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:26:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51702
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbXKTF0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:26:39 -0500
Date: Mon, 19 Nov 2007 21:26:39 -0800 (PST)
Message-Id: <20071119.212639.217993660.davem@davemloft.net>
To: bunk@kernel.org
Cc: david-b@pacbell.net, randy.dunlap@oracle.com, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function
 `usbnet_set_settings':
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071108033010.GF26163@stusta.de>
References: <200711071434.52607.david-b@pacbell.net>
	<20071107225232.GB26163@stusta.de>
	<20071108033010.GF26163@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 8 Nov 2007 04:30:10 +0100

> @davem:
> 
> Please look at net/ipv4/arp.c:arp_process()
> 
> Am I right that CONFIG_NET_ETHERNET=n and CONFIG_NETDEV_1000=y or 
> CONFIG_NETDEV_10000=y will not be handled correctly there?
> 
> And the best solution is to nuke all #ifdef's in this function and make 
> the code unconditionally available?

I think removing those specific ifdefs in arp_process()
is the best option, yes.
