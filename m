Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbXKAWQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbXKAWQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760261AbXKAWQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:16:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36948 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759358AbXKAWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:16:39 -0400
Date: Thu, 1 Nov 2007 15:16:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: dada1@cosmosbay.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071101.151440.88131899.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711011515451.22508@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711010555390.27666@schroedinger.engr.sgi.com>
 <20071101.142809.179954273.davem@davemloft.net>
 <Pine.LNX.4.64.0711011511240.22508@schroedinger.engr.sgi.com>
 <20071101.151440.88131899.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Thu, 1 Nov 2007 15:11:41 -0700 (PDT)
> 
> > On Thu, 1 Nov 2007, David Miller wrote:
> > 
> > > The remaining issue with accessing per-cpu areas at multiple virtual
> > > addresses is D-cache aliasing.
> > 
> > But that is not an issue for physicallly mapped caches.
> 
> Right but I'd like to use this on sparc64 which has L1 D-cache
> aliasing on some chips :-)

Hmmm... re my message I just send. Then we have to return the memory with 
the virtual address not with the physical address on sparc. May result in 
zones with holes though.

