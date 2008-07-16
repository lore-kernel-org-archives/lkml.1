Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYGPFfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYGPFfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYGPFfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:35:43 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41120 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbYGPFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:35:43 -0400
Date: Wed, 16 Jul 2008 13:34:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 000000000000000e (reset_prng_context)
Message-ID: <20080716053459.GA13097@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org> <20080716040701.GA12570@gondor.apana.org.au> <20080715212549.1c41c1d0.akpm@linux-foundation.org> <20080716043312.GA12765@gondor.apana.org.au> <20080715215153.16ba2594.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715215153.16ba2594.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 09:51:53PM -0700, Andrew Morton wrote:
>
> And I agree with me.  I fail to see how someone who is familiar with
> kernel code and who is reviewing a submission could let something like
> 
> 	for (i=DEFAULT_BLK_SZ-1;i>0;i--) {
> 
> pass without comment.

Well here is the code in question in its entirety:


        /*
         * Now update our DT value
         */
        for (i=DEFAULT_BLK_SZ-1;i>0;i--) {
                ctx->DT[i] = ctx->DT[i-1];
        }

I'm afraid that I simply don't see your point.

> btw, I've searched my linux-kernel archives and netdev archives and the
> linux-crypto web archives and can find no sign of any submission or
> discussion of this patch.  Am I looking in the wrong places?

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02082.html

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
