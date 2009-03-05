Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZCEFVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZCEFVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 00:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZCEFVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 00:21:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbZCEFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 00:21:23 -0500
Date: Wed, 04 Mar 2009 21:21:08 -0800 (PST)
Message-Id: <20090304.212108.19011543.davem@davemloft.net>
To: bart@jukie.net
Cc: kaber@trash.net, greearb@candelatech.com, shemminger@vyatta.com,
       dada1@cosmosbay.com, frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090305045442.GF5959@jukie.net>
References: <49AE69DD.80802@trash.net>
	<20090304.195328.106253933.davem@davemloft.net>
	<20090305045442.GF5959@jukie.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Trojanowski <bart@jukie.net>
Date: Wed, 4 Mar 2009 23:54:42 -0500

> David,
> 
> * David Miller <davem@davemloft.net> [090304 22:53]:
> > vlan: Fix vlan-in-vlan crashes.
> > 
> > As analyzed by Patrick McHardy, vlan needs to reset it's
> > netdev_ops pointer in it's ->init() function but this
> > leaves the compat method pointers stale.
> > 
> > Add a netdev_resync_ops() and call it from the vlan code.
> <snip>
> >  include/linux/netdevice.h |    1 +
> >  net/8021q/vlan_dev.c      |    1 +
> >  net/core/dev.c            |   54 +++++++++++++++++++++++++++-----------------
> >  3 files changed, 35 insertions(+), 21 deletions(-)
> 
> I tried this patch onto v2.6.29-rc7-3-g559595a, but I still get a crash.
> I assume that this worked for you, so I am not putting much faith in my
> results at this late hour.  I'll confirm tomorrow morning that it's not
> something else.

I didn't test, so you the bug must be a different problem or
my patch is wrong :)

