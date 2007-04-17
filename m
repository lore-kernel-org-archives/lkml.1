Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXDQXZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXDQXZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDQXZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:25:13 -0400
Received: from waste.org ([66.93.16.53]:51630 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXDQXZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:25:11 -0400
Date: Tue, 17 Apr 2007 18:09:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: Re: slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
Message-ID: <20070417230955.GG11166@waste.org>
References: <Pine.LNX.4.64.0704162232530.31027@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704162232530.31027@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 10:35:21PM -0700, Christoph Lameter wrote:
> The flag SLAB_MUST_HWCACHE_ALIGN is
> 
> 1. Never checked by SLAB at all.
> 
> 2. A duplicate of SLAB_HWCACHE_ALIGN for SLUB
> 
> 3. Fulfills the role of SLAB_HWCACHE_ALIGN for SLOB.
> 
> The only remaining use is in sparc64 and ppc64 and their use there
> reflects some earlier role that the slab flag once may have had. If
> its specified then SLAB_HWCACHE_ALIGN is also specified.
> 
> The flag is confusing, inconsistent and has no purpose.
> 
> Remove it.

Hmm, at one point this was needed by SLOB to boot on x86, I wonder
when that changed? But if SLAB is using the other define now, I'm
happy to switch.
 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
-- 
Mathematics is the supreme nostalgia of our time.
