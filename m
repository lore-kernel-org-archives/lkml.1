Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbZAOEkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbZAOEkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZAOEkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:40:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48371 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbZAOEk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:40:29 -0500
Date: Thu, 15 Jan 2009 15:40:20 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.29
Message-ID: <20090115044020.GA29891@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727063659.GA936@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a crash in authenc that may occur if null encryption
is used (a rare configuration).

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: authenc - Fix zero-length IV crash

 crypto/authenc.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
