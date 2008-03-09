Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYCIBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYCIBIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 20:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYCIBIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 20:08:30 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44087 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752174AbYCIBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 20:08:29 -0500
Date: Sun, 9 Mar 2008 09:08:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.25 patch] crypto/ section fixes
Message-ID: <20080309010821.GA31095@gondor.apana.org.au>
References: <20080308215140.GC12621@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308215140.GC12621@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 11:51:40PM +0200, Adrian Bunk wrote:
> This patch fixes the following issues introduced by
> commit 76fc60a2e3c6aa6e98cd3a5cb81a1855c637b274:
> - the exports of {chainiv,eseqiv}_module_{init,exit} are unneeded
> - calling {chainiv,eseqiv}_module_init from a module would anyway have 
>   resulted in an Oops
> - chainiv_module_exit() mustn't be exit since it's now called from 
>   the __init blkcipher_module_init()
> 
> On architectures that discard __exit code at build time these issues led 
> to build errors.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks.  I've already got this in crypto-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
