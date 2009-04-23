Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZDWIha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZDWIha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZDWIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:37:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:41024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZDWIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:37:12 -0400
Message-ID: <49F028CF.4020006@suse.de>
Date: Thu, 23 Apr 2009 16:37:35 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 1/7] mach-mmp: add parameter to clksrc_read()
References: <49EF6A4D.3030606@suse.de> <f17812d70904222318n4b742c17y647b8a8ca5273112@mail.gmail.com>
In-Reply-To: <f17812d70904222318n4b742c17y647b8a8ca5273112@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Miao Wrote:
> This looks to be already fixed by Magnus Damm and merged in recent -rc3.
> 

>From my upstream clone, the last commit is
49cbe78637eb0503f45fc9b556ec08918a616534, which is
[ARM] pxa: add base support for Marvell's PXA168 processor line

I don't find Magnus' patch from upstream. Is that patch already merged in some
sub-system tree ?


> On Thu, Apr 23, 2009 at 3:04 AM, Coly Li <coly.li@suse.de> wrote:
>> After the patch to add parameter to uv_read_rtc(), I did a grep and found
>> several similar issues.
>>
>> This patch modifies parameter of clksrc_read() from 'void' to 'struct
>> clocksource *cs', which fixes compile warning for incompatible parameter type.
>>
>> Signed-off-by: Coly Li <coly.li@suse.de>
>> Cc: Eric Miao <eric.miao@marvell.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/arm/mach-mmp/time.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
>> index b03a6ed..a8400bb 100644
>> --- a/arch/arm/mach-mmp/time.c
>> +++ b/arch/arm/mach-mmp/time.c
>> @@ -136,7 +136,7 @@ static struct clock_event_device ckevt = {
>>        .set_mode       = timer_set_mode,
>>  };
>>
>> -static cycle_t clksrc_read(void)
>> +static cycle_t clksrc_read(struct clocksource *cs)
>>  {
>>        return timer_read();
>>  }
>>
>> --
>> Coly Li
>> SuSE Labs
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 

-- 
Coly Li
SuSE Labs
