Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520Ab0AHDT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0AHDT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 22:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475Ab0AHDT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 22:19:57 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52444 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408Ab0AHDT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 22:19:56 -0500
Date: Fri, 8 Jan 2010 14:19:33 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Roel Kluin <roel.kluin@gmail.com>, "David S. Miller" <davem@davemloft.net>,
       linux-crypto@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] crypto/geode_aes: access .cip instead of .blk in
	cipher mode
Message-ID: <20100108031933.GA18599@gondor.apana.org.au>
References: <4B1D02F7.2020505@gmail.com> <20091207134012.GA21388@Chamillionaire.breakpoint.cc> <4B1D0DC9.5000908@gmail.com> <20091211150349.GA736@gondor.apana.org.au> <20100106180736.GA9625@Chamillionaire.breakpoint.cc> <20100107005028.GA32421@gondor.apana.org.au> <20100107211702.GB20258@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107211702.GB20258@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 10:17:02PM +0100, Sebastian Andrzej Siewior wrote:
> >From caa5c9a662be92aa79b2ef1d14a509391cfa9254 Mon Sep 17 00:00:00 2001
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Thu, 7 Jan 2010 22:00:26 +0100
> 
> The fallback code in cipher mode touch the union fallback.blk instead
> of fallback.cip. This is wrong because we use the cipher and not the
> blockcipher. This did not show any side effects yet because both types /
> structs contain the same element right now.
> 
> [bigeasy@breakpoint: different commit message, split the patch in two]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

All applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
