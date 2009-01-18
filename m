Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZARF3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZARF3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZARF3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:29:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:59825 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704AbZARF3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:29:20 -0500
Date: Sun, 18 Jan 2009 16:29:05 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto -v6 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Message-ID: <20090118052905.GA23663@gondor.apana.org.au>
References: <1232091666.13948.52.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232091666.13948.52.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:41:06PM +0800, Huang Ying wrote:
> cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
> specified algorithm name. The new allocated one is guaranteed to be
> cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
> cryptd_ablkcipher_child().

Both patches applied.

Thanks a lot for your hard work on this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
