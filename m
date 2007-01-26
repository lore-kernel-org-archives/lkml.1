Return-Path: <linux-kernel-owner+w=401wt.eu-S1161070AbXAZRpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbXAZRpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161087AbXAZRpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:45:54 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:33622 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161070AbXAZRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:45:53 -0500
Date: Fri, 26 Jan 2007 09:45:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <Pine.LNX.4.64.0701261727400.23091@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260944270.7457@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261720120.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260921310.7301@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261727400.23091@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Mel Gorman wrote:

> It's come up a few times and the converation is always fairly similar although
> the thread http://lkml.org/lkml/2006/9/22/44 has interesting information on
> the topic. There has been no serious discussion on whether anti-fragmentation
> would help it or not. I think it would if atomic allocations were clustered
> together because then jumbo frame allocations would cluster together in the
> same MAX_ORDER blocks and tend to keep other allocations away.

They are clustered in both schemes together with other non movable allocs 
right? The problem is to defrag while atomic? How is the zone based 
concept different in that area from the max order block based one?


