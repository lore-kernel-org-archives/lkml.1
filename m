Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXHJIjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXHJIjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765609AbXHJIjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:39:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3240 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757030AbXHJIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:39:01 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Organization: Core
In-Reply-To: <20070809161024.GC8424@linux.vnet.ibm.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IJPkg-0000x0-00@gondolin.me.apana.org.au>
Date: Fri, 10 Aug 2007 16:21:46 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>
> The compiler is within its rights to read a 32-bit quantity 16 bits at
> at time, even on a 32-bit machine.  I would be glad to help pummel any
> compiler writer that pulls such a dirty trick, but the C standard really
> does permit this.

Code all over the kernel assumes that 32-bit reads/writes
are atomic so while such a compiler might be legal it certainly
can't compile Linux.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
