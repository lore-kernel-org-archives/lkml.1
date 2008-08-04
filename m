Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHDOso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHDOso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYHDOse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:48:34 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45889 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYHDOse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:48:34 -0400
Date: Mon, 4 Aug 2008 15:48:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Message-ID: <20080804144823.GE18868@shareable.org>
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <48970779.80902@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48970779.80902@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Matthew Wilcox wrote:
> > On Fri, May 09, 2008 at 07:21:01PM -0700, Christoph Lameter wrote:
> >> - Add a patch that obsoletes SLAB and explains why SLOB does not support
> >>   defrag (Either of those could be theoretically equipped to support
> >>   slab defrag in some way but it seems that Andrew/Linus want to reduce
> >>   the number of slab allocators).
> > 
> > Do we have to once again explain that slab still outperforms slub on at
> > least one important benchmark?  I hope Nick Piggin finds time to finish
> > tuning slqb; it already outperforms slub.
> > 
> 
> Uhh. I forgot to delete that statement. I did not include the patch
> in the series.
> 
> We have a fundamental issue design issue there. Queuing on free can result in
> better performance as in SLAB. However, it limits concurrency (per node lock
> taking) and causes latency spikes due to queue processing (f.e. one test load
> had 118.65 vs. 34 usecs just by switching to SLUB).

Vaguely on this topic, has anyone studied the effects of SLAB/SLUB
etc. on MMUless systems?

-- Jamie
