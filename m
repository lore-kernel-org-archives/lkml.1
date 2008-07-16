Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYGPCJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYGPCJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYGPCJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:09:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43059 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755105AbYGPCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:09:27 -0400
Date: Wed, 16 Jul 2008 10:08:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 000000000000000e (reset_prng_context)
Message-ID: <20080716020854.GA11777@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715151110.d7a17c89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
>
> > What are those unacceptable mistakes?
> > 
> > Don't read the code again, what are those mistakes?
> 
> Sleeping inside spinlock?

Actually no, that was purely the result of Ingo's random config
test.  It is extremely unlikely that anyone other than Ingo
would have enabled this option without the crypto algorithms
required by it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
