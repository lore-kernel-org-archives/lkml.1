Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbXFRRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbXFRRYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbXFRRYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:24:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34992 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755000AbXFRRYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:24:46 -0400
Date: Mon, 18 Jun 2007 10:24:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/7] Memory Compaction v2
In-Reply-To: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0706181022530.4751@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Mel Gorman wrote:

> The patchset implements memory compaction for the page allocator reducing
> external fragmentation so that free memory exists as fewer, but larger
> contiguous blocks. Instead of being a full defragmentation solution,
> this focuses exclusively on pages that are movable via the page migration
> mechanism.

We need an additional facility at some point that allows the moving of 
pages that are not on the LRU. Such support seems to be possible
for page table pages and slab pages.
