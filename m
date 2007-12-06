Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXLFWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXLFWIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLFWH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:07:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXLFWH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:07:56 -0500
Date: Thu, 6 Dec 2007 23:07:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Renzo Davoli <renzo@cs.unibo.it>,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206220754.GF20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47586E7F.1020903@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 03:49:51PM -0600, Chris Friesen wrote:
> Andi Kleen wrote:
> >>Latency was very 
> >>important, so we ended up doing essentially a multicast unix socket 
> >>rather than taking the extra penalty for UDP multicast.
> >
> >
> >What extra penalty? Local UDP shouldn't be much more expensive than Unix.
> 
> On a 1.4GHz P4 I measured a 44% increase in latency between a unix 
> datagram and a UDP datagram.

That's weird.

> 
> For UDP it has to go down the udp stack, then the ip stack, then through 

UDP doesn't really have much stack. IP is also very little assuming
cached route (connect called first) 

I would expect the copies to dominate in both cases.

-Andi
