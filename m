Return-Path: <linux-kernel-owner+w=401wt.eu-S2992594AbXCBQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992594AbXCBQbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992593AbXCBQbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:31:51 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49234 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592AbXCBQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:31:50 -0500
Message-ID: <45E8516B.5090203@austin.ibm.com>
Date: Fri, 02 Mar 2007 10:31:39 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Bill Irwin <bill.irwin@oracle.com>, akpm@linux-foundation.org,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       arjan@infradead.org, torvalds@osdl.org, mbligh@mbligh.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070302015235.GG10643@holomorphy.com> <Pine.LNX.4.64.0703021018070.32022@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0703021018070.32022@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Exhibiting a workload where the list patch breaks down and the zone
>> patch rescues it might help if it's felt that the combination isn't as
>> good as lists in isolation. I'm sure one can be dredged up somewhere.
> 
> I can't think of a workload that totally makes a mess out of list-based. 
> However, list-based makes no guarantees on availability. If a system 
> administrator knows they need between 10,000 and 100,000 huge pages and 
> doesn't want to waste memory pinning too many huge pages at boot-time, 
> the zone-based mechanism would be what he wanted.

 From our testing with earlier versions of list based for memory hot-unplug on 
pSeries machines we were able to hot-unplug huge amounts of memory after running the 
nastiest workloads we could find for over a week.  Without the patches we were unable 
to hot-unplug anything within minutes of running the same workloads.

If something works for 99.999% of people (list based) and there is an easy way to 
configure it for the other 0.001% of the people ("zone" based) I call that a great 
solution.  I really don't understand what the resistance is to these patches.

