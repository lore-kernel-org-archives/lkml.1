Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZHFFfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZHFFfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZHFFfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:35:33 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59389 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbZHFFfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:35:32 -0400
Date: Thu, 6 Aug 2009 15:35:32 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v2 3/5] crypto: cryptd: Add support to access
	underlaying shash
Message-ID: <20090806053532.GC23557@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com> <1249285531-22422-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249285531-22422-3-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 03:45:29PM +0800, Huang Ying wrote:
> cryptd_alloc_ahash() will allocate a cryptd-ed ahash for specified
> algorithm name. The new allocated one is guaranteed to be cryptd-ed
> ahash, so the shash underlying can be gotten via cryptd_ahash_child().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
