Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbXJ3FvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbXJ3FvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJ3FvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:51:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27368 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbXJ3FvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:51:00 -0400
Date: Tue, 30 Oct 2007 06:50:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing loops
Message-ID: <20071030055056.GG7499@kernel.dk>
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au> <20071029201627.GD7499@kernel.dk> <20071030000827.GA9037@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030000827.GA9037@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Herbert Xu wrote:
> On Mon, Oct 29, 2007 at 09:16:27PM +0100, Jens Axboe wrote:
> > On Fri, Oct 26 2007, Herbert Xu wrote:
> > > [CRYPTO] tcrypt: Move sg_init_table out of timing loops
> > > 
> > > This patch moves the sg_init_table out of the timing loops for hash
> > > algorithms so that it doesn't impact on the speed test results.
> > 
> > Wouldn't it be better to just make sg_init_one() call sg_init_table?
> 
> This looks fine to me although I think it's orthogonal to the
> patch you were quoting :)

How so? The reason you changed it to sg_init_table() + sg_set_buf() is
exactly because sg_init_one() didn't properly init the entry (as they
name promised).

-- 
Jens Axboe

