Return-Path: <linux-kernel-owner+w=401wt.eu-S1945908AbXCWOwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908AbXCWOwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXCWOwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:52:55 -0400
Received: from graphe.net ([209.204.138.32]:35437 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945908AbXCWOwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:52:54 -0400
Date: Fri, 23 Mar 2007 07:52:36 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Andy Whitcroft <apw@shadowen.org>
cc: Eric Dumazet <dada1@cosmosbay.com>, akpm@osdl.org,
       Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       hch@lst.de, manfred@colorfullife.com, pj@sgi.com
Subject: Re: [PATCH] slab: NUMA kmem_cache diet
In-Reply-To: <4603CF5A.8040601@shadowen.org>
Message-ID: <Pine.LNX.4.64.0703230751530.29603@graphe.net>
References: <Pine.LNX.4.64.0701021545290.21477@sbz-30.cs.Helsinki.FI>
 <4603047C.4070904@cosmosbay.com> <4603CF5A.8040601@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Andy Whitcroft wrote:

> > +	/*
> > +	 * We put nodelists[] at the end of kmem_cache, because we want to size
> > +	 * this array to nr_node_ids slots instead of MAX_NUMNODES
> > +	 * (see kmem_cache_init())
> > +	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
> > +	 * is statically defined, so we reserve the max number of nodes.
> > +	 */

Good idea.
