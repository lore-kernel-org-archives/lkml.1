Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYHVPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYHVPLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYHVPLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:11:10 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56449 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbYHVPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:11:09 -0400
Date: Sat, 23 Aug 2008 01:11:02 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.27
Message-ID: <20080822151102.GA678@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20080813121620.GA23142@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813121620.GA23142@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a serious bug that was introduced in 2.6.25.  It
causes IPsec users that employ MAC algorithms with a length longer
than 16 bytes to crash.  The standard SHA1 algorithm is exactly 16
bytes long, so this only applies to those using longer algorithms
such as SHA256.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: authenc - Avoid using clobbered request pointer

 crypto/authenc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
