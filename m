Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZGYR4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZGYR4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZGYR4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:56:03 -0400
Received: from mga07.intel.com ([143.182.124.22]:53192 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbZGYR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:56:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,269,1246863600"; 
   d="scan'208";a="168888641"
Message-ID: <4A6B4731.5050400@linux.intel.com>
Date: Sat, 25 Jul 2009 10:56:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sched: Provide iowait counters
References: <4A64B813.1080506@linux.intel.com>	 <20090724212220.afa278ee.akpm@linux-foundation.org>	 <4A6A8AFE.1010608@linux.intel.com>	 <20090724214006.7380c3b4.akpm@linux-foundation.org>	 <4A6A8E96.7050509@linux.intel.com>	 <20090724220423.11828b85.akpm@linux-foundation.org>	 <1248501946.6987.146.camel@twins>	 <20090725002148.5524c846.akpm@linux-foundation.org>	 <4A6B35F7.2030804@linux.intel.com> <1248543674.5780.36.camel@laptop>
In-Reply-To: <1248543674.5780.36.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2009-07-25 at 09:42 -0700, Arjan van de Ven wrote:
>> In case you wonder why you need both tools, and can't just use one: we
>> wondered the same, but it turns out that if you only build
>> Tool Two, you don't get a good overview of what is going on on a
>> higher level. It's like looking at the world via a microscope all the
>> time,
> 
> I'd be thinking you could compose your ms based picture on the sample
> data. For instance, if you sample on cpu-clock at 100kHz, then a 100
> samples get you a full blue slice, 50 get you a 50% blue slice, etc.

we can compose part of it from the details (but there's a lot of details),
but not nearly all of it, things like the IO bandwidth etc we just can't
do this with.

we could do this for cpu use to a large degree though I suppose

