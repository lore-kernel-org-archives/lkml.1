Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXKLKx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXKLKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXKLKxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:53:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4313 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131AbXKLKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:53:50 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu access overhead
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Organization: Core
In-Reply-To: <20071101.155805.65012933.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
Date: Mon, 12 Nov 2007 18:52:35 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> 
> Each IP compression tunnel instance does an alloc_percpu().

Actually all IPComp tunnels share one set of objects which are
allocated per-cpu.  So only the first tunnel would do that.

In fact that was precisely the reason why per-cpu is used in
IPComp as otherwise we can just allocate normal memory.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
