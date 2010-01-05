Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121Ab0AEXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0AEXvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980Ab0AEXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:51:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56155
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204Ab0AEXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:51:46 -0500
Date: Tue, 05 Jan 2010 15:51:50 -0800 (PST)
Message-Id: <20100105.155150.232916389.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: mst@redhat.com, eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B43B989.4010004@nortel.com>
References: <4B43AEF6.6050701@nortel.com>
	<20100105.134218.258781374.davem@davemloft.net>
	<4B43B989.4010004@nortel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Tue, 05 Jan 2010 16:13:29 -0600

> If SOCK_RAW packets are being sent, the protocol number is embedded in
> the packet data

Where exactly is that protocol value?  Not every link level protocol
is ethernet.

We support FDDI, HIPPI, wireless, VLAN, PPP, and a host of others.

So you can't know for sure unless you assume ethernet, which you
can't do.
