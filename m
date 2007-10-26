Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXJZOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXJZOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXJZOIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:08:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2440 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbXJZOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:08:11 -0400
Date: Fri, 26 Oct 2007 21:52:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
Message-ID: <20071026135203.GA13126@gondor.apana.org.au>
References: <4720F775.8030702@hp.com> <20071025.184654.191409554.davem@davemloft.net> <4721EF03.1080605@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4721EF03.1080605@hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 09:43:31AM -0400, Vlad Yasevich wrote:
>
> Got reported to me because SCTP kept breaking.  Wasn't sure which
> way to send it.
> 
> As long as it's somewhere, I am happy.

I'm happy too :)

Dave has kindly fixed the IPsec stack to initalise the tables
properly.  I'm currently in the process of fixing the rest of
the crypto users to initalise the tables properly.

Jens, could you please do a similar run for the rest of the
kernel?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
