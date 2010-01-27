Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106Ab0A0Acs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0A0Acs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900Ab0A0Acr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:32:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57632
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705Ab0A0Acr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:32:47 -0500
Date: Tue, 26 Jan 2010 16:32:56 -0800 (PST)
Message-Id: <20100126.163256.196562963.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: geert@linux-m68k.org, linux-next@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev: remove HAVE_ leftovers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100126191727.GA5454@x200>
References: <10f740e81001260057h37f3494dvefa3a37b2e1453a5@mail.gmail.com>
	<20100126.051817.215651254.davem@davemloft.net>
	<20100126191727.GA5454@x200>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 26 Jan 2010 21:17:27 +0200

> On Tue, Jan 26, 2010 at 05:18:17AM -0800, David Miller wrote:
>> Alexey, please go through at least drivers/net and look at the
>> other stale references to these HAVE_* macros.
> 
> My apologies.
> 
> 
> [PATCH] netdev: remove HAVE_ leftovers
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

What about HAVE_POLL_CONTROLLER and some other remaining stuff?

drivers/net/bnx2.c:#if defined(HAVE_POLL_CONTROLLER) || defined(CONFIG_NET_POLL_CONTROLLER)
drivers/net/bnx2x_main.c:#if defined(HAVE_POLL_CONTROLLER) || defined(CONFIG_NET_POLL_CONTROLLER)
drivers/net/ixgbevf/ixgbevf_main.c:#ifdef HAVE_TX_MQ
drivers/net/ixgbevf/ixgbevf_main.c:#ifndef HAVE_NETDEV_NAPI_LIST
drivers/net/ixgbevf/ixgbevf_main.c:#ifdef HAVE_NET_DEVICE_OPS
