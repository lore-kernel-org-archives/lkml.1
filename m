Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZBETyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZBETyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbZBETyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:54:05 -0500
Received: from rtr.ca ([76.10.145.34]:41990 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762592AbZBETyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:54:03 -0500
Message-ID: <498B43D9.2080800@rtr.ca>
Date: Thu, 05 Feb 2009 14:54:01 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
References: <200901301729.30284.borntraeger@de.ibm.com> <200902030948.13519.borntraeger@de.ibm.com> <20090203122847.GG19979@elte.hu> <200902040719.25593.borntraeger@de.ibm.com> <1233777584.16238.16.camel@vayu> <20090204213202.GP22608@elte.hu>
In-Reply-To: <20090204213202.GP22608@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
>> On Tue, 2009-02-03 at 22:19 -0800, Christian Borntraeger wrote:
>>> Am Tuesday 03 February 2009 13:28:47 schrieb Ingo Molnar:
>>>>>> +         if (!cpu_active(cpu) {
>>>>> That does not compile...I used the following:
>>>>>             if (!cpu_active(cpu)) {
>>>> Could you please resubmit an updated patch?
>>> Suresh,
>>>
>>> can you send the updated patch? After all, its your work and we need your
>>> Signed-off-by anyway.
>>>
>>> You can add my
>>> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Thanks Christian for testing the fix. Ingo, appended is the updated patch. 
>> Thanks.
> 
> applied to tip:sched/urgent, thanks guys!
> 
> 	Ingo
..

How far back in (kernel release) time does this problem exist?
Candidate for -stable ?

Cheers
