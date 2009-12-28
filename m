Return-Path: <linux-kernel-owner+w=401wt.eu-S1751683AbZL1Ukp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbZL1Ukp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZL1Ukp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:40:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35188 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbZL1Uko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:40:44 -0500
Date: Mon, 28 Dec 2009 21:40:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091228204003.GH4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box> <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box> <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box> <1262030653.15368.37.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262030653.15368.37.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 09:04:13PM +0100, Stefani Seibold wrote:
> The interface hasn't been changed, only the implementation. So it should

Ok I guess I was still thinking of your earlier version which
had a new interface.

> It is exactly the same behavior as the old kfifo API, so no user relies
> on the new "kfifo_in atomic" feature. The only user is you. And it is

That's not established. They might be just broken.

OK i checked and they all use power-of-two currently so by sheer
luck (I doubt it is by design) they work. Still I think that
open deathtrap should be fixed.

I also don't understand how that patch "breaks your future work"
Please elaborate on that.

-Andi

P.S.: I must say you make it really hard to use kfifos.

-- 
ak@linux.intel.com -- Speaking for myself only.
