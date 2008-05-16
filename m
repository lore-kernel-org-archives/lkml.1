Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYEPBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYEPBjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYEPBjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:39:44 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56923 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbYEPBjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:39:43 -0400
Date: Fri, 16 May 2008 09:39:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <RANDY.DUNLAP@oracle.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, Loc Ho <lho@amcc.com>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] crypto: fix cryptd build fix due to missing ahash
Message-ID: <20080516013928.GA5555@gondor.apana.org.au>
References: <4694288.1210878773358.JavaMail.oracle@acsmt302.oracle.com> <20080515212856.GB3081@Chamillionaire.breakpoint.cc> <31763212.1210890834426.JavaMail.oracle@acsmt305.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31763212.1210890834426.JavaMail.oracle@acsmt305.oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 05:33:54PM -0500, Randy Dunlap wrote:
> 
> > This was reported by Randy Dunlap:
> > |crypto/built-in.o: In function `cryptd_alloc':
> > |cryptd.c:(.text+0x9b5a): undefined reference to `crypto_ahash_type'
> > 
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, I've merged this into the original change.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
