Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXEIKYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXEIKYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXEIKXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:23:52 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2094 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755269AbXEIKXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:23:51 -0400
Date: Wed, 9 May 2007 20:21:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Message-ID: <20070509102126.GA4819@gondor.apana.org.au>
References: <11786975641488-git-send-email-jens.axboe@oracle.com> <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au> <20070509031915.6e934f35.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509031915.6e934f35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:19:15AM -0700, Andrew Morton wrote:
>
> > BTW, the crypto layer's scatterlist already has a chaining mechanism
> > using the existing structure.  The only difference is that the chained
> > pointer is stored inside the 'struct page *' rather than a new pointer.
> 
> <greps-and-fails>
> 
> Which field in the page is it using?

Sorry, I was a bit unclear.  It's simply stored in the page field since
on a length == 0 entry we don't have a page at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
