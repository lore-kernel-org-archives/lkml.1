Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbZFRLpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbZFRLpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762141AbZFRLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:45:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40261 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762125AbZFRLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:45:20 -0400
Date: Thu, 18 Jun 2009 19:45:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX 1/3] crypto: Fix AES-NI cbc mode IV saving
Message-ID: <20090618114521.GC6596@gondor.apana.org.au>
References: <1245056684.5320.347.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245056684.5320.347.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 05:04:44PM +0800, Huang Ying wrote:
> Original implementation of aesni_cbc_dec do not save IV if input
> length % 4 == 0. This will make decryption of next block failed.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

All three patches applied to crypto-2.6.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
