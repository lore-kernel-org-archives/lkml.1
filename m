Return-Path: <linux-kernel-owner+w=401wt.eu-S1751046AbZJTHrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbZJTHrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZJTHry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:47:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36366 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbZJTHrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:47:53 -0400
Date: Tue, 20 Oct 2009 16:47:56 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] Fix irq_fpu_usable usage in aesni
Message-ID: <20091020074755.GA7208@gondor.apana.org.au>
References: <1255917617.1951.33.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255917617.1951.33.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 10:00:17AM +0800, Huang Ying wrote:
> When renaming kernel_fpu_using to irq_fpu_usable, the semantics of the
> function is changed too, from mesuring whether kernel is using FPU,
> that is, the FPU is NOT available, to measuring whether FPU is usable,
> that is, the FPU is available.
> 
> But the usage of irq_fpu_usable in aesni-intel_glue.c is not changed
> accordingly. This patch fixes this.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied to crypto-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
