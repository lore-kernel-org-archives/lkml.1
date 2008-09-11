Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYIKI2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYIKI2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYIKI2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:28:08 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48928 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYIKI2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:28:07 -0400
Message-ID: <48C8D731.4000309@keyaccess.nl>
Date: Thu, 11 Sep 2008 10:30:41 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP PAT issue.
References: <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <48AF1B6A.80408@keyaccess.nl> <48C8259B.7040702@keyaccess.nl> <20080911081702.GA27425@elte.hu>
In-Reply-To: <20080911081702.GA27425@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-08 10:17, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 22-08-08 22:02, Rene Herman wrote:
>>
>>> On 22-08-08 06:15, Ingo Molnar wrote:
>>>> The frontside cache itself is in x86/urgent:
>>>>
>>>>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
>>>>
>>>> ... and should at least solve the symptom that you've hit in practice 
>>>> (the slowdown), without changing the underlying PAT machinery. (which 
>>>> would be way too dangerous for v2.6.27)
>>> Well, please note that that specific commit only fixes X startup -- it  
>>> doesn't do anything for shutdown. With only that one, I'm still at 14  
>>> seconds for X shutdown (first time after boot that is, 5 seconds  
>>> subsequent shutdowns) versus 1 (or sub 1, feels immediate) normally.
>>>
>>> It's also a black-screen "hang", so we'll probably be getting a lot of  
>>> "long hang at shutdown" reports without something additionally for .27.
>>>
>>> Venki?
>> Haven't been subcribed to any lists recently and someone was talking 
>> about "the other thread" before but just noticed that an -rc6 was cut.
>>
>> Please note that the shutdown issue remains unfixed in it (I'm doing 
>> my coalescing changes locally).
> 
> here's what is pending in tip/x86/pat for v2.6.28:

Only talking about .27 and just making sure again the issue is known.

The above mentioned subject for the entry cache one ("fix Xorg 
startup/shutdown slowdown with PAT") after all mistakingly says it does 
something for shutdown.

Rene.
