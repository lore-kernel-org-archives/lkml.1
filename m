Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZHMISf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZHMISf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZHMISe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:18:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZHMISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:18:33 -0400
Message-ID: <4A83CCAA.1030302@redhat.com>
Date: Thu, 13 Aug 2009 16:19:54 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Bernhard Walle <bernhard.walle@gmx.de>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain> <20090812124659.GA4808@mail1.bwalle.de> <4A837F49.9060003@redhat.com> <20090813053952.GA9037@mail1.bwalle.de>
In-Reply-To: <20090813053952.GA9037@mail1.bwalle.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> Hi,
>
> * Amerigo Wang <amwang@redhat.com> [2009-08-13 04:49]:
>   
>> Bernhard Walle wrote:
>>     
>>> Honestly I don't see why everything is guarded by
>>> CONFIG_KEXEC_AUTO_RESERVE. We do we need that new configuration
>>> option? I mean, if I don't specify 'crashkernel=auto', then the patch
>>> does nothing, right? Then the option CONFIG_KEXEC_AUTO_RESERVE would
>>> only be needed so save some bytes of code. Is that really worth it?
>>>       
>> Hi,  CONFIG_KEXEC_AUTO_RESERVE is not for saving bytes, it just
>> provides a choice for the user to decide to enable it or not.
>>     
>
> Still, I don't understand it. When I don't say "crashkernel=auto" on
> command line, then nothing is done, right? So the choice for the user
> is the "crashkernel=auto". Why do we need CONFIG_KEXEC_AUTO_RESERVE
> then? Maybe I just missed something in my logic ...
>   
Sure.

But if we disable CONFIG_KEXEC_AUTO_RESERVE, that means crashkernel=auto 
will be invalid, this is the same as it is now.

