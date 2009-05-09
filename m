Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZEIUSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZEIUSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZEIUSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:18:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43093
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbZEIUSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:18:05 -0400
Date: Sat, 09 May 2009 13:18:01 -0700 (PDT)
Message-Id: <20090509.131801.250435722.davem@davemloft.net>
To: jpirko@redhat.com
Cc: richard.genoud@gmail.com, fubar@us.ibm.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Remove duplicate slow protocol define in bond_3ad.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090509171250.GA3390@psychotron.englab.brq.redhat.com>
References: <1241888356-7575-1-git-send-email-richard.genoud@gmail.com>
	<20090509171250.GA3390@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Sat, 9 May 2009 19:12:53 +0200

> Sat, May 09, 2009 at 06:59:16PM CEST, richard.genoud@gmail.com wrote:
>>ETH_P_SLOW is already defined in include/linux/if_ether.h.
>>There's no need to define BOND_ETH_P_LACPDU in drivers/net/bonding/bond_3ad.h
>>
>>Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>>---
>> drivers/net/bonding/bond_3ad.h |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>>diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
>>index a306230..2c46a15 100644
>>--- a/drivers/net/bonding/bond_3ad.h
>>+++ b/drivers/net/bonding/bond_3ad.h
>>@@ -26,10 +26,10 @@
>> #include <asm/byteorder.h>
>> #include <linux/skbuff.h>
>> #include <linux/netdevice.h>
>>+#include <linux/if_ether.h>
>> 
>> // General definitions
>>-#define BOND_ETH_P_LACPDU       0x8809
>>-#define PKT_TYPE_LACPDU         cpu_to_be16(BOND_ETH_P_LACPDU)
>>+#define PKT_TYPE_LACPDU         cpu_to_be16(ETH_P_SLOW)
>> #define AD_TIMER_INTERVAL       100 /*msec*/
>> 
>> #define MULTICAST_LACPDU_ADDR    {0x01, 0x80, 0xC2, 0x00, 0x00, 0x02}
>>-- 
>>1.6.0.4
> 
> Looks good.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Applied to net-next-2.6
