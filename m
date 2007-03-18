Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXCRU2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXCRU2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXCRU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:28:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:19298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbXCRU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:28:29 -0400
Date: Sun, 18 Mar 2007 22:29:10 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318202910.GE11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318195355.GB11078@mellanox.co.il>
	<20070318201826.GB27004@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318201826.GB27004@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > It should be cleared and we should be sure it will not be destroyed
> > > before quiescent state.
> > 
> > I'm confused. didn't you say dst_ifdown is called after quiescent state?
> 
> Quiescent state should happen after dst->neighbour is invalidated.
> And this implies that all the users of dst->neighbour check validity
> after dereference and do not use it after quiescent state.
> 
> 
> > This does not sound like something that's likely to be accepted in 2.6.21, right?
> > 
> > Any simpler ideas?
> 
> Well, if inifiniband destructor really needs to take that lock... no.
> Right now I do not see.

OK then.
If you post some patches I'll test them.

-- 
MST
