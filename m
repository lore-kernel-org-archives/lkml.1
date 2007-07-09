Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXGIUxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXGIUxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbXGIUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:53:18 -0400
Received: from waste.org ([66.93.16.53]:37755 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXGIUxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:53:17 -0400
Date: Mon, 9 Jul 2007 15:52:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070709205232.GU11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708035018.074510057@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, WTF wasn't I cc:ed on this? Are you actually trying to me make
me fuming mad?

On Sat, Jul 07, 2007 at 08:50:01PM -0700, Christoph Lameter wrote:
> Maintenance of slab allocators becomes a problem as new features for
> allocators are developed. The SLOB allocator in particular has been lagging
> behind in many ways in the past:
> 
> - Had no support for SLAB_DESTROY_BY_RCU for years (but no one noticed)

We've been over this 50 times. The target users were never affected.
And it's fixed. So why the HELL are you mentioning this again? 
 
> - Still has no support for slab reclaim counters. This may currently not
>   be necessary if one would restrict the supported configurations for
>   functionality relying on these. But even that has not been done.

We've been over this 50 times. Last time around, I inspected all the
code paths and demonstrated that despite your handwaving, IT DIDN'T
MATTER.

> The only current advantage over SLUB in terms of memory savings is through
> SLOBs kmalloc layout that is not power of two based like SLAB and SLUB which
> allows to eliminate some memory waste.
> 
> Through that SLOB has still a slight memory advantage over SLUB of ~350k in
> for a standard server configuration. It is likely that the savings are is
> smaller for real embedded configurations that have less functionality.

Sometimes I do not think there is a cluebat large enough for you. 350K
is FREAKING HUGE on a cell phone. That's most of a kernel!

-- 
Mathematics is the supreme nostalgia of our time.
