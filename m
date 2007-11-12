Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXKLTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXKLTOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXKLTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:14:08 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:43628 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751250AbXKLTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:14:07 -0500
Date: Mon, 12 Nov 2007 11:14:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
Message-ID: <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com>
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Herbert Xu wrote:

> David Miller <davem@davemloft.net> wrote:
> > 
> > Each IP compression tunnel instance does an alloc_percpu().
> 
> Actually all IPComp tunnels share one set of objects which are
> allocated per-cpu.  So only the first tunnel would do that.

Ahh so the need to be able to expand per cpu memory storage on demand 
is not as critical as we thought.

