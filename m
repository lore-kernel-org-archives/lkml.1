Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYC1U7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYC1U7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYC1U7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:59:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64889 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYC1U7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:59:41 -0400
Message-ID: <47ED5BF5.4000809@oracle.com>
Date: Fri, 28 Mar 2008 13:58:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: Sebastien Dugue <sebastien.dugue@bull.net>, dsd@gentoo.org,
       trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/unaligned-memory-access.txt
References: <1206699042-1334-1-git-send-email-dmitri.vorobiev@gmail.com> <20080328132354.2a3b766e@bull.net> <47ED5B3F.7040401@gmail.com>
In-Reply-To: <47ED5B3F.7040401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> Sebastien Dugue wrote:
>>   Hi Dmitri,
>>
>>   one more typo I guess:
>>
>> On Fri, 28 Mar 2008 13:10:42 +0300 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
>>
>>> This patch deletes a couple of superfluous word occurrences in the
>>> document Documentation/unaligned-memory-access.txt.
>>> ---
>>> Sorry for a duplicate email, I forgot to Cc LKML when sending the patch.
>>>
>>>  Documentation/unaligned-memory-access.txt |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.txt
>>> index 6223eac..ed57b53 100644
>>> --- a/Documentation/unaligned-memory-access.txt
>>> +++ b/Documentation/unaligned-memory-access.txt
>>> @@ -57,7 +57,7 @@ here; a summary of the common scenarios is presented below:
>>>     unaligned access to be corrected.
>>>   - Some architectures are not capable of unaligned memory access, but will
>>>     silently perform a different memory access to the one that was requested,
>>> -   resulting a a subtle code bug that is hard to detect!
>>> +   resulting a subtle code bug that is hard to detect!
>>                 ^
>>                in a
> 
> Although those English dictionaries that I have consulted do indicate that
> "result" is an intransitive verb, there are many occurrences reported by Google
> when this verb takes a direct object like in the following phrase: "However,
> inner space of the stand 2 of the drum washing machine 1 is not used,
> resulting a problem of wasting space."
> 
> English is not my mother tongue so I can't claim I have a good ear for the
> language. Are there any native speakers who could help, please?

I'll ack the "in a" change.

> Dmitri
> 
>>   Sebastien.
>>
>>>  
>>>  It should be obvious from the above that if your code causes unaligned
>>>  memory accesses to happen, your code will not work correctly on certain
>>> @@ -209,7 +209,7 @@ memory and you wish to avoid unaligned access, its usage is as follows:
>>>  
>>>  	u32 value = get_unaligned((u32 *) data);
>>>  
>>> -These macros work work for memory accesses of any length (not just 32 bits as
>>> +These macros work for memory accesses of any length (not just 32 bits as
>>>  in the examples above). Be aware that when compared to standard access of
>>>  aligned memory, using these macros to access unaligned memory can be costly in
>>>  terms of performance.
> 


-- 
~Randy
