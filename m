Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYLAE6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYLAE6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYLAE6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:58:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60962 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbYLAE6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:58:06 -0500
Date: Mon, 1 Dec 2008 12:57:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <mbroz@redhat.com>
Cc: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       device-mapper development <dm-devel@redhat.com>,
       Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>, Herbert@redhat.com,
       linux-next@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [dm-devel] Re: next-20081125: crypto hard disk gets
	unaccessable
Message-ID: <20081201045749.GA18292@gondor.apana.org.au>
References: <20081128063355.GA4700@denkbrett.schottelius.org> <20081129192939.925275f0.akpm@linux-foundation.org> <49332CC6.4080606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49332CC6.4080606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 01:16:06AM +0100, Milan Broz wrote:
>
> > [69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
> > [69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
> > [69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkcipher]
> > [69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
> > [69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
> > [69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]
> 
> I assume that crypto run here synchronously (not through asynchronous completion callback).
> 
> Herbert - is my guess ok? (The asynchronous handling in dm-crypt was the only part changed recently.)
> (And I think that except crypto hw nobody uses asynchronous mode yet by default.)

Yes that's definitely synchronous.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
