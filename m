Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbXIFUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbXIFUt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXIFUto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:49:44 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:53391
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbXIFUtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:49:42 -0400
Date: Thu, 06 Sep 2007 13:49:04 -0700 (PDT)
Message-Id: <20070906.134904.59659883.davem@davemloft.net>
To: bernhard@bwalle.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix config requirements of IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070906200151.GA28306@mail1.bwalle.de>
References: <20070906200151.GA28306@mail1.bwalle.de>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Walle <bernhard@bwalle.de>
Date: Thu, 6 Sep 2007 22:01:52 +0200

> [PATCH] Fix config requirements of IPv6
> 
> net/ipv6/inet6_connection_sock.c in function __inet6_csk_dst_store() requires
> flow_cache_genid which is defined in net/core/flow.c which is compiled when
> CONFIG_XFRM is set.
> 
> This patch expresses that dependency.
> 
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

IPV6 should not require XFRM, a proper fix for this issue
was added to the net-2.6.24 tree earlier today already.
