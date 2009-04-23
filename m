Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbZDWEgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbZDWEgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZDWEfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:35:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:36500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDWEfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:35:50 -0400
Message-ID: <49EFF040.1010205@suse.de>
Date: Thu, 23 Apr 2009 12:36:16 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 7/7] xtensa: add parameter to ccount_read()
References: <49EF6C16.9020604@suse.de> <20090422220719.GA3602@cmpxchg.org>
In-Reply-To: <20090422220719.GA3602@cmpxchg.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Johannes Weiner Wrote:
> On Thu, Apr 23, 2009 at 03:12:22AM +0800, Coly Li wrote:
>> This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
>> clocksource *cs', which fixes compile warning for incompatible parameter type.
> 
> Changelog should be adjusted to say 'ccount_read()' here ;)
> 

Obviously this is a copy+past mistake. I modified the email title, but missed
the changelog :(

>> Signed-off-by: Coly Li <coly.li@suse.de>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/xtensa/kernel/time.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
>> index 8848120..9638641 100644
>> --- a/arch/xtensa/kernel/time.c
>> +++ b/arch/xtensa/kernel/time.c
>> @@ -30,7 +30,7 @@ unsigned long ccount_per_jiffy;		/* per 1/HZ */
>>  unsigned long nsec_per_ccount;		/* nsec per ccount increment */
>>  #endif
>>
>> -static cycle_t ccount_read(void)
>> +static cycle_t ccount_read(struct clocksource *cs)
>>  {
>>  	return (cycle_t)get_ccount();
>>  }
> 
> Thanks.  Copied Chris as well.

Need I resend another patch which fixes the changelog ?

Thanks.
-- 
Coly Li
SuSE Labs
