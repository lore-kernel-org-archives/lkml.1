Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZD0Hxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZD0Hxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZD0HxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:53:25 -0400
Received: from mga12.intel.com ([143.182.124.36]:26094 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994AbZD0HxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:53:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,253,1239001200"; 
   d="scan'208";a="136229916"
Message-ID: <49F5646F.4000305@linux.intel.com>
Date: Mon, 27 Apr 2009 09:53:19 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>	 <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>	 <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>	 <20090424100943.GJ27264@erda.amd.com>	 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-04-24 at 21:36 +0800, Steven Rostedt wrote:
>> On Fri, 24 Apr 2009, Robert Richter wrote:
>>>> It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
>>>> used in NMI context and interrupt context. When will ring_buffer to be
>>>> NMI-safe?
>>> You can use it in nmi context with separate read and write
>>> buffers. See this patch description:
>>> 6dad828b76c7224a22ddc9ce7aa495d994f03b31
>>>
>>> Not sure if somebody will make the ring_buffer non-locking.
>> It already is ;-)
>>
>> I've put in for a patent application on the algorithm so I must wait till 
>> it is processed before I can release the code.
> 
> When will it be merged by mainline kernel? Do you have a plan?

Patent applications tend to be measured in years. Also I'm not sure
we really want patented algorithms in the kernel anyways if it can
be avoided. So the patent probably makes it impractical to use this
thing at all.

-Andi
