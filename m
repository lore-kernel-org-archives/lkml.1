Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbYKRHBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbYKRHBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYKRHA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:00:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34822
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbYKRHAz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:00:55 -0500
Date: Mon, 17 Nov 2008 23:00:55 -0800 (PST)
Message-Id: <20081117.230055.193685274.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: mingo@elte.hu, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <49225432.6050607@cosmosbay.com>
References: <20081117212657.GH12020@elte.hu>
	<20081117.211645.193706814.davem@davemloft.net>
	<49225432.6050607@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 18 Nov 2008 06:35:46 +0100

> David Miller a écrit :
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Mon, 17 Nov 2008 22:26:57 +0100
> > 
> >> eth->h_proto access.
> > Yes, this is the first time a packet is touched on receive.
> 
> Well, not exactly, since we do a 
> 
> if (is_multicast_ether_addr(eth->h_dest)) {
> ...}
> 
> and one of the
> 	compare_ether_addr(eth->h_dest, {dev->dev_addr | dev->broadcast})
> 
> probably its a profiling effect...

True.

