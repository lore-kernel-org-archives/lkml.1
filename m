Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZIIOzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZIIOzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZIIOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:55:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56554 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752328AbZIIOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:55:00 -0400
Date: Wed, 9 Sep 2009 10:53:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       dhowells@redhat.com, lethal@linux-sh.org, kernel@wantstofly.org,
       mpm@selenic.com
Subject: Re: [PATCH] slub: fix slab_pad_check()
In-Reply-To: <20090909144238.GA6749@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0909091052380.28070@V090114053VZO-1>
References: <4AA00400.1030005@gmail.com> <alpine.DEB.1.10.0909031731540.24199@V090114053VZO-1> <20090903231757.GP6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909041140040.9781@V090114053VZO-1> <20090904204335.GG6751@linux.vnet.ibm.com>
 <alpine.DEB.1.10.0909081555410.26382@V090114053VZO-1> <20090908222036.GM6753@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081839090.7733@V090114053VZO-1> <20090908225937.GO6753@linux.vnet.ibm.com> <alpine.DEB.1.10.0909091002440.28070@V090114053VZO-1>
 <20090909144238.GA6749@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Paul E. McKenney wrote:

> If the embedded guys are OK with an additional pointer in the slab data
> structure, I have no objection to this approach.  I am assuming that we
> would use the usual ops-style structure full of pointers to functions
> in order to avoid a pair of extra pointers.

This would also allow us to get rid of the ctor pointer in
kmem_cache_create(). We can put it into the same structure.

