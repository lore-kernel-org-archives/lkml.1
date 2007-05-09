Return-Path: <linux-kernel-owner+w=401wt.eu-S969236AbXEIBuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969236AbXEIBuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967446AbXEIBu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:50:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4074 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967350AbXEIBuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:50:24 -0400
Date: Wed, 9 May 2007 11:49:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
Message-ID: <20070509014904.GA31072@gondor.apana.org.au>
References: <20070504232051.411946839@goop.org> <20070504232121.492190579@goop.org> <20070505091624.GA8890@infradead.org> <463C56D3.8060609@goop.org> <20070505102305.GA12771@gondor.apana.org.au> <463F95C3.60407@goop.org> <20070508121322.GA21647@gondor.apana.org.au> <4640DB55.1050608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4640DB55.1050608@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:19:33PM -0700, Jeremy Fitzhardinge wrote:
> 
> Subject: xen: go back to using normal network stack carriers
> 
> This effectively reverts xen-unstable change
> 14280:42b29f084c31. Herbert has changed the behaviour of the core
> networking to not delay an initial down->up transition, and so the
> timing concern has been solved.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>

Looks good to me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
