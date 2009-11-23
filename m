Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZKWMFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZKWMFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbZKWMFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:05:17 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51783 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757238AbZKWMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:05:16 -0500
Date: Mon, 23 Nov 2009 20:05:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.32
Message-ID: <20091123120514.GA6738@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091020072650.GA6621@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020072650.GA6621@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a crash in the gcm driver when used in conjunction
with an asynchronous cipher (e.g., aesni-intel).

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Huang Ying (1):
      crypto: gcm - fix another complete call in complete fuction

 crypto/gcm.c |  107 +++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 73 insertions(+), 34 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
