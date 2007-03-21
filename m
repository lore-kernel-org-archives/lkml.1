Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXCUPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXCUPp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCUPp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:45:26 -0400
Received: from graphe.net ([209.204.138.32]:36270 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414AbXCUPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:45:26 -0400
Date: Wed, 21 Mar 2007 08:44:53 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <20070321163635.82697f08.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703210844300.3160@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703210737400.1573@graphe.net> <20070321163635.82697f08.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Eric Dumazet wrote:

> On Wed, 21 Mar 2007 07:41:46 -0700 (PDT)
> Christoph Lameter <christoph@lameter.com> wrote:
> 
> > On Wed, 21 Mar 2007, Eric Dumazet wrote:
> > 
> > > In order to avoid a cache miss in kmem_cache_free() on NUMA and reduce hot path length, we could exploit the following common facts.
> > > 
> > > 1) MAX_NUMNODES <= 64
> > 
> > MAX_NUMNODES == 1024 on IA64 and may be on x86_64 in the future.
> 
> So what ? I am very happy for you Christoph.

You wanted to exploit that MAX_NUMNODES <= 64?
