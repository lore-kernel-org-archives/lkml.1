Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbXKHS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbXKHS7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbXKHS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:59:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761075AbXKHS7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:59:30 -0500
Date: Thu, 8 Nov 2007 10:59:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 07/23] SLUB: Add defrag_ratio field and sysfs support.
In-Reply-To: <20071108150705.GD2591@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081057290.8954@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011228.102370371@sgi.com>
 <20071108150705.GD2591@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> On (06/11/07 17:11), Christoph Lameter didst pronounce:
> > The defrag_ratio is used to set the threshold at which defragmentation
> > should be run on a slabcache.
> > 
> 
> I'm thick, I would like to see a quick note here on what defragmentation
> means. Also, this defrag_ratio seems to have a significantly different
> meaning to the other defrag_ratio which isn't helping my poor head at
> all.

Yes that is why they have different names. The remote_node_defrag ratio 
controls the amount of remote allocs we do to reduce fragmentation.
 
> "The defrag_ratio sets a threshold at which a slab will be vacated of all
> it's objects and the pages freed during memory reclaim."

Sortof. If a slab is beyond the threshold during reclaim then reclaim will 
attempt to free the remaining objects in the slab to reclaim the whole 
slab.
