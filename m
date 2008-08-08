Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYHHNgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYHHNgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYHHNfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:35:53 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59926 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752352AbYHHNfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:35:52 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: drepper@gmail.com (Ulrich Drepper)
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Cc: austin_zhang@linux.intel.com, herbert@gondor.apana.org.au, bunk@kernel.org,
       dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
Date: Fri, 08 Aug 2008 21:35:30 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@gmail.com> wrote:
>
> I think you want to use
> 
>  #define SCALE_F sizeof(unsigned long)

Yeah in general that's what we should do.  However, this driver
is specific to Intel x86 CPUs.

However if someone were to post a patch to do this I would happily
apply it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
