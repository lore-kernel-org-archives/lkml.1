Return-Path: <linux-kernel-owner+w=401wt.eu-S1750718AbXBMOG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750718AbXBMOG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXBMOG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:06:57 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4266 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbXBMOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:06:56 -0500
Date: Wed, 14 Feb 2007 01:06:00 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
Message-ID: <20070213140600.GA24711@gondor.apana.org.au>
References: <1171251578.10409.17.camel@localhost.localdomain> <1171251698.10409.20.camel@localhost.localdomain> <1171251770.10409.23.camel@localhost.localdomain> <1171251894.10409.26.camel@localhost.localdomain> <1171251965.10409.28.camel@localhost.localdomain> <1171252113.10409.30.camel@localhost.localdomain> <1171252219.10409.33.camel@localhost.localdomain> <1171252321.10409.36.camel@localhost.localdomain> <20070212155553.GA15627@gondor.apana.org.au> <1171332919.19842.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171332919.19842.74.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 01:15:18PM +1100, Rusty Russell wrote:
> 
> Good spotting!  This function needs to be passed skb_headlen(skb),
> rather than skb->len.  Patch is below (I renamed the parameter as well,
> for clarity).

How about just dropping that parameter and using skb_headlen(skb)
directly?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
