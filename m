Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZHFFem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZHFFem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZHFFel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:34:41 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59385 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753405AbZHFFek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:34:40 -0400
Date: Thu, 6 Aug 2009 15:34:39 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v2 2/5] crypto: Use GHASH digest algorithm in GCM
Message-ID: <20090806053439.GB23557@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249285531-22422-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 03:45:28PM +0800, Huang Ying wrote:
> Remove the dedicated GHASH implementation in GCM, and uses the GHASH
> digest algorithm instead. This will make GCM uses hardware accelerated
> GHASH implementation automatically if available.
> 
> ahash instead of shash interface is used, because some hardware
> accelerated GHASH implementation needs asynchronous interface.
> 
> v2:
>  - Add parameter to gcm_base to choose ghash implementation.
>  - Fix a memory leak about gcm_zeros (Thanks Sebastian)
>  - Some minor fixes
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
