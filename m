Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZFCJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZFCJ2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZFCJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:28:22 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:32939 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbZFCJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:28:21 -0400
Date: Wed, 3 Jun 2009 19:28:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [HWRNG] timeriomem-rng fixes
	(request_mem_region/__devinit)
Message-ID: <20090603092820.GB11258@gondor.apana.org.au>
References: <20090601221429.GP32238@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601221429.GP32238@woodchuck>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 11:14:29PM +0100, Alexander Clouter wrote:
> [HWRNG] timeriomem-rng fixes (request_mem_region/__devinit)
> 
> Fixed oops when calling device_unregister followed by device_register
> (changing __init to __devinit) and removed request_mem_region() as
> platform_device_register already does this which can result in EBUSY
> 
> Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

Patch applied.  Thanks Alexander!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
