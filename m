Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbXDDWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbXDDWBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXDDWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:01:00 -0400
Received: from waste.org ([66.93.16.53]:48048 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXDDWA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:00:59 -0400
Date: Wed, 4 Apr 2007 16:48:29 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
Message-ID: <20070404214828.GA4892@waste.org>
References: <7.486631555@selenic.com> <461320C9.5030601@yahoo.com.au> <20070404050857.GU4892@waste.org> <46133CC0.505@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46133CC0.505@yahoo.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 03:50:56PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >On Wed, Apr 04, 2007 at 01:51:37PM +1000, Nick Piggin wrote:
> >
> >>Matt Mackall wrote:
> >>
> >>>Move the page walker code to lib/
> >>>
> >>>This lets it get shared outside of proc/ and linked in only when
> >>>needed.
> >>
> >>I think it would be better in mm/.
> >
> >
> >I originally was looking at putting it in mm/memory.c and possibly
> 
> Just put it in its own file in mm/ rather than its own file in lib.
> lib should be for almost-standalone stuff, IMO (ie. only using basic
> kernel functionality).

Arguably that's what lib/ should be for, but it's currently largely
used to avoid linking in unused code without adding more hair to
Kconfig. Which is what I'm trying to do here.

> Apart from these users outside mm/, I don't see much point in converting
> things over. The page table walking API we have now is neat and simple.
> It takes a few lines of code, but is it a big problem?

I don't think it really qualifies as either neat or simple. It may be
about as neat as walking a heterogenous tree with an inconsistent
naming scheme can be, but it's still a headache. A maze of twisty
little passages, all slightly different.

-- 
Mathematics is the supreme nostalgia of our time.
