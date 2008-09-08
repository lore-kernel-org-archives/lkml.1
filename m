Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYIHFaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYIHFaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 01:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYIHFaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 01:30:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40430 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbYIHFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 01:30:07 -0400
Date: Mon, 8 Sep 2008 14:33:23 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.27
Message-ID: <20080908043323.GA15259@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20080813121620.GA23142@gondor.apana.org.au> <20080822151102.GA678@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822151102.GA678@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push reverts a patch that caused a regression after 2.6.26.
It broke the Camellia algorithm which may be used by IPsec or for
encrypted disks.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      Revert "crypto: camellia - Use kernel-provided bitops, unaligned access helpers"

 crypto/camellia.c |   84 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
