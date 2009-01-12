Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZALMDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZALMDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZALMD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:03:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752187AbZALMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:03:26 -0500
Date: Mon, 12 Jan 2009 23:02:57 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090112120257.GA5697@gondor.apana.org.au>
References: <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125217.GA26235@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:52:17PM +1100, Herbert Xu wrote:
> On Wed, Jan 07, 2009 at 12:49:46PM +0000, Jarek Poplawski wrote:
> > 
> > Hmm... in any case: take 3
> 
> Yes this should fix the corruption but it kind of defeats the
> purpose of splice by copying the data.

However, as we don't have a better fix yet, we probably should
take Jarek's patch for now since data corruption is bad.

This is a very hard problem, so in the end the only viable solution
might be to get the drivers to switch to using page frags, like
the Intel page split method.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
