Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZA1Jyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZA1Jyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZA1Jyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:54:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:54565 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbZA1Jye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:54:34 -0500
Date: Wed, 28 Jan 2009 20:54:27 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: hardware time stamping with optional structs in data area
Message-ID: <20090128095427.GA16215@gondor.apana.org.au>
References: <20090128090821.GA15770@gondor.apana.org.au> <1233136333.26507.38.camel@pohly-MOBL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233136333.26507.38.camel@pohly-MOBL>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:52:13AM +0100, Patrick Ohly wrote:
>
> Putting that into shinfo should work fine. I thought extending that
> structure with information that isn't needed for all packets was as bad
> as extending sk_buff itself. If that isn't the case, then extending
> shinfo definitely is the simplest solution.

Not at all, the sk_buff has its own slab while skb->head uses
kmalloc.  The latter has loads of free space due to padding for
common MTUs such as 1500 or header-only.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
