Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXJ2WHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXJ2WHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXJ2WHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:07:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbXJ2WHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:07:34 -0400
Date: Mon, 29 Oct 2007 15:07:36 -0700 (PDT)
Message-Id: <20071029.150736.168006897.davem@davemloft.net>
To: toms@wonderland.us.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/net/sunhme.c patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <4725F416.2030100@wonderland.us.com>
References: <4725F416.2030100@wonderland.us.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Southerland <toms@wonderland.us.com>
Date: Mon, 29 Oct 2007 08:54:14 -0600

> This patch provides a unique mac address for all interfaces
> for the Sun QFE card (non-sparc).  It takes the base mac from
> the first interface and increments the mac address for the
> other interfaces.
> 
> It still preserves the 'macaddr' parameter so if desired, it
> can still be used.
> 
> Before patching:
> 
> eth0      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
> eth1      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
> eth2      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
> eth3      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
> 
> After patching:
> 
> eth0      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
> eth1      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BC
> eth2      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BD
> eth3      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BE

Could you please post this to netdev@vger.kernel.org which is
where networking patches should go?

Thank you.
