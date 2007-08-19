Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXHSHXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXHSHXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXHSHXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:23:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXHSHXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:23:38 -0400
Date: Sun, 19 Aug 2007 00:23:37 -0700 (PDT)
Message-Id: <20070819.002337.06589160.davem@davemloft.net>
To: sean.hefty@intel.com
Cc: rdreier@cisco.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP
 portsfrom the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com>
References: <adatzqxwh56.fsf@cisco.com>
	<20070817.234405.66176298.davem@davemloft.net>
	<000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Sean Hefty" <sean.hefty@intel.com>
Date: Sun, 19 Aug 2007 00:01:07 -0700

> Millions of Infiniband ports are in operation today.  Over 25% of the top 500
> supercomputers use Infiniband.  The formation of the OpenFabrics Alliance was
> pushed and has been continuously funded by an RDMA customer - the US National
> Labs.  RDMA technologies are backed by Cisco, IBM, Intel, QLogic, Sun, Voltaire,
> Mellanox, NetApp, AMD, Dell, HP, Oracle, Unisys, Emulex, Hitachi, NEC, Fujitsu,
> LSI, SGI, Sandia, and at least two dozen other companies.  IDC expects
> Infiniband adapter revenue to triple between 2006 and 2011, and switch revenue
> to increase six-fold (combined revenues of 1 billion).

Scale these numbers with reality and usage.

These vendors pour in huge amounts of money into a relatively small
number of extremely large cluster installations.  Besides the folks
doing nuke and whole-earth simulations at some government lab, nobody
cares.  And part of the investment is not being done wholly for smart
economic reasons, but also largely publicity purposes.

So present your great Infiniband numbers with that being admitted up
front, ok?

It's relevance to Linux as a general purpose operating system that
should be "good enough" for %99 of the world is close to NIL.

People have been pouring tons of money and research into doing stupid
things to make clusters go fast, and in such a way that make zero
sense for general purpose operating systems, for ages.  RDMA is just
one such example.

BTW, I find it ironic that you mention memory bandwidth as a retort,
as Roland's favorite stateless offload devil, TSO, deals explicity
with lowering the per-packet BUS bandwidth usage of TCP.  LRO
offloading does likewise.
