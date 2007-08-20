Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXHTJMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXHTJMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHTJMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:12:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38054 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXHTJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:12:32 -0400
Date: Mon, 20 Aug 2007 12:12:30 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
In-Reply-To: <1187595513.6114.176.camel@twins>
Message-ID: <Pine.LNX.4.64.0708201211240.20591@sbz-30.cs.Helsinki.FI>
References: <20070806102922.907530000@chello.nl>  <20070806103658.603735000@chello.nl>
 <1187595513.6114.176.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 20 Aug 2007, Peter Zijlstra wrote:
> -static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node, int *reserve)
>  {

[snip]

> +	*reserve = page->reserve;

Any reason why the callers that are actually interested in this don't do 
page->reserve on their own?
