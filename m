Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXGMMt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXGMMt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXGMMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:49:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:48556 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbXGMMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:49:18 -0400
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joe.jin@oracle.com,
       bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, zwane@arm.linux.org.uk
In-Reply-To: <20070713015457.326f0081.pj@sgi.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	 <20070712221842.f5e47065.akpm@linux-foundation.org>
	 <20070713064004.GA21833@joejin-pc.cn.oracle.com>
	 <20070712234938.c77f3a48.akpm@linux-foundation.org>
	 <20070712235707.a08f0d42.akpm@linux-foundation.org>
	 <20070713012906.a6f63c90.pj@sgi.com>
	 <20070713013819.0f8bd1ea.akpm@linux-foundation.org>
	 <20070713014349.a8305231.pj@sgi.com>
	 <20070713014907.5e51a224.akpm@linux-foundation.org>
	 <20070713015457.326f0081.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 22:48:24 +1000
Message-Id: <1184330904.6059.223.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 01:54 -0700, Paul Jackson wrote:
> > Something for the young ...
> 
> ... ancient self smiles with relief, glad that Andrew is not looking
> this way ;).
> 
> > We could do this: add a little bitops torture-test and run that
> > unconditionally, nice and early.
> 
> Good idea.  That would allow for wide spread coverage across all arch's
> that they obeyed the rules for the tighter API - find_first_bit returning
> exactly N on finding no bits set, before we took the risk of actually
> relying on the changed API, by removing those min_t() guards.

That, the lockdep tests, the RCU tests...

Looks like the kernel is building up it's own test suite :-) That's a
-good- thing, maybe we should formalize it a bit (separate the "test
suite" config options) ?

Ben.


