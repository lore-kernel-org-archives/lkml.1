Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXEUJpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXEUJpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXEUJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:45:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:60409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXEUJpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:45:08 -0400
Date: Mon, 21 May 2007 11:45:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070521094507.GB19642@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com> <20070519150934.bdabc9b5.akpm@linux-foundation.org> <4651629B.2050505@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651629B.2050505@aitel.hist.no>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:12:59AM +0200, Helge Hafting wrote:
> Andrew Morton wrote:
> >On Sat, 19 May 2007 11:15:01 -0700 William Lee Irwin III 
> ><wli@holomorphy.com> wrote:
> >
> >  
> >>Much the same holds for the atomic_t's; 32 + PAGE_SHIFT is
> >>44 bits or more, about as much as is possible, and one reference per
> >>page per page is not even feasible. Full-length atomic_t's are just
> >>not necessary.
> >>    
> >
> >You can overflow a page's refcount by mapping it 4G times.  That requires
> >32GB of pagetable memory.  It's quite feasible with remap_file_pages().
> >  
> But do anybody ever need to do that?
> Such an attack is easily thwarted by refusing to map it more
> than, say 3G times? 

That still allows you to DoS the page.

