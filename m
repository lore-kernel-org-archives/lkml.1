Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0CEHKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:10:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34001 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882Ab0CEHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:10:50 -0500
Date: Fri, 5 Mar 2010 15:10:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.34
Message-ID: <20100305071043.GA3548@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100201195204.GA6953@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes three regressions and an older bug:

* The new padata system crashes during init on certain configurations.
* Fixed hmac(md5) broken by recent md5 update.
* Fixed authenc broken by ahash conversion.
* Fixed handling of unaligned buffers in hash API.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: md5 - Set statesize

Steffen Klassert (3):
      crypto: authenc - Use correct ahash complete functions
      crypto: authenc - Move saved IV in front of the ablkcipher request
      padata: Allocate the cpumask for the padata instance

Szilveszter Ördög (1):
      crypto: hash - Fix handling of unaligned buffers

 crypto/ahash.c   |    1 -
 crypto/authenc.c |   27 +++++++++++++++------------
 crypto/md5.c     |    1 +
 kernel/padata.c  |    8 +++++++-
 4 files changed, 23 insertions(+), 14 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
