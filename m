Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYK3Ecm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYK3Ecm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 23:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYK3Ecb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 23:32:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:59657 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbYK3Eca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 23:32:30 -0500
Date: Sun, 30 Nov 2008 12:32:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christophe Saout <christophe@saout.de>, dm-devel@redhat.com,
       linux-crypto@vger.kernel.org
Subject: Re: next-20081125: crypto hard disk gets unaccessable
Message-ID: <20081130043215.GA10310@gondor.apana.org.au>
References: <20081128063355.GA4700@denkbrett.schottelius.org> <20081129192939.925275f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129192939.925275f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 07:29:39PM -0800, Andrew Morton wrote:
>
> > [69186.618377] RAX: 00000000fffffff0 RBX: b6e3880000000010 RCX: 0000000000000000
> > [69186.618382] RDX: 0000000000000010 RSI: b6e3880000000000 RDI: ffff88007a3da4e0

> > [69186.618611] Code: 08 48 89 51 08 48 89 0a 48 b9 00 01 10 00 00 00 ad de 48 ba 00 02 20 00 00 00 ad de 48 89 08 48 89 50 08 c3 41 89 d0 31 c9 eb 0e <8b> 04 0e 41 83 e8 04 31 04 0f 48 83 c1 04 41 83 f8 03 77 ec 41 

	8b 04 0e                mov    (%rsi,%rcx,1),%eax

So we were fed a bogus pointer by the caller.
 
> I assume that 2.6.28-rc6 is OK?

Nothing has changed in the crypto ciphers lately.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
