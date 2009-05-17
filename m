Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZEQW2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZEQW2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZEQW2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:28:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38311 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbZEQW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:28:24 -0400
Date: Mon, 18 May 2009 08:28:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.30
Message-ID: <20090517222818.GA14969@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090402061413.GA28925@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402061413.GA28925@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a few bugs/regressions:

* Check firmware before claiming algorithm support in ixp4xx.
* Fix autoloading of optimised AES modules.
* Fix eseqiv IV generation.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Christian Hohnstaedt (1):
      crypto: ixp4xx - check firmware for crypto support

Herbert Xu (2):
      crypto: api - Fix algorithm module auto-loading
      crypto: padlock - Revert aes-all alias to aes

Steffen Klassert (1):
      crypto: eseqiv - Fix IV generation for sync algorithms

 crypto/api.c                   |    3 ++-
 crypto/eseqiv.c                |    3 ++-
 drivers/crypto/ixp4xx_crypto.c |   33 ++++++++++++++++++++++++++++++++-
 drivers/crypto/padlock-aes.c   |    2 +-
 4 files changed, 37 insertions(+), 4 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
