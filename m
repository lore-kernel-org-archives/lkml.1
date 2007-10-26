Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXJZRA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXJZRA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764232AbXJZQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:59:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29609 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764051AbXJZQ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:59:37 -0400
Date: Fri, 26 Oct 2007 18:59:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
Message-ID: <20071026165926.GA8875@kernel.dk>
References: <4720F775.8030702@hp.com> <20071025.184654.191409554.davem@davemloft.net> <4721EF03.1080605@hp.com> <20071026135203.GA13126@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026135203.GA13126@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26 2007, Herbert Xu wrote:
> On Fri, Oct 26, 2007 at 09:43:31AM -0400, Vlad Yasevich wrote:
> >
> > Got reported to me because SCTP kept breaking.  Wasn't sure which
> > way to send it.
> > 
> > As long as it's somewhere, I am happy.
> 
> I'm happy too :)
> 
> Dave has kindly fixed the IPsec stack to initalise the tables
> properly.  I'm currently in the process of fixing the rest of
> the crypto users to initalise the tables properly.
> 
> Jens, could you please do a similar run for the rest of the
> kernel?

Yeah, I've already done large parts of it, will continue to make sure
everything gets seen.

-- 
Jens Axboe

