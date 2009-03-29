Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZC2HmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZC2HmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZC2HmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 03:42:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:45461 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbZC2HmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 03:42:14 -0400
Date: Sun, 29 Mar 2009 15:42:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v3 2/3] crypto: Add fpu template, a wrapper for
	blkcipher touching FPU
Message-ID: <20090329074204.GA11735@gondor.apana.org.au>
References: <1237346517.24215.241.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237346517.24215.241.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 11:21:57AM +0800, Huang Ying wrote:
> Blkcipher touching FPU need to be enclosed by kernel_fpu_begin() and
> kernel_fpu_end(). If they are invoked in cipher algorithm
> implementation, they will be invoked for each block, so that
> performance will be hurt, because they are "slow" operations. This
> patch implements "fpu" template, which makes these operations to be
> invoked for each request.
> 
> v2: Make FPU mode invisible to end user
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

I've applied all the three patches with no changes except moving
fpu.c into arch/x86/crypto.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
