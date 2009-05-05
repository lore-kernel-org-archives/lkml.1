Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZEENSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZEENSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZEENSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:18:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:52464 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbZEENSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:18:39 -0400
Date: Tue, 5 May 2009 21:18:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: add ctr(aes) test vectors
Message-ID: <20090505131835.GA18659@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au> <200905041624.45060.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905041624.45060.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:24:44PM -0400, Jarod Wilson wrote:
>
> Indeed, the first enc/dec operation after we set the counter *is*
> completely deterministic across all implementations, the AESAVS
> is referring to tests with multiple operations, which aren't
> possible, due to varying implementations of counter increment
> routines. This patch adds test vectors for ctr(aes), using the
> first block input values from Appendix F.5 of NIST Special Pub
> 800-38A.

Well, our ctr(aes) must be completely deterministic as it is
used as the base for CCM and GCM.  In fact, if it weren't so
then you can't use it for anything since two implementations
may produces different outputs.

So if you could resend some vectors that test multiple blocks
then I'll happily add them.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
