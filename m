Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZBWJys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZBWJys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZBWJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:54:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:50161 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbZBWJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:54:38 -0500
Date: Mon, 23 Feb 2009 17:54:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.29
Message-ID: <20090223095428.GA11076@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20090115044020.GA29891@gondor.apana.org.au> <20090127061546.GA27962@gondor.apana.org.au> <20090209033924.GA31250@gondor.apana.org.au> <20090217121252.GA22812@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217121252.GA22812@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a bug in /proc/crypto where it may display a
bogus digest size for ahash algorithms.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Lee Nipper (1):
      crypto: ahash - Fix digest size in /proc/crypto

 crypto/ahash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
