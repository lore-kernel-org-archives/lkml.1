Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbXDMCgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbXDMCgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXDMCgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:36:50 -0400
Received: from waste.org ([66.93.16.53]:32980 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbXDMCgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:36:49 -0400
Date: Thu, 12 Apr 2007 21:23:45 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413022345.GN11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070413015712.GL11115@waste.org> <461EE925.1000301@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EE925.1000301@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:21:25PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >On Fri, Apr 13, 2007 at 11:42:29AM +1000, Nick Piggin wrote:
> 
> >>If kprobes is simply crappy and doesn't work properly for this, then I
> >>could accept that. I'm not someone trying to get this info. So why can't
> >>it be used? (not just for kpagemap, but for clear_refs and all that gunk
> >>too).
> >
> >
> >kprobes is good for looking at events, but bad for looking at state.
> >Especially metric shitloads of state.
> 
> Why? Why is a kprobes trap significantly more expensive than a read
> syscall?

I guess I'm not clear on what you're proposing. From my understanding
of kprobes (admittedly not an expert), this is hard to do and not a
very good match.
 
> >>Maybe. How about LRU? Reclaim performance is bad, and you want to work out
> >>which pages keep going off the end of it, or which pages keep getting
> >>written out via it, or who's pages are on the active list, forcing mine
> >>out.
> >
> >
> >Those are actually probably a good match for systemtap as they're all 
> >events.
> 
> Traverse the LRU? Which files do they belong to? What process maps them?

-ENOPARSE.

-- 
Mathematics is the supreme nostalgia of our time.
