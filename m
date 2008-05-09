Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbYEINX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbYEINX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbYEINXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:23:50 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35206 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755595AbYEINXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:23:49 -0400
Date: Fri, 9 May 2008 21:23:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.26
Message-ID: <20080509132343.GA12979@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501102812.GA7151@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a bug in HMAC that has been exposed by recent
changes in tcrypt.  However, it may well affect other crypto
users that put the key in places where virt_to_page doesn't work.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      [CRYPTO] hmac: Avoid calling virt_to_page on key

 crypto/hmac.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
