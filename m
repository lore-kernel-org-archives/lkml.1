Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0AUKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0AUKWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528Ab0AUKWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:22:42 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58062 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0AUKWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:22:40 -0500
Date: Thu, 21 Jan 2010 11:22:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9] net/sctp: Eliminate useless code
In-Reply-To: <20100120.150343.236848237.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1001211121500.13529@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657570.28745@ask.diku.dk> <4B574702.4040602@hp.com>
 <20100120.150343.236848237.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, David Miller wrote:

> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Wed, 20 Jan 2010 13:10:10 -0500
> 
> > 
> > 
> > Julia Lawall wrote:
> >> From: Julia Lawall <julia@diku.dk>
> >> 
> >> The variable newinet is initialized twice to the same (side effect-free)
> >> expression.  Drop one initialization.
> >> 
> >> A simplified version of the semantic match that finds this problem is:
> >> (http://coccinelle.lip6.fr/)
> >> 
> >> // <smpl>
> >> @forall@
> >> idexpression *x;
> >> identifier f!=ERR_PTR;
> >> @@
> >> 
> >> x = f(...)
> >> ... when != x
> >> (
> >> x = f(...,<+...x...+>,...)
> >> |
> >> * x = f(...)
> >> )
> >> // </smpl>
> >> 
> >> Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> Julia,  just like patch #3 this one had the missing final
> line of the patch corrupting it, so you'll need to resubmit.

I have generated and sent it again, but this time I don't see the problem.  
If there is still a problem, perhaps you could send me back the patch you 
received?

thanks,
julia
