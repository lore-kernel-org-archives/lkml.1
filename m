Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXEIJuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXEIJuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXEIJuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:50:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:5636 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXEIJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V8fygeI364UfM0fNuxCE+YYw8wOoCk3ZtvifmSpokFS04BRty8GYIwIewobGS/pjD1mXijGba+srpgVEKGlMUnlh51Us2D4WFvun8yC+3Kqzcstx6VOnmJIig5VfKEbFVNjZoGvUA8qB1OoKHwKctl/l8vEvzqD4GXS7iDKufrY=
Message-ID: <a44ae5cd0705090250w4f0d1dfes97d5e14f128187d9@mail.gmail.com>
Date: Wed, 9 May 2007 02:50:12 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.21-mm1+hotfix -- Slab corruption -- Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070508095255.GA20522@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0705071157m241ec3c1k8c60aaf213a28166@mail.gmail.com>
	 <20070508095255.GA20522@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, May 07, 2007 at 11:57:28AM -0700, Miles Lane wrote:
> > [  118.442018] ieee80211_crypt: registered algorithm 'WEP'
> > [  118.514572] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> > [  118.514664] Slab corruption: size-256 start=c6aabe98, len=256
> > [  118.514672] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> > [  118.514676] Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
> > [  118.514692] 000: 10 55 ac c6 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> > [  118.514715] Prev obj: start=c6aabd80, len=256
> > [  118.514721] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> > [  118.514725] Last user: [<c01afd85>](crypto_alloc_instance+0x1d/0xc0)
> > [  118.514734] 000: e0 71 39 c0 80 6e 39 c0 88 bd aa c6 88 bd aa c6
> > [  118.514753] 010: 04 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00
>
> Oops.  Does this patch fix the problem for you?

Yes, that fixed it.  I found the problem is also showing up in
2.6.21-git10.  I tested with 2.6.21-git10.

Thanks!
         Miles
