Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZJTH0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZJTH0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZJTH0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:26:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39318 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbZJTH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:26:54 -0400
Date: Tue, 20 Oct 2009 16:26:50 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.32
Message-ID: <20091020072650.GA6621@gondor.apana.org.au>
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

> This push fixes a regression in the padlock-sha driver that causes
> faults on 32-bit VIA processors.

I've just added another regression fix that's specific to the
Intel AESNI instruction where the FPU test was reversed.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: padlock-sha - Fix stack alignment

Huang Ying (1):
      crypto: aesni-intel - Fix irq_fpu_usable usage

 arch/x86/crypto/aesni-intel_glue.c |   10 +++++-----
 drivers/crypto/padlock-sha.c       |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 7 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
