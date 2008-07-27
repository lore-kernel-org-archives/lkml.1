Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbYG0GhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbYG0GhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYG0GhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:37:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbYG0GhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:37:08 -0400
Date: Sun, 27 Jul 2008 14:36:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.27
Message-ID: <20080727063659.GA936@gondor.apana.org.au>
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

This push fixes a number of bugs in the recently added talitos
driver.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Kim Phillips (4):
      crypto: talitos - Preempt overflow interrupts
      crypto: talitos - Fix GFP flag usage
      crypto: talitos - Stop leaking memory in error path
      crypto: talitos - sparse fix

Lee Nipper (2):
      crypto: talitos - Remove calls to of_node_put
      crypto: talitos - Correct dst != src case handling

 drivers/crypto/talitos.c |   49 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
