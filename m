Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZD0OhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZD0OhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZD0Og6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:36:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:30573 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752952AbZD0Og6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,254,1239001200"; 
   d="scan'208";a="685308687"
Message-ID: <49F5C305.60807@linux.intel.com>
Date: Mon, 27 Apr 2009 16:36:53 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Patenting kernel patches was Re: Re-implement MCE log ring buffer
 as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>  <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>  <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>  <20090424100943.GJ27264@erda.amd.com>  <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <alpine.DEB.2.00.0904271026140.24293@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904271026140.24293@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> I've put in for a patent application on the algorithm so I must wait till 
>>> it is processed before I can release the code.
>> When will it be merged by mainline kernel? Do you have a plan?
>>
>> We do have some scalability issues of current mcelog implementation, and
>> hopes that can be solved as soon as possible, perhaps for 2.6.31?
> 
> Yes, I plan on being able to post it before the 31 merge window opens. 
> I'll ping the lawyer to expedite the process.

Sorry, but this is quite ridiculous. Are you serious?

Why would we want such a patented algorithm in the kernel? Normally the standard
policy is to avoid patented algorithms (unless there's really no alternative like
with RCU which is clearly not the case here) and I'm not aware of this policy haven't
changed.

And also holding up perfectly good uncontaminated patches for something
patented seems especially wrong.

I think we should move forward with a standard non patented ring
buffer Ying was working on for this and avoid the patent mess as
far as possible.

-Andi (who wonders if he isn't in bizarro land now)

