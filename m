Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbYB1UHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbYB1UHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYB1UHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:07:03 -0500
Received: from gw.goop.org ([64.81.55.164]:34234 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYB1UHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:07:00 -0500
Message-ID: <47C71374.8010808@goop.org>
Date: Thu, 28 Feb 2008 12:03:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xming <xmingske@gmail.com>
CC: "Christopher S. Aker" <caker@theshore.net>,
       virtualization@lists.linux-foundation.org,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47758352.5040504@goop.org>	 <479E71B7.7060207@theshore.net> <479E75E3.6030601@goop.org>	 <479E7BA4.5050306@theshore.net>	 <519a8b110802060437k70c099b7y7faefe63dd82039@mail.gmail.com>	 <47AA845E.8020708@goop.org> <519a8b110802070612j2a1717f3s6aa25eeea8b7d18a@mail.gmail.com>
In-Reply-To: <519a8b110802070612j2a1717f3s6aa25eeea8b7d18a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xming wrote:
> On Feb 7, 2008 5:09 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> xming wrote:
>>     
>>> But I do have one problem after I upgraded to xen 3.2, the 2.6.23.x domU do
>>> not boot any more and 2.6.24 does boot but will hang after cpufreq changes
>>> the frequency.
>>>
>>>       
>> Interesting.  Do you mean dom0 cpufreq frequency changes will cause the
>> domU to hang?
>>
>>     J
>>
>>     
>
> Yes, when Dom0 changes freq while domU is doing something will trigger this.
> When using "on demand" will trigger this very eassily.
>
> This is from xm top when a domU hangs:
>
>     test32 ------       4018   98.8     131072    6.4     131072
> 6.4     1    1     4516    50087    1        0   433908   300403
> 3084907223
>
> So it appers to be running (eating CPU) sometimes the state is "r"
> sometimes "-",
> but both console and network are dead.
>   

I haven't tried to repro this yet, but I suspect I won't be able to 
because all my test machines have constant_tsc.  Does CPU change TSC 
rate on processor speed changes?

    J
