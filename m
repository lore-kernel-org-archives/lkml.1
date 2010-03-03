Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0CCJXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:23:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41746
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab0CCJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:23:41 -0500
Date: Wed, 03 Mar 2010 01:23:59 -0800 (PST)
Message-Id: <20100303.012359.66790294.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] bridge: depends on INET
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B8D4607.8070603@xenotime.net>
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
	<4B8D4607.8070603@xenotime.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 02 Mar 2010 09:08:23 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> br_multicast calls ip_send_check(), so it should depend on INET.
> 
> built-in:
> br_multicast.c:(.text+0x88cf4): undefined reference to `ip_send_check'
> 
> or modular:
> ERROR: "ip_send_check" [net/bridge/bridge.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, but I almost lost this patch.

You need to CC: netdev on all networking patches so that it
gets properly tracked in patchwork and therefore does not get
lost.

Thanks.
