Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbXJ3AJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbXJ3AJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXJ3AJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:09:30 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1307 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873AbXJ3AJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:09:29 -0400
Date: Tue, 30 Oct 2007 08:08:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing loops
Message-ID: <20071030000827.GA9037@gondor.apana.org.au>
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au> <20071029201627.GD7499@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029201627.GD7499@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:16:27PM +0100, Jens Axboe wrote:
> On Fri, Oct 26 2007, Herbert Xu wrote:
> > [CRYPTO] tcrypt: Move sg_init_table out of timing loops
> > 
> > This patch moves the sg_init_table out of the timing loops for hash
> > algorithms so that it doesn't impact on the speed test results.
> 
> Wouldn't it be better to just make sg_init_one() call sg_init_table?

This looks fine to me although I think it's orthogonal to the
patch you were quoting :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
