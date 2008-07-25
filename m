Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYGYBlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYGYBlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYGYBky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:40:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41350 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbYGYBkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:40:53 -0400
Date: Fri, 25 Jul 2008 09:39:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Patrick McHardy <kaber@trash.net>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, Dave Jones <davej@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20080725013958.GA14200@gondor.apana.org.au>
References: <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu> <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net> <20080724122203.GA7187@gondor.apana.org.au> <84144f020807240540vbe7ef50uee2cacabe8016546@mail.gmail.com> <20080724125004.GA7426@gondor.apana.org.au> <1216905109.15519.200.camel@calx> <20080724143706.GA8461@gondor.apana.org.au> <1216921639.15519.239.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216921639.15519.239.camel@calx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:47:19PM -0500, Matt Mackall wrote:
>
> Let's try this again: did you know that ksize could fail depending on
> kernel configuration? Most of us would answer no. That suggests the API
> is bad. This ranks 12 on Rusty's spectrum of user-friendly APIs:

I think you misunderstood my argument.  I never suggested changing
the existing ksize interface to return an error onto unsuspecting
users.  I suggested creating a new interface that is explicitly
designed to return an error if the underlying implementation
is unable to support this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
