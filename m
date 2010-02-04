Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0BDRlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:41:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33998
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348Ab0BDRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:40:57 -0500
Date: Thu, 04 Feb 2010 09:41:10 -0800 (PST)
Message-Id: <20100204.094110.64247447.davem@davemloft.net>
To: opurdila@ixiacom.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
 port numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002041444.01897.opurdila@ixiacom.com>
References: <201002031312.48531.opurdila@ixiacom.com>
	<4B6A3DBA.1000706@redhat.com>
	<201002041444.01897.opurdila@ixiacom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <opurdila@ixiacom.com>
Date: Thu, 4 Feb 2010 14:44:01 +0200

> My concern is that we can have multiple applications that require a
> fixed port and if those ports are significantly apart we will
> decrease the port range available for connect. And that will hurt
> the rate of which new connections can be opened.

I'm already uneasy about adding the simple check every time
we loop around in the bind port allocator.

Adding an LSM hook to this spot?  I absolutely refuse to allow
that, it will completely kill bind performance.
