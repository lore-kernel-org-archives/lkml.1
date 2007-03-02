Return-Path: <linux-kernel-owner+w=401wt.eu-S2992639AbXCBRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992639AbXCBRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992645AbXCBRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:19:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50793 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992639AbXCBRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:19:19 -0500
Date: Fri, 2 Mar 2007 09:19:17 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302163206.GA1555@skynet.ie>
Message-ID: <Pine.LNX.4.64.0703020916330.16719@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <20070302163206.GA1555@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Mel Gorman wrote:

> However, if that is objectionable, I'd at least like to see zone-based patches
> go into -mm on the expectation that the memory hot-remove patches will be
> able to use the infrastructure. It's not ideal for hugepages and it is not my
> first preference, but it's a step in the right direction. Is this reasonable?

I still think that the list based approach is sufficient for memory 
hotplug if one restricts  the location of the unmovable MAX_ORDER chunks 
to not overlap the memory area where we would like to be able to remove 
memory. In very pressing memory situations where we have too much 
unmovable memory we could dynamically disable  memory hotplug. There 
would be no need for this partitioning and additional zones.


