Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXC0BW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXC0BW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbXC0BW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:22:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59534 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933897AbXC0BW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:22:26 -0400
Date: Mon, 26 Mar 2007 18:22:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
In-Reply-To: <20070327010624.GA2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703261817160.14048@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
 <20070322223927.bb4caf43.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
 <20070322234848.100abb3d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703230804120.21857@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703231026490.23132@schroedinger.engr.sgi.com>
 <20070323222133.f17090cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
 <20070326102651.6d59207b.akpm@linux-foundation.org> <20070327010624.GA2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, William Lee Irwin III wrote:

> Not that clameter really needs my help, but I agree with his position
> on several fronts, and advocate accordingly, so here is where I'm at.

Yes thank you. I386 is not my field, I have no interest per se in 
improving i386 performance and without your help I would have to drop this 
and keep the special casing in SLUB for i386. Generic tlb.h changes may 
also help to introduce quicklists to x86_64. The current quicklist patches 
can only work on higher levels due to the freeing of ptes via 
tlb_remove_page().

