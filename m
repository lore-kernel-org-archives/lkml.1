Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbYASFZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbYASFZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYASFZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:25:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:17822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYASFZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:25:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,219,1199692800"; 
   d="scan'208";a="291657850"
Message-ID: <479189BF.2000403@linux.intel.com>
Date: Fri, 18 Jan 2008 21:25:19 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com> <20080119052709.GA28467@one.firstfloor.org>
In-Reply-To: <20080119052709.GA28467@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> yes indeed; I sort of use the same infrastructure inside the scheduler; the 
>> biggest
>> reason I felt I had to do something different was that I wanted to do per 
>> process
>> data collection, so that you can see for a specific process what was going 
>> on.
> 
> Wouldn't it have been easier then to just extend the sleep profiler to
> oprofile? oprofile already has pid filters and can do per process 
> profiling.

it's more complex than that
> 
> On the other hand I'm not fully sure only doing per pid profiling
> is that useful. After all often latencies come from asynchronous
> threads (like kblockd). So a system level view is probably better
> anyways. 

another thing that the current profiling can't do, is to show what the system is doing
when it hits the latency.. so someone calling fsync() will show up in the waiting for
IO function, but not that it was due to an fsync().
