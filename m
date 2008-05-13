Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYEMKpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYEMKpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYEMKox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:44:53 -0400
Received: from ns2.protei.ru ([195.239.28.26]:39906 "EHLO mail.protei.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYEMKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:44:52 -0400
Message-ID: <482970DF.8020206@protei.ru>
Date: Tue, 13 May 2008 14:43:43 +0400
From: Nickolay Vinogradov <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
References: <481E076A.8060302@protei.ru> <20080512144507.8d770723.akpm@linux-foundation.org>
In-Reply-To: <20080512144507.8d770723.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:
> On Sun, 04 May 2008 22:58:50 +0400
> ____________________ ______________ ____________________ <nickolay@protei.ru> wrote:
> 
>> bugfix in fls64 on a big endian systems(against 2.6.25).
>>
>> Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>
>>
>> --
>>
>> diff --git a/include/asm-generic/bitops/fls64.h 
>> b/include/asm-generic/bitops/fls64.h
>> index 1b6b17c..2eedb6f 100644
>> --- a/include/asm-generic/bitops/fls64.h
>> +++ b/include/asm-generic/bitops/fls64.h
>> @@ -8,7 +8,7 @@ static inline int fls64(__u64 x)
>>          __u32 h = x >> 32;
>>          if (h)
>>                  return fls(h) + 32;
>> -       return fls(x);
>> +       return fls((__u32)x);
>>   }
>>
>>   #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
> 
> Please describe the bug which you are fixing?
> 
> Perhaps a more robust fix to <whatever the bug is> would be to
> repair fls() so that it works correctly when passed a u64.  Perhaps.

Repair fls64() so that it works correctly when passed a u64.

-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27
