Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbYBOLUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbYBOLUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763268AbYBOLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:20:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33342 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762071AbYBOLUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:20:05 -0500
Date: Fri, 15 Feb 2008 19:19:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [patch] crypto test build failure
Message-ID: <20080215111958.GA13284@gondor.apana.org.au>
References: <20080209195232.GC11728@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209195232.GC11728@slug>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 08:52:32PM +0100, Frederik Deweerdt wrote:
> Hello Herbert,
> 
> Building latest git fails with the following error:
> 	ERROR: "crypto_alloc_ablkcipher" [crypto/tcrypt.ko] undefined!
> This appears to happen because CONFIG_CRYPTO_TEST is set while
> CONFIG_CRYPTO_BLKCIPHER is not.
> The following patch fixes the problem for me.

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
