Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbYBLQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbYBLQuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbYBLQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:50:36 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:46155 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYBLQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:50:34 -0500
Message-ID: <47B1CD75.6070505@panasas.com>
Date: Tue, 12 Feb 2008 18:46:45 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>	<20080212044314.GA4888@kroah.com>	<20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org>
In-Reply-To: <47B1CB08.4020101@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 12, 2008, 18:36 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> David Miller wrote:
>> This is why, with the networking, we've just tossed all of the network
>> driver stuff in there too.  I can rebase freely, remove changesets,
>> rework them, etc. and this causes a very low amount of pain for Jeff
>> Garzik and John Linville.
> 
> 
> s/very low/not low/
> 
> Rebasing is always a pain, and John and I both agreed the other day that 
> you do it too often.
> 
> I've complained about this before, too...  but figured this was just 
> another thing I was getting ignored on, and so life moved on.  But don't 
> try to sell rebasing as "low pain".
> 
> Rebasing makes the history all nice and pretty, but by totalling 
> flattening the history, trashing all the commit ids (and rewriting 
> associated metadata), you create obvious downstream problems.

FWIW, when I rebase branches in my tree that others depend on
I keep tags on the old heads for reference.  Once the work-in-progress
is done (e.g. tree pulled upstream) the reference tags can be cleaned
up and the tree can be pruned.

Benny

> 
> Rebasing is  low impact only if you don't have git downstream people. 
> Otherwise, you're just treating it as a useful quilt clone, really.
> 
> 	Jeff
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

