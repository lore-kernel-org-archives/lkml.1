Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXAZUiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXAZUiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030793AbXAZUiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:38:02 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:44312 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787AbXAZUiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:38:01 -0500
Date: Fri, 26 Jan 2007 20:37:59 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <Pine.LNX.4.64.0701261019210.7848@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701262036200.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261720120.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260921310.7301@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261727400.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260944270.7457@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261747290.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701261019210.7848@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Christoph Lameter wrote:

> On Fri, 26 Jan 2007, Mel Gorman wrote:
>
>> The zone-based approach does nothing to help jumbo frame allocations. It only
>> helps hugepage allocations at runtime and potentially memory hot-remove.
>
> Sounds like the max order based approach is better in many ways.

I agree but too many people are not pleased with the main allocator path 
being affected and wanted to see zones, so here we are :)

> Also avoids modifications to vmstat.c/.h ;-)
>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
