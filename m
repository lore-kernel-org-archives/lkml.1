Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYK0Bv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYK0Bv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYK0Bvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:51:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58177 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbYK0Bvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:51:43 -0500
Date: Thu, 27 Nov 2008 09:51:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-crypto@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for November 26 (lib80211 + crypto)
Message-ID: <20081127015131.GA11493@gondor.apana.org.au>
References: <20081127014949.9b9a69b7.sfr@canb.auug.org.au> <20081126133234.2a8323d0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126133234.2a8323d0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 01:32:34PM -0800, Randy Dunlap wrote:
> On Thu, 27 Nov 2008 01:49:49 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081125:
> > 
> > Today's tree fails the powerpc allyesconfig build.
> 
> 
> lib80211_crypt_wep.c:(.text+0x388c7): undefined reference to `crypto_free_tfm'
> lib80211_crypt_wep.c:(.text+0x388fc): undefined reference to `crypto_alloc_base'
> lib80211_crypt_ccmp.c:(.text+0x39131): undefined reference to `crypto_alloc_base'
> lib80211_crypt_ccmp.c:(.text+0x390e7): undefined reference to `crypto_free_tfm'
> lib80211_crypt_tkip.c:(.text+0x3a219): undefined reference to `crypto_free_tfm'
> lib80211_crypt_tkip.c:(.text+0x3a21e): undefined reference to `crypto_free_tfm'
> lib80211_crypt_tkip.c:(.text+0x3a26e): undefined reference to `crypto_alloc_base'
> lib80211_crypt_tkip.c:(.text+0x3a27c): undefined reference to `crypto_alloc_base'
> 
> config attached.  Drivers are built-in, crypto is modular.

John, looks like wireless is missing a select on CRYPTO somewhere.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
