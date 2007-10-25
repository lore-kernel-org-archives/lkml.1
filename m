Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXJYWdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXJYWdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXJYWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:33:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXJYWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:33:09 -0400
Message-ID: <472118C7.3060909@zytor.com>
Date: Thu, 25 Oct 2007 15:29:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>	<20071025095639.22f6cad0@laptopd505.fenrus.org>	<4720CCBC.1050700@zytor.com>	<m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>	<4720D797.1020903@zytor.com>	<m1tzof3wbk.fsf@ebiederm.dsl.xmission.com>	<4720FE38.3050802@zytor.com> <m1lk9q4z17.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lk9q4z17.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Eric W. Biederman wrote:
>>>> Ying claimed that GOP requires EFI runtime services.  Is that not true?
>>> None of the EFI framebuffer patches that I saw used EFI runtime services.
>>>
>> Ying, could you please clarify this situation?
>>
>> (Eric: do note that there are two EFI framebuffer standard, UGA and
>> GOP. Apparently UGA is obsolete and we have always been at war with GOP at the
>> moment.)
> 
> Peter please look back in your email archives to yesterday and
> see Ying's patch:
> 
> [PATCH 1/2 -v2 resend] x86_64 EFI boot support: EFI frame buffer driver
> 
> All of the data the GOP needs is acquired through the a query made
> by the bootloader and passed through screen info.
> 

Then I fully agree with your assessment.

	-hpa
