Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZALVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZALVNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZALVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:13:25 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38585 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbZALVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:13:24 -0500
Date: Tue, 13 Jan 2009 08:12:37 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090112211237.GB11134@gondor.apana.org.au>
References: <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au> <20090112120257.GA5697@gondor.apana.org.au> <20090112131517.GD5901@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112131517.GD5901@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 01:15:17PM +0000, Jarek Poplawski wrote:
>
> I've wondered if something like this could work as a temporary hack?

No we should fix it in skb_splice_bits because the corruption
can affect other terminations as well if a delay occurs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
