Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0CJK3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:29:22 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47006 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825Ab0CJK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:29:19 -0500
Date: Wed, 10 Mar 2010 18:29:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Add AES-NI accelerated CTR mode
Message-ID: <20100310102916.GA23398@gondor.apana.org.au>
References: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 02:14:36PM +0800, Huang Ying wrote:
> To take advantage of the hardware pipeline implementation of AES-NI
> instructions. CTR mode cryption is implemented in ASM to schedule
> multiple AES-NI instructions one after another. This way, some latency
> of AES-NI instruction can be eliminated.
> 
> Performance testing based on dm-crypt should 50% reduction of
> ecryption/decryption time.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
