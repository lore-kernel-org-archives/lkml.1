Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYLJMfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYLJMfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYLJMfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:35:33 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42172 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbYLJMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:35:33 -0500
Date: Wed, 10 Dec 2008 23:35:24 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.28
Message-ID: <20081210123524.GA11696@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011021357.GB3685@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

At this late stage there is just one fix for a regression from
2.6.27.  We used to allow algorithms to be built-in with the new
testing framework built as a module.  This meant that the built-in
algorithms may not get tested properly if modules can't be loaded
when the built-in algorithms are registered.  It also seems to
trigger a modprobe loop on one distro.  This configuration is now
forbidden.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: api - Disallow cryptomgr as a module if algorithms are built-in

 crypto/Kconfig  |   36 ++++++++++++++++++++++++++++++++----
 crypto/Makefile |   18 +++++++++---------
 2 files changed, 41 insertions(+), 13 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
