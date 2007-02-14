Return-Path: <linux-kernel-owner+w=401wt.eu-S964805AbXBNXA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbXBNXA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964808AbXBNXA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:00:58 -0500
Received: from ozlabs.org ([203.10.76.45]:41784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805AbXBNXA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:00:57 -0500
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <20070214135710.GA2894@gondor.apana.org.au>
References: <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
	 <1171252219.10409.33.camel@localhost.localdomain>
	 <1171252321.10409.36.camel@localhost.localdomain>
	 <20070212155553.GA15627@gondor.apana.org.au>
	 <1171332919.19842.74.camel@localhost.localdomain>
	 <20070213140600.GA24711@gondor.apana.org.au>
	 <1171428475.19842.102.camel@localhost.localdomain>
	 <20070214135710.GA2894@gondor.apana.org.au>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 10:00:09 +1100
Message-Id: <1171494009.19842.185.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 00:57 +1100, Herbert Xu wrote:
> On Wed, Feb 14, 2007 at 03:47:55PM +1100, Rusty Russell wrote:
> > 
> > It's also used to generate dma structs for outgoing packets.  In that
> > case, skb_headlen() == 0:
> 
> I see, in that case you're guaranteed to have no fragments.
> Still it feels a bit weird to have a length field that only
> applies to the header part.

Indeed.  In future if I want to create fragmented skbs for receive
(large MTU support), I would actually set skb->len and skb->datalen and
then could avoid the extra argument.

Cheers,
Rusty.


