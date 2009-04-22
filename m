Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZDVLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZDVLfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZDVLf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:35:26 -0400
Received: from mga05.intel.com ([192.55.52.89]:41411 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbZDVLf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,230,1239001200"; 
   d="scan'208";a="450263278"
Message-ID: <49EF00FA.8090204@linux.intel.com>
Date: Wed, 22 Apr 2009 13:35:22 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>, Huang Ying <ying.huang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <20090422101911.GB1115@elte.hu>
In-Reply-To: <20090422101911.GB1115@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
>> On 22.04.09 11:22:59, Ingo Molnar wrote:
>>> * Huang Ying <ying.huang@intel.com> wrote:
>>>
>>>> Re-implement MCE log ring buffer as per-CPU ring buffer for better 
>>>> scalability. Basic design is as follow:
>>> Before changing anything substantial in the MCE code it would be 
>>> necessary to clean up and then unify the 32-bit and 64-bit side 
>>> of the MCE code first. (Which essentially means extending the 
>>> 64-bit-only code to 32-bit)
>> You may also want to consider to use the in-kernel ring_buffer api 
>> (include/linux/ring_buffer.h).
> 
> Yeah. I'd have suggested that once cleanups and unification is done 
> (which is still a long way out :-).

Hi Ingo,

If you can tell us clearly how to do this I can work on it. e.g.
if the scheme laid out in my earlier mail is acceptable and
I can port these patches to mce2 I mentioned and that can be hopefully
all done quickly.

However I don't agree with you stalling important hardware support
and bug fix code  for a long time just because you have something
half baked in tree and I hope you won't pursue such a policy.

-Andi

