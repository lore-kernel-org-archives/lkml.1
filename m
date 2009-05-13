Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZEMODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZEMODq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZEMODe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:03:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43056 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756030AbZEMODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:03:33 -0400
Date: Thu, 14 May 2009 00:03:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Message-ID: <20090513140329.GA17863@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <200905130912.46965.jarod@redhat.com> <20090513132752.GA17262@gondor.apana.org.au> <200905130937.33449.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905130937.33449.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 09:37:32AM -0400, Jarod Wilson wrote:
> 
> The latter option is more or less what the patch at the start of this
> thread did, although via a param to tcrypt, not keying off the fips
> flag. If I were to modify the patch to drop the mod param usage, and
> instead key off the fips flag to not exit, would that be acceptable
> for committing until such time as the userspace interface is ready?

Yes that sounds like the way to go.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
