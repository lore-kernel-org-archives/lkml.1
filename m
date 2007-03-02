Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXCBBwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXCBBwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965061AbXCBBwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:52:37 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33870 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917AbXCBBwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:52:37 -0500
Message-ID: <45E7835A.8000908@in.ibm.com>
Date: Fri, 02 Mar 2007 07:22:26 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 1 Mar 2007, Andrew Morton wrote:
>> So some urgent questions are: how are we going to do mem hotunplug and
>> per-container RSS?
> 
> Also: how are we going to do this in virtualized environments? Usually the 
> people who care abotu memory hotunplug are exactly the same people who 
> also care (or claim to care, or _will_ care) about virtualization.
> 
> My personal opinion is that while I'm not a huge fan of virtualization, 
> these kinds of things really _can_ be handled more cleanly at that layer, 
> and not in the kernel at all. Afaik, it's what IBM already does, and has 
> been doing for a while. There's no shame in looking at what already works, 
> especially if it's simpler.

Could you please clarify as to what "that layer" means - is it the
firmware/hardware for virtualization? or does it refer to user space?
With virtualization the linux kernel would end up acting as a hypervisor
and resource management support like per-container RSS support needs to
be built into the kernel.

It would also be useful to have a resource controller like per-container
RSS control (container refers to a task grouping) within the kernel or
non-virtualized environments as well.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
