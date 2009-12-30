Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZL3CNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZL3CNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 21:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL3CNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 21:13:01 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:56493 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbZL3CNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 21:13:00 -0500
Date: Wed, 30 Dec 2009 10:12:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.33
Message-ID: <20091230021253.GA17067@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020065442.GA5947@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a regression in the hardware RNG core introduced
by the recent API change.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      hwrng: core - Fix double unlock in rng_dev_read

 drivers/char/hw_random/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
