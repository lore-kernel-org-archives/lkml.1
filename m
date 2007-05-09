Return-Path: <linux-kernel-owner+w=401wt.eu-S969937AbXEICUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969937AbXEICUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969437AbXEICUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:20:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43343 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968513AbXEICUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:20:11 -0400
Date: Tue, 8 May 2007 19:20:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: David Miller <davem@davemloft.net>, mpm@selenic.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <46412D8D.8090903@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705081917220.17931@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>
 <20070508.185539.95059076.davem@davemloft.net>
 <Pine.LNX.4.64.0705081856110.17784@schroedinger.engr.sgi.com>
 <20070508.190610.08324075.davem@davemloft.net> <46412D8D.8090903@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Nick Piggin wrote:

> Right. You only need to know blob boundaries for free blobs (so you can
> allocate from or merge to). For allocated blobs, you know the start
> (which is the address of the memory), and the end (which is the start +
> the size contained in kmem_cache structure).

For kmalloc caches you will not have the object size on kfree. In that 
case the slob_t structure is needed before the object.

