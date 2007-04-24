Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXDXUQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXDXUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXDXUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:16:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51360 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXDXUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:16:57 -0400
X-AuditID: d80ac287-ad0c9bb00000590d-0b-462e65b8ea2e 
Date: Tue, 24 Apr 2007 21:16:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <20070424101116.1cb7512e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Apr 2007 20:16:55.0876 (UTC) FILETIME=[81384040:01C786AD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, Hugh Dickins wrote:
> 
> > Or Christoph may prevail in persuading there's no such problem.
> 
> This is pointless. NUMA allocations can only be controlled for the highest 
> zone. If we switch to a lower zone then we allocate on a different zone 
> than the user requested.

Sorry, I'm not following you there.   Perhaps your comment is saying
that second patch is pointless, because it forces allocations elsewhere
than the policy requires?  Rather than commenting on the line you quote?

(When I said I didn't know if the patch would have unwanted side-effects
I was rather wondering what happens when you ask the allocator to do
some impossible combination.)

> If the system has both high memory and normal memory then only allocations 
> to highmemory are subject to memory policies etc etc. The block device 
> allocations would be in zone normal/dma and thus be exempt from NUMA 
> placement.

Please just point us to the line where sys_move_pages enforces this.

Hugh
