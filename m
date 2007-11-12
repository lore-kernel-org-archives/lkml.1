Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXKLV3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXKLV3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXKLV3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:29:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55972
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbXKLV3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:29:00 -0500
Date: Mon, 12 Nov 2007 13:28:59 -0800 (PST)
Message-Id: <20071112.132859.82406611.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
References: <20071101.155805.65012933.davem@davemloft.net>
	<E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 12 Nov 2007 18:52:35 +0800

> David Miller <davem@davemloft.net> wrote:
> > 
> > Each IP compression tunnel instance does an alloc_percpu().
> 
> Actually all IPComp tunnels share one set of objects which are
> allocated per-cpu.  So only the first tunnel would do that.
> 
> In fact that was precisely the reason why per-cpu is used in
> IPComp as otherwise we can just allocate normal memory.

Hmmm... indeed.  Thanks for clearing this up.
