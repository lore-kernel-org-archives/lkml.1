Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZFRBZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZFRBZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZFRBZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:25:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:48368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFRBZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:25:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,240,1243839600"; 
   d="scan'208";a="155830028"
Date: Thu, 18 Jun 2009 09:25:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
	citizen
Message-ID: <20090618012532.GB19732@localhost>
References: <20090516090005.916779788@intel.com> <1242485776.32543.834.camel@laptop> <20090617141135.0d622bfe@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617141135.0d622bfe@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 05:11:35AM +0800, Jesse Barnes wrote:
> On Sat, 16 May 2009 16:56:16 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2009-05-16 at 17:00 +0800, Wu Fengguang wrote:
> > > Andrew,
> > > 
> > > This patchset makes mapped executable pages the first class citizen.
> > > This version has incorparated many valuable comments from people in
> > > the CC list, and runs OK on my desktop. Let's test it in your -mm?
> > 
> > Seems like a good set to me. Thanks for following this through Wu!
> 
> Now that this set has hit the mainline I just wanted to chime in and
> say this makes a big difference.  Under my current load (a parallel
> kernel build and virtualbox session the old kernel would have been
> totally unusable.  With Linus's current bits, things are much better
> (still a little sluggish with a big dd going on in the virtualbox, but
> actually usable).
> 
> Thanks!

Jesse, thank you for the feedback :)  And I'd like to credit Rik for
his patch on protecting active file LRU pages from being flushed by
streaming IO!

Thanks,
Fengguang
