Return-Path: <linux-kernel-owner+w=401wt.eu-S1764737AbXGKNJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764737AbXGKNJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbXGKNI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:08:57 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2045 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757558AbXGKNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:08:57 -0400
Date: Wed, 11 Jul 2007 21:08:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Crypto Update for 2.6.23
Message-ID: <20070711130849.GA10494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

iHere is the crypto update for 2.6.23:

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

Summary:

* Small fixes and clean-up's.


Herbert Xu (2):
      [CRYPTO] api: Wake up all waiters when larval completes
      [CRYPTO] cipher: Remove obsolete fields from cipher_tfm

Jan Engelhardt (1):
      [CRYPTO] Kconfig: Use menuconfig objects

Sebastian Siewior (2):
      [CRYPTO] api: Handle unaligned keys in setkey
      [CRYPTO] api: Allow ablkcipher with no queues

 crypto/Kconfig         |    6 +-----
 crypto/ablkcipher.c    |   31 +++++++++++++++++++++++++++++--
 crypto/algapi.c        |    4 ++--
 crypto/api.c           |    2 +-
 crypto/blkcipher.c     |   25 +++++++++++++++++++++++++
 crypto/cipher.c        |   33 ++++++++++++++++++++++++++++++---
 crypto/hash.c          |   38 +++++++++++++++++++++++++++++++++++++-
 include/linux/crypto.h |   20 --------------------
 8 files changed, 125 insertions(+), 34 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
