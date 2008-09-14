Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYINVfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYINVfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 17:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYINVfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 17:35:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59880 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYINVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 17:35:31 -0400
Date: Sun, 14 Sep 2008 14:35:24 -0700
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.27
Message-ID: <20080914213524.GA3590@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20080813121620.GA23142@gondor.apana.org.au> <20080822151102.GA678@gondor.apana.org.au> <20080908043323.GA15259@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908043323.GA15259@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a security problem in the talitos driver which
was added after 2.6.26.  When triggered talitos may cause two
IPsec packets to be generated with the same IV which weakens
the protection offered by encryption.  This only affects talitos
users obviously.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Kim Phillips (1):
      crypto: talitos - Avoid consecutive packets going out with same IV

 drivers/crypto/talitos.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
