Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbXBNN5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbXBNN5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbXBNN5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:57:54 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2308 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932283AbXBNN5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:57:53 -0500
Date: Thu, 15 Feb 2007 00:57:10 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
Message-ID: <20070214135710.GA2894@gondor.apana.org.au>
References: <1171251770.10409.23.camel@localhost.localdomain> <1171251894.10409.26.camel@localhost.localdomain> <1171251965.10409.28.camel@localhost.localdomain> <1171252113.10409.30.camel@localhost.localdomain> <1171252219.10409.33.camel@localhost.localdomain> <1171252321.10409.36.camel@localhost.localdomain> <20070212155553.GA15627@gondor.apana.org.au> <1171332919.19842.74.camel@localhost.localdomain> <20070213140600.GA24711@gondor.apana.org.au> <1171428475.19842.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171428475.19842.102.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 03:47:55PM +1100, Rusty Russell wrote:
> 
> It's also used to generate dma structs for outgoing packets.  In that
> case, skb_headlen() == 0:

I see, in that case you're guaranteed to have no fragments.
Still it feels a bit weird to have a length field that only
applies to the header part.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
