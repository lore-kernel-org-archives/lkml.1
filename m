Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYHSXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYHSXRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYHSXR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:17:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57061 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783AbYHSXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:17:27 -0400
Date: Wed, 20 Aug 2008 09:17:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jacliburn@bellsouth.net, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, link@miggy.org, ian@jeffray.co.uk,
       csnook@redhat.com, jie.yang@atheros.com, m@fhloston.org
Subject: Re: [PATCH] atl1: disable TSO by default
Message-ID: <20080819231716.GA10741@gondor.apana.org.au>
References: <20080818192813.0d0dc1fd@osprey.hogchain.net> <E1KVQyr-0001Ui-00@gondolin.me.apana.org.au> <20080819175334.28dc1c8e@osprey.hogchain.net> <20080819.155845.108491107.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819.155845.108491107.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 03:58:45PM -0700, David Miller wrote:
>
> > The atl1 driver was merged in the spring of 2007, so I'm not sure I
> > consider it new (but your kernel development time horizon is undoubtedly
> > *way* longer than mine, so you may indeed consider it new). It was
> > basically a vendor driver that we modified to conform to kernel coding
> > standards. It started life, we believe, as pretty much a clone of the
> > e1000 driver circa 2005, so that's likely where it's use of LLTX
> > came from.
> 
> You'll have to forgive us, as we often have a knee jerk reaction
> to seeing LLTX anywhere :-)

Heh, it's like seeing a fly in your soup :)

However, this does seem to be proliferating to some extent although
I picked on the wrong driver.  The one I saw that was new is actually
drivers/net/atl1e which seems to have copied the same code across.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
