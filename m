Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbXBYAyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbXBYAyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932856AbXBYAyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:54:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41352
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932425AbXBYAyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:54:54 -0500
Date: Sat, 24 Feb 2007 16:54:53 -0800 (PST)
Message-Id: <20070224.165453.104035690.davem@davemloft.net>
To: bunk@stusta.de
Cc: yoshfuji@linux-ipv6.org, clem@clem.clem-digital.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070224225021.GT12392@stusta.de>
References: <200702130236.l1D2a0u7014457@clem.clem-digital.net>
	<20070213.115510.21486123.yoshfuji@linux-ipv6.org>
	<20070224225021.GT12392@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sat, 24 Feb 2007 23:50:21 +0100

> In the CONFIG_IPV6=m, CONFIG_SUNRPC=m case, this will result in no IPV6 
> support here.
> 
> If you are going this way, a Kconfig helper variable might be better:
> 
> config SUNRPC_IPV6
> 	bool
> 	default y if (SUNRPC=y && IPV6=y) || (SUNRPC=m && IPV6) 

Please, don't worry about any of this, Yoshifuji already
gave me a fix for this, that will provide the symbol statically
and exported to modules, even if  ipv6 is built modular.

So we don't need to worry about this problem any more.
