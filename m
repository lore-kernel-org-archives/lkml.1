Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZCUGTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZCUGTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 02:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZCUGTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 02:19:43 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58061 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbZCUGTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 02:19:42 -0400
Date: Sat, 21 Mar 2009 14:19:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Clouter <alex@digriz.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 20 - timeriomem build break on s390
Message-ID: <20090321061922.GA13990@gondor.apana.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au> <20090320100901.45ce2e6f@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320100901.45ce2e6f@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 10:09:01AM +0100, Heiko Carstens wrote:
> 'hwrng: timeriomem' breaks an allyesconfig build on s390:
> 
>   CC      drivers/char/hw_random/timeriomem-rng.o
> drivers/char/hw_random/timeriomem-rng.c: In function 'timeriomem_rng_data_read':
> drivers/char/hw_random/timeriomem-rng.c:60: error: implicit declaration of function 'readl'
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Patch applied.  Thanks Heiko!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
