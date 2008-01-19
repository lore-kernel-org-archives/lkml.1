Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYASFQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYASFQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYASFQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:16:20 -0500
Received: from mga07.intel.com ([143.182.124.22]:62341 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185AbYASFQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:16:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,219,1199692800"; 
   d="scan'208";a="369052651"
Message-ID: <47918792.2080201@linux.intel.com>
Date: Fri, 18 Jan 2008 21:16:02 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de>
In-Reply-To: <p73lk6m9ze7.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
> 
>> The Intel Open Source Technology Center is pleased to announce the
>> release of version 0.1 of LatencyTOP, a tool for developers to visualize
>> system latencies.
> 
> Just for completeness -- Linux already had a way to profile latencies
> since quite some time. It's little known unfortunately and doesn't
> work for modules since it's a special mode in the old non modular kernel
> profiler. 
> 
> You enable CONFIG_SCHEDSTATS and boot with profile=sleep and then you can
> use the readprofile command to read the data. Information can be reset with 
> echo > /proc/profile
> 
> There's also a profile=sched to profile the scheduler which works even
> without CONFIG_SCHEDSTATS

yes indeed; I sort of use the same infrastructure inside the scheduler; the biggest
reason I felt I had to do something different was that I wanted to do per process
data collection, so that you can see for a specific process what was going on.
