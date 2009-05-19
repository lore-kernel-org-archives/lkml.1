Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZESULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZESULZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZESULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:11:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43512 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZESULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:11:19 -0400
Message-ID: <4A131247.5010103@redhat.com>
Date: Tue, 19 May 2009 16:10:47 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dannf@hp.com" <dannf@hp.com>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org> <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com> <20090420172045.GA17887@elte.hu> <49ECBD31.9010607@intel.com>
In-Reply-To: <49ECBD31.9010607@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * Brian Maly <bmaly@redhat.com> wrote:
>>
>>>> Hm, it would be nice to first unify the relevant bits of 
>>>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
>>>> then we can apply such patches without duplicative effects.
>>> Ingo,
>>>
>>> Are you OK with consolidating this into arch/x86/kernel/rtc.c as 
>>> Huang Ying had suggested? This seems like the most logical place for 
>>> the rtc-efi init to happen, but your suggestion to consolidate this 
>>> into arch/x86/kernel.time.c may have advantages that I am not aware 
>>> of.  Anyway, I would appreciate any insight/opinions on this if you 
>>> have any.  Thanks.
>>
>> Yes, that indeed sounds like an even better place for it.
>>
>
> Furthermore, the EFI RTC code probably should be in its own file.
>
> In fact, arch/x86/kernel really could use more subdirectories; at 
> least the EFI and UV-specific code should be be moved out.
>
>     -hpa
>
Peter,

 How do you think this should be restructured (ideally)?

Maybe create a sub-directory (arch/x86/kernel/rtc) and in this 
sub-directory split the existing rtc.c code into:
(1) rtc.c for common code used by all RTC, 
(2) efi_rtc.c for EFI specific code
(3) cmos_rtc.c for cmos/legacy specific code

Anyone have any objections/concerns with this or perhaps have a better way?

Brian



