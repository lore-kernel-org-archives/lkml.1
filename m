Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXDNTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXDNTe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXDNTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:34:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4324 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753196AbXDNTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:34:27 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: francis.moro@gmail.com (Francis Moreau)
Subject: Re: [CRYPTO] is it really optimized ?
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
Date: Sun, 15 Apr 2007 05:34:19 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
> 
> hmm yes indeed it should do the job, but I don't see how you do that.
> For example, let say I want to use "aes-foo" with eCryptfs. I can give
> a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
> a aes cipher it will pass "aes" name and since "aes-foo" has a higher
> priority then the cypto core will return "aes-foo" cipher, right ? But
> in this scheme, eCryptfs has not a higher priority than other kernel
> users. How can I prevent others to use "aes-foo" ?

You would assign "aes-foo" a lower priority and then tell eCryptfs to
use "aes-foo" instead of "aes".

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
