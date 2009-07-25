Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZGYEdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZGYEdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 00:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZGYEdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 00:33:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:42122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZGYEdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 00:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,268,1246863600"; 
   d="scan'208";a="535806935"
Message-ID: <4A6A8AFE.1010608@linux.intel.com>
Date: Fri, 24 Jul 2009 21:33:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sched: Provide iowait counters
References: <4A64B813.1080506@linux.intel.com> <20090724212220.afa278ee.akpm@linux-foundation.org>
In-Reply-To: <20090724212220.afa278ee.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 20 Jul 2009 11:31:47 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> For counting how long an application has been waiting for (disk) IO,
>> there currently is only the HZ sample driven information available, while
>> for all other counters in this class, a high resolution version is
>> available via CONFIG_SCHEDSTATS.
>>
>> In order to make an improved bootchart tool possible, we also need
>> a higher resolution version of the iowait time.
>>
>> This patch below adds this scheduler statistic to the kernel.
> 
> Doesn't this duplicate the delay accounting already available via the
> taskstats interface?

we have how long we wait. we do not have how long we iowait afaik...
at least not in nanosecond granularity. (We do have the sampled data, but that
is milisecond sampled data, not very useful for making charts based on time
to show the sequence of events)
