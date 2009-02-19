Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbZBSGot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbZBSGot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZBSGoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:44:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46439 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752660AbZBSGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:44:38 -0500
Date: Thu, 19 Feb 2009 14:44:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -v2 1/3] crypto: Use dedicated workqueue for crypto
	subsystem
Message-ID: <20090219064431.GA2011@gondor.apana.org.au>
References: <1234246430.20270.73.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234246430.20270.73.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 02:13:50PM +0800, Huang Ying wrote:
> Use dedicated workqueue for crypto subsystem
> 
> A dedicated workqueue named kcrypto_wq is created to be used by crypto
> subsystem. The system shared keventd_wq is not suitable for
> encryption/decryption, because of potential starvation problem.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

All applied.  Thanks a lot for doing this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
