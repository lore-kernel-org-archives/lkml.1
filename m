Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXKMLgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXKMLgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXKMLgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:36:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbXKMLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:36:12 -0500
Date: Tue, 13 Nov 2007 03:36:11 -0800 (PST)
Message-Id: <20071113.033611.73195922.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: kaber@trash.net, joonwpark81@gmail.com, w@1wt.eu, cfriesen@nortel.com,
       auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1Irtdz-0000DX-00@gondolin.me.apana.org.au>
References: <47397AB3.90705@trash.net>
	<E1Irtdz-0000DX-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 13 Nov 2007 19:09:23 +0800

> I agree.  People doing a tcpdump don't have to turn on promiscuous
> mode, that's what the -p option is for.  In other words, having
> promiscuous mode disable VLAN filtering does not take away the
> user's options at all.
> 
> In fact, the very definition of promiscuous is to turn off hardware
> filtering, albeit the filtering of MAC addresses rather than VLAN
> tags.  So it would seem logical to have it turn off VLAN filtering
> too.

Ok.

The performance implications can be pretty severe however.
I wish we could address this somehow.

