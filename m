Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbXEIMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbXEIMNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXEIMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:13:46 -0400
Received: from ozlabs.org ([203.10.76.45]:36155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbXEIMNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:13:45 -0400
Subject: Re: [patch 7/9] lguest: the net driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, ak@suse.de, jeff@garzik.org,
       jmorris@namei.org, netdev@vger.kernel.org
In-Reply-To: <20070509120030.GA12853@gondor.apana.org.au>
References: <E1HljA6-0001E4-00@gondolin.me.apana.org.au>
	 <1178711725.7286.82.camel@localhost.localdomain>
	 <20070509120030.GA12853@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 09 May 2007 22:13:28 +1000
Message-Id: <1178712808.7286.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 22:00 +1000, Herbert Xu wrote:
> Hi Rusty:
> 
> On Wed, May 09, 2007 at 09:55:25PM +1000, Rusty Russell wrote:
> > 
> > 	NO_CSUM because it really doesn't need a checksum.  The
> > LGUEST_NET_F_NOCSUM is only set for local inter-guest networking.  If
> > some guest were to route the packets outside the machine, this would be
> > an issue, though ("don't do that").
> 
> While I can see that this is good in keeping things simple, I think
> it's something that you want to be able to support since the user
> may wish to setup a guest as a firewall appliance which would involve
> passing packets from another guest to the outside world.

Indeed, you understand the tradeoff.  The example launcher could have an
option not to set the LGUEST_NET_F_NOCSUM in this case.

That said, one significant purpose of lguest is to serve as an example
of how to do things.  So if you feel really strongly that there's a
Right Way, we could look at the patch...

Thanks,
Rusty.


