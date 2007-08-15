Return-Path: <linux-kernel-owner+w=401wt.eu-S936631AbXHOXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936631AbXHOXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbXHOXGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:06:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44327
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756504AbXHOXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:06:00 -0400
Date: Wed, 15 Aug 2007 16:05:57 -0700 (PDT)
Message-Id: <20070815.160557.104645231.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add ETHTOOL_[GS]FLAGS sub-ioctls
From: David Miller <davem@davemloft.net>
In-Reply-To: <46BCD0F1.8040006@garzik.org>
References: <20070810202426.GA25050@havoc.gtf.org>
	<46BCD0F1.8040006@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 10 Aug 2007 16:56:17 -0400

> All this is currently checked into the 'eflags' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
> 
> But when everybody is happy with it, IMO we should get it into 
> net-2.6.24.git, as it enables LRO.

I've backed out the ETHTOOL LRO stuff from Auke, and applied your
patches to net-2.6.24

We can get rid of that NETIF_F_LRO thing, since as you observed
it is indeed superfluous.

