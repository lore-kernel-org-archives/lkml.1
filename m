Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYGIAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYGIAh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 20:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYGIAht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 20:37:49 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38175 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbYGIAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 20:37:48 -0400
Date: Wed, 9 Jul 2008 08:37:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.26
Message-ID: <20080709003741.GA32340@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080509132343.GA12979@gondor.apana.org.au> <20080602080512.GA22059@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602080512.GA22059@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a memory leak in the crypto testing module.  Since
this module is designed to be used repeatedly, the leak could add
up quickly.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Darren Jenkins (1):
      crypto: tcrypt - Fix memory leak in test_cipher

 crypto/tcrypt.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
