Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYC1Uzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYC1Uzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYC1Uzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:55:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:64114 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbYC1Uzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qNgEM9q396JLbTWzZblVnvKCXAX0npZ13tz0AZ2Cyo5S9Ob8JQNRbl9gEI6VUvmF9spDOxB21lFIMc4vIc39DN0ODnQrB2FEFXXGHvuGrPZb2hcSmH2xNhgayrz+PGMQKcjQgP15KrbhXIEQw3wP6VBPDf527Cb4JZH82wlZIrc=
Message-ID: <47ED5B3F.7040401@gmail.com>
Date: Fri, 28 Mar 2008 23:55:27 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Sebastien Dugue <sebastien.dugue@bull.net>
CC: dsd@gentoo.org, randy.dunlap@oracle.com, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/unaligned-memory-access.txt
References: <1206699042-1334-1-git-send-email-dmitri.vorobiev@gmail.com> <20080328132354.2a3b766e@bull.net>
In-Reply-To: <20080328132354.2a3b766e@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Dugue wrote:
>   Hi Dmitri,
> 
>   one more typo I guess:
> 
> On Fri, 28 Mar 2008 13:10:42 +0300 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
>> This patch deletes a couple of superfluous word occurrences in the
>> document Documentation/unaligned-memory-access.txt.
>> ---
>> Sorry for a duplicate email, I forgot to Cc LKML when sending the patch.
>>
>>  Documentation/unaligned-memory-access.txt |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.txt
>> index 6223eac..ed57b53 100644
>> --- a/Documentation/unaligned-memory-access.txt
>> +++ b/Documentation/unaligned-memory-access.txt
>> @@ -57,7 +57,7 @@ here; a summary of the common scenarios is presented below:
>>     unaligned access to be corrected.
>>   - Some architectures are not capable of unaligned memory access, but will
>>     silently perform a different memory access to the one that was requested,
>> -   resulting a a subtle code bug that is hard to detect!
>> +   resulting a subtle code bug that is hard to detect!
>                 ^
>                in a

Although those English dictionaries that I have consulted do indicate that
"result" is an intransitive verb, there are many occurrences reported by Google
when this verb takes a direct object like in the following phrase: "However,
inner space of the stand 2 of the drum washing machine 1 is not used,
resulting a problem of wasting space."

English is not my mother tongue so I can't claim I have a good ear for the
language. Are there any native speakers who could help, please?

Dmitri

> 
>   Sebastien.
> 
>>  
>>  It should be obvious from the above that if your code causes unaligned
>>  memory accesses to happen, your code will not work correctly on certain
>> @@ -209,7 +209,7 @@ memory and you wish to avoid unaligned access, its usage is as follows:
>>  
>>  	u32 value = get_unaligned((u32 *) data);
>>  
>> -These macros work work for memory accesses of any length (not just 32 bits as
>> +These macros work for memory accesses of any length (not just 32 bits as
>>  in the examples above). Be aware that when compared to standard access of
>>  aligned memory, using these macros to access unaligned memory can be costly in
>>  terms of performance.
> 

