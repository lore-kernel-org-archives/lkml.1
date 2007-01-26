Return-Path: <linux-kernel-owner+w=401wt.eu-S1161068AbXAZRUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068AbXAZRUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161066AbXAZRUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:20:49 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:41011 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161068AbXAZRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:20:49 -0500
Date: Fri, 26 Jan 2007 17:20:47 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701261720120.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Christoph Lameter wrote:

> On Fri, 26 Jan 2007, Mel Gorman wrote:
>
>> Because Andrew has made it pretty clear he will not take those patches on the
>> grounds of complexity - at least until it can be shown that they fix the e1000
>> problem. Any improvement on the behavior of those patches such as address
>> biasing to allow memory hot-remove of the higher addresses makes them even
>> more complex.
>
> What is the e1000 problem? Jumbo packet allocation via GFP_KERNEL?
>

Yes. Potentially the anti-fragmentation patches could address this by 
clustering atomic allocations together as much as possible.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
