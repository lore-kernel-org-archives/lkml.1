Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZHNC7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZHNC7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZHNC7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:59:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZHNC7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:59:33 -0400
Message-ID: <4A84D2FD.1030909@redhat.com>
Date: Fri, 14 Aug 2009 10:59:09 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Bernhard Walle <bernhard.walle@gmx.de>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>	<20090812124659.GA4808@mail1.bwalle.de> <4A837F49.9060003@redhat.com>	<20090813053952.GA9037@mail1.bwalle.de> <4A83CCAA.1030302@redhat.com>	<20090813090335.GA9502@mail1.bwalle.de> <m1k5182dl7.fsf@fess.ebiederm.org>
In-Reply-To: <m1k5182dl7.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Bernhard Walle <bernhard.walle@gmx.de> writes:
>
>   
>> * Amerigo Wang <amwang@redhat.com> [2009-08-13 10:19]:
>>     
>>> Sure.
>>>
>>> But if we disable CONFIG_KEXEC_AUTO_RESERVE, that means
>>> crashkernel=auto will be invalid, this is the same as it is now.
>>>       
>> Ok, but since 'crashkernel=auto' is not used today, nobody has
>> 'crashkernel=auto' in the bootloader configuration. So I don't see any
>> practial advantage of that config option.
>>
>> Eric, what's your opinion on that, do we need a config option
>> CONFIG_KEXEC_AUTO_RESERVE or could we just implement that feature
>> unconditionally (if CONFIG_KEXEC is enabled, of course).
>>     
>
> The only reason I can see the option going away would be
> a dependency on CONFIG_HOTPLUG_MEM.
>   

I am not sure if I understand you correctly, but it doesn't and won't 
depend on CONFIG_MEMORY_HOTPLUG.

Thanks.

