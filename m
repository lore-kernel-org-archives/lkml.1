Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYEAK20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYEAK20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYEAK2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:28:17 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38122 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299AbYEAK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:28:16 -0400
Date: Thu, 1 May 2008 18:28:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: torvalds@gondor.apana.org.au, "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.26
Message-ID: <20080501102812.GA7151@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes three bugs in the recently added async crypto
path as well as a minor kzalloc error-path bug.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (2):
      [CRYPTO] api: Fix scatterwalk_sg_chain
      [CRYPTO] eseqiv: Fix off-by-one encryption

Julia Lawall (1):
      [CRYPTO] cryptd: Correct kzalloc error test

Patrick McHardy (1):
      [CRYPTO] authenc: Fix async crypto crash in crypto_authenc_genicv()

 crypto/authenc.c             |    5 +++--
 crypto/cryptd.c              |    4 +++-
 crypto/eseqiv.c              |    3 ++-
 include/crypto/scatterwalk.h |    4 ++++
 4 files changed, 12 insertions(+), 4 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
