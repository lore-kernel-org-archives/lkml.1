Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYGWWaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYGWWaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYGWWaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:30:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYGWWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:30:00 -0400
Date: Wed, 23 Jul 2008 15:30:00 -0700 (PDT)
Message-Id: <20080723.153000.172383135.davem@davemloft.net>
To: wangchen@cn.fujitsu.com
Cc: markus@trippelsdorf.de, ag@alessandroguido.name,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] skge: resolve tx multiqueue bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <48874C6A.1020604@cn.fujitsu.com>
References: <20080723101827.GA2236@gentoox2.trippelsdorf.de>
	<20080723140347.GA2245@gentoox2.trippelsdorf.de>
	<48874C6A.1020604@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Chen <wangchen@cn.fujitsu.com>
Date: Wed, 23 Jul 2008 23:21:14 +0800

> Markus Trippelsdorf said the following on 2008-7-23 22:03:
> > On Wed, Jul 23, 2008 at 12:18:27PM +0200, Markus Trippelsdorf wrote:
> >> On Wed, Jul 23, 2008 at 04:50:13PM +0800, Wang Chen wrote:
> >>> Markus Trippelsdorf said the following on 2008-7-23 13:40:
> >>>> On Tue, Jul 22, 2008 at 11:54:26AM +0200, Alessandro Guido wrote:
> >>>>> Got a WARNING this morning (2.6.26-05752-g93ded9b) and I think it's related.
> >>>> Same thing here (latest git):
> >>>>
> >>>> skge eth1: enabling interface
> >>>> skge eth1: disabling interface
> >>>> ------------[ cut here ]------------
> >>>> WARNING: at net/core/dev.c:1344 __netif_schedule+0x24/0x6d()
> >>>> Pid: 1904, comm: ip Not tainted 2.6.26-06077-gc010b2f #33
> >>>>  [<ffffffff8020b3eb>] system_call_after_swapgs+0x7b/0x80
> >> ...
> >>>> ---[ end trace 92936ef183e09876 ]---
> >>>> skge eth1: enabling interface
> >>>> skge eth1: Link is up at 100 Mbps, full duplex, flow control both
> >>>>
> >>> Markus, please try this.
> >>>
> >>> - Add netif_start_queue() in ->open()
> >>> - netif_carrier_*() is enough, remove netif_*_queue()
> >> Unfortunately, your patch does not fix this. I still get the same warning.
> >>
> > 
> > This patch works for me:
> 
> Your patch works for me too. So I think it's better than mine. :)
> 
> Tested-by: Wang Chen <wangchen@cn.fujitsu.com>
> 
> Dave, since Markus and me tested this patch, would you please apply it?

I can't, it's whitespace damaged.  All the tabs are turned into spaces,
also there is no signoff from Markus.

