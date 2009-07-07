Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZGGGAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZGGGAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZGGGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:00:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:34064 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbZGGGAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:00:04 -0400
Date: Tue, 7 Jul 2009 14:00:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20090707060003.GA28886@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com> <20090707034548.GA28075@gondor.apana.org.au> <20090707040232.GA28257@gondor.apana.org.au> <20090707040341.GA28303@gondor.apana.org.au> <20090707060015.GA20288@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707060015.GA20288@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:00:15AM +0200, Steffen Klassert wrote:
>
> Just FYI, I have a ahash version of hmac. Actually I'm about to convert
> the hmac users. I have not posted it so far because not all hmac users
> are converted, but I can do so if you are interested.

Sure, maybe I could take some of your code as is.  My plan for
hmac is to first convert it to shash, then convert the users to
ahash, and finally convert hmac itself to ahash.

This way we don't have to convert all the users and hmac in one
go.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
