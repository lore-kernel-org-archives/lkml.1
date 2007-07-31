Return-Path: <linux-kernel-owner+w=401wt.eu-S939712AbXGaAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939712AbXGaAVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765101AbXGaAVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:21:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45543
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761278AbXGaAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:21:06 -0400
Date: Mon, 30 Jul 2007 17:21:05 -0700 (PDT)
Message-Id: <20070730.172105.35015509.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: djohnson+linux-kernel@sw.starentnetworks.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       sakkiped@starentnetworks.com
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070726.133452.78498553.yoshfuji@linux-ipv6.org>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
	<20070726.133452.78498553.yoshfuji@linux-ipv6.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date: Thu, 26 Jul 2007 13:34:52 -0500 (CDT)

> In article <18087.57717.495366.413571@zeus.sw.starentnetworks.com> (at Wed, 25 Jul 2007 19:49:09 -0400), Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> says:
> 
> > ipv6_addr_type() doesn't check for 'Unique Local IPv6 Unicast
> > Addresses' (RFC4193) and returns IPV6_ADDR_RESERVED for that range.
> 
> Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Ok, I've applied Dave's patch.

Dave, although it's customary and fine to use "+foo-list" email
addresses for mailing list subscriptions and discussions, I
ask that you don't add that cookie to your signoff lines in
patch submissions and I've removed it from your's in this patch.

Thanks a lot.
