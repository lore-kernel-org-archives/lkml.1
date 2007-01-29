Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXA2HWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXA2HWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 02:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXA2HWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 02:22:48 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3956 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933181AbXA2HWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 02:22:47 -0500
Date: Mon, 29 Jan 2007 18:21:46 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm1
Message-ID: <20070129072146.GA30334@gondor.apana.org.au>
References: <45BD2424.7020604@googlemail.com> <E1HBOtk-0007dS-00@gondolin.me.apana.org.au> <20070129052929.GA29456@gondor.apana.org.au> <20070128224312.50f89360.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128224312.50f89360.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 10:43:12PM -0800, Andrew Morton wrote:
>
> > IIRC Ingo had made fixes for the networking stack in his rt tree since
> > the networking code assumes in lots of places that rcu_read_lock
> > disables preemption.
> 
> oh.  We'd better find those fixes then.  I wonder what other code made that
> (rather hacky) assumption?  I guess we have enough debug stuff in there to
> find out..

Actually, maybe I was confusing this with the fixes Ingo had for
local_bh_disable vs. preemption in the -rt tree.  Ingo, do you
have preemptible RCU support in your -rt tree and if so did you
have to fix the networking stack to behave correctly with it?

It could also be that the fixes for local_bh_disable also masked
any problems that would trigger under preemptible RCU.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
