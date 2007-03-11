Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXCKHEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXCKHEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXCKHEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:04:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49838 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750733AbXCKHEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:04:46 -0400
Date: Sat, 10 Mar 2007 23:04:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [SLUB 0/3] SLUB: The unqueued slab allocator V5
In-Reply-To: <20070310224946.f9385917.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703102259440.23001@schroedinger.engr.sgi.com>
References: <20070311021009.19963.11893.sendpatchset@schroedinger.engr.sgi.com>
 <20070310224946.f9385917.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Andrew Morton wrote:

> Is this safe to think about applying yet?

Its safe. By default kernels will be build with SLAB. SLUB becomes only a 
selectable alternative. It should not become the primary slab until we 
know that its really superior overall and have thoroughly tested it in
a variety of workloads.

> We lost the leak detector feature.

There will be numerous small things that will have to be addressed. There
is also some minor work to be done for tracking callers better.
 
> It might be nice to create synonyms for PageActive, PageReferenced and
> PageError, to make things clearer in the slub core.   At the expense of
> making things less clear globally.  Am unsure.

I have been back and forth on doing that. There are somewhat similar 
in what they mean for SLUB. But creating synonyms may be confusing to 
those checking how page flags are being used.

