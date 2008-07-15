Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYGOPxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYGOPxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYGOPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:53:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57893 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753764AbYGOPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:53:14 -0400
Date: Tue, 15 Jul 2008 23:53:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: Crypto Fixes for 2.6.26
Message-ID: <20080715155308.GA7263@gondor.apana.org.au>
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

This push reverts the CTR-based PRNG as it clearly isn't able
to pass Ingo's random config hurdle.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      Revert crypto: prng - Deterministic CPRNG

 crypto/Kconfig  |    9 -
 crypto/Makefile |    2 
 crypto/prng.c   |  410 --------------------------------------------------------
 crypto/prng.h   |   27 ---
 4 files changed, 1 insertion(+), 447 deletions(-)


Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
