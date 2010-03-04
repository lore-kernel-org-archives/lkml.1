Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0CDDUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:20:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0CDDTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:19:55 -0500
Date: Thu, 4 Mar 2010 04:18:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] bridge: depends on INET
Message-ID: <20100304031847.GA22683@elte.hu>
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
 <4B8D4607.8070603@xenotime.net>
 <20100303.012359.66790294.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303.012359.66790294.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: Tue, 02 Mar 2010 09:08:23 -0800
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > br_multicast calls ip_send_check(), so it should depend on INET.
> > 
> > built-in:
> > br_multicast.c:(.text+0x88cf4): undefined reference to `ip_send_check'
> > 
> > or modular:
> > ERROR: "ip_send_check" [net/bridge/bridge.ko] undefined!
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Applied, but I almost lost this patch.
> 
> You need to CC: netdev on all networking patches so that it
> gets properly tracked in patchwork and therefore does not get
> lost.

I suspect Randy went by the MAINTAINERS entry - you might want to add netdev 
as a second 'L:' line:

 ETHERNET BRIDGE
 M:      Stephen Hemminger <shemminger@linux-foundation.org>
 L:      bridge@lists.linux-foundation.org
 W:      http://www.linux-foundation.org/en/Net:Bridge
 S:      Maintained
 F:      include/linux/netfilter_bridge/
 F:      net/bridge/

To make it really clear that netdev must be Cc:-ed for those patches.

Thanks,

	Ingo
