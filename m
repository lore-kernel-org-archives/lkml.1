Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbXHIUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbXHIUvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXHIUva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:51:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59689 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbXHIUv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:51:29 -0400
Date: Thu, 9 Aug 2007 21:51:27 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple zonelists v2
Message-ID: <20070809205126.GA8746@skynet.ie>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie> <20070809131943.64cb0921.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070809131943.64cb0921.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/08/07 13:19), Andrew Morton didst pronounce:
> On Wed,  8 Aug 2007 17:15:04 +0100 (IST)
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The following patches replace multiple zonelists per node with one zonelist
> > that is filtered based on the GFP flags.
> 
> I think I'll duck this for now on im-trying-to-vaguely-stabilize-mm grounds.
> Let's go with the horrible-hack for 2.6.23, then revert it and get this
> new approach merged and stabilised over the next week or two?
> 

I'm happy with that plan. I am about to release V3 of the one-zonelist
patchset that includes optimisations so I'm reasonably confident we can
get it to a state we like over the next few weeks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
