Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZBQMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZBQMNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZBQMNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:13:05 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52764 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916AbZBQMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:13:04 -0500
Date: Tue, 17 Feb 2009 20:12:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 2.6.29
Message-ID: <20090217121252.GA22812@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20090115044020.GA29891@gondor.apana.org.au> <20090127061546.GA27962@gondor.apana.org.au> <20090209033924.GA31250@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209033924.GA31250@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes LRW (used for disk encryption) on big endian.
It turns out that it just never worked over there.  Based on
the fact that nobody screamed about it after the addition of
mandatory testing, it seems that it just isn't used so we don't
have to worry about existing big-endian LRW deployments.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: lrw - Fix big endian support

 crypto/lrw.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
