Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZAWDfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZAWDfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 22:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZAWDfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 22:35:22 -0500
Received: from ns1.suse.de ([195.135.220.2]:50433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZAWDfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 22:35:22 -0500
Date: Fri, 23 Jan 2009 04:35:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123033520.GC20098@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <1232560770.8025.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232560770.8025.7.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:59:30AM -0800, Joe Perches wrote:
> One thing you might consider is that
> Q is visually close enough to O to be
> misread.
> 
> Perhaps a different letter would be good.

That's a fair point. Hugh dislikes it too, I see ;) What to do... I
had been toying with the idea that if slqb (or slub) becomes "the"
allocator, then we could rename it all back to slAb after replacing
the existing slab?

Or I could make it a 128 bit allocator and call it SLZB, which would
definitely make it "the final" allocator ;)
