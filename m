Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbYLXXrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbYLXXrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 18:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYLXXrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 18:47:36 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbYLXXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 18:47:35 -0500
Date: Thu, 25 Dec 2008 10:47:29 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.28
Message-ID: <20081224234728.GA1224@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au> <20081210123524.GA11696@gondor.apana.org.au> <20081224222045.GA488@gondor.apana.org.au> <alpine.LFD.2.00.0812241432130.3535@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812241432130.3535@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 02:32:28PM -0800, Linus Torvalds wrote:
>
> Can't we just get rid of that stupid testing infrastructure, or make it a 
> module-only thing? I refuse to pull a 1000+ line patch for something like 
> this, especially this late. It's insane.

Well the testing infrastructure simply flagged a problem that
was always there.  Previously if something used AES early enough
it would silently give the wrong result instead.  Of course this
is fairly unlikely since the number of AES users is limited.

Now that the testing infrastructure is available, we could just
do nothing for 2.6.28 since the C AES version will always be there
and work correctly.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
