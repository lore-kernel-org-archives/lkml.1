Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZEFJai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZEFJai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZEFJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:30:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56996 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753059AbZEFJa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:30:27 -0400
Date: Wed, 6 May 2009 17:30:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: add ctr(aes) test vectors
Message-ID: <20090506093021.GA31073@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090505131835.GA18659@gondor.apana.org.au> <200905050955.24743.jarod@redhat.com> <200905051042.58929.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905051042.58929.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 10:42:58AM -0400, Jarod Wilson wrote:
> 
> Now with multi-block test vectors, all from SP800-38A, Appendix F.5.
> Also added ctr(aes) to case 10 in tcrypt.
> 
> Quickly smoke-tested in fips mode, got back "alg_test: alg
> ctr(aes-x86_64) (ctr(aes)) self-test passed".
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

It didn't build because you forgot to change the RFC3686 dec
vector name.  I've fixed it for you.  Please test your patches
in future.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
