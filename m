Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIXEyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIXEyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYIXEym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:54:42 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50973 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbYIXEyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:54:41 -0400
Date: Wed, 24 Sep 2008 12:54:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, dwalker@mvista.com,
       arjan@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
Message-ID: <20080924045404.GA6010@gondor.apana.org.au>
References: <20080920.125949.193703969.davem@davemloft.net> <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au> <20080920.235727.247411045.davem@davemloft.net> <Pine.LNX.4.64.0809221329140.1034@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0809221329140.1034@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 01:36:24PM +0300, Ilpo Järvinen wrote:
> On Sat, 20 Sep 2008, David Miller wrote:
> 
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Date: Sun, 21 Sep 2008 15:05:45 +0900
> > 
> > > Of course, we need to balance any effort spent on this with the
> > > likelihood that hardware improvements will soon make this obsolete
> > > (for IPsec anyway).
> > 
> > True, but old hardware will always exist.
> 
> ...Also, producing buggy hardware will not suddently just vanish either 
> ("can you please turn of ipsec offloading and see if you can still
> reproduce" :-))...

That's fine.  If your AES hardware is buggy you just fall back
to using the software version.

In fact if this was done through the crypto API it would even
happen automatically.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
