Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYB0JGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYB0JGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 04:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYB0JGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 04:06:36 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:45512 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYB0JGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:06:35 -0500
Message-ID: <47C526F8.8010807@linux.vnet.ibm.com>
Date: Wed, 27 Feb 2008 14:31:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
References: <47C4EF2D.90508@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262115270.1799@chino.kir.corp.google.com> <20080227143301.4252.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.00.0802262145410.31356@chino.kir.corp.google.com> <47C4F9C0.5010607@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com> <47C51856.7060408@linux.vnet.ibm.com> <alpine.DEB.1.00.0802270045400.31372@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802270045400.31372@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Wed, 27 Feb 2008, Balbir Singh wrote:
> 
>> Let's forget node hotplug for the moment, but what if someone
>>
>> 1. Changes the machine configuration and adds more nodes, do we expect the
>> kernel to be recompiled? Or is it easier to update /etc/sysctl.conf?
>> 2. Uses fake NUMA nodes and increases/decreases the number of nodes across
>> reboots. Should the kernel be recompiled?
>>
> 
> That is why the proposal was made to make this a static configuration 
> option, such as CONFIG_NUM_RECLAIM_THREADS_PER_NODE, that will handle both 
> situations.
> 

You mentioned CONFIG_NUM_RECLAIM_THREADS_PER_CPU and not
CONFIG_NUM_RECLAIM_THREADS_PER_NODE. The advantage with syscalls is that even if
we get the thing wrong, the system administrator has an alternative. Please look
through the existing sysctl's and you'll see what I mean. What is wrong with
providing the flexibility that comes with sysctl? We cannot possibly think of
all situations and come up with the right answer for a heuristic. Why not come
up with a default and let everyone use what works for them?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
