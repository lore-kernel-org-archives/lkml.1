Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXGGCOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXGGCOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXGGCNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:13:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49666 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbXGGCNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:13:51 -0400
Date: Fri, 6 Jul 2007 19:13:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1: SLUB_DEBUG=n compile error
In-Reply-To: <20070707020922.GB3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707061911010.3280@schroedinger.engr.sgi.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070707015021.GZ3492@stusta.de> <Pine.LNX.4.64.0707061902200.3257@schroedinger.engr.sgi.com>
 <20070707020922.GB3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, Adrian Bunk wrote:

> > Why switch CONFIG_SLUB_DEBUG off? This is an option for embedded systems. 
> > Unlikely to occur on NUMA.
> 
> ???
> This compile error is not related to NUMA.

Ah. the init_kmem_cache_node() code was moved outside of CONFIG_NUMA. 
Sigh.

Only the other issue in early_kmem_cache_node is NUMA related but you did 
not encounter this since CONFIG_NUMA was not set.

