Return-Path: <linux-kernel-owner+w=401wt.eu-S2992436AbXCWO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992436AbXCWO6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992437AbXCWO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:58:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45676 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992436AbXCWO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:58:44 -0400
Date: Fri, 23 Mar 2007 07:58:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
In-Reply-To: <20070323112331.GQ2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703230757420.21787@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
 <20070322223927.bb4caf43.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
 <20070322234848.100abb3d.akpm@linux-foundation.org> <20070323112331.GQ2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, William Lee Irwin III wrote:

> [... patch changing allocator alloc()/free() to bare page allocations ...]
> > but it crashes early in the page allocator (i386) and I don't see why.  It
> > makes me wonder if we have a use-after-free which is hidden by the presence
> > of the quicklist buffering or something.

Sorry there seems to be some email dropouts today. I am getting 
fragments of slab and quicklist discussions. Maybe I can get the whole story from 
the mailing lists.
