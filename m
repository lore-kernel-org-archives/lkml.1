Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZBDINq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZBDINq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZBDINg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:13:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58500 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZBDINf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:13:35 -0500
Message-ID: <49894E24.2000908@redhat.com>
Date: Wed, 04 Feb 2009 10:13:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, hpa@zytor.com, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, arnd@arndb.de,
       mchehab@infradead.org, jens.axboe@oracle.com,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
References: <20090204064307.GA18415@gondor.apana.org.au> <1233734645.3198.2.camel@localhost.localdomain>
In-Reply-To: <1233734645.3198.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Wed, 2009-02-04 at 17:43 +1100, Herbert Xu wrote:
>   
>> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>>     
>>> diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
>>> index b95162a..d2e3bf3 100644
>>> --- a/arch/x86/include/asm/kvm.h
>>> +++ b/arch/x86/include/asm/kvm.h
>>> @@ -6,7 +6,7 @@
>>>  *
>>>  */
>>>
>>> -#include <asm/types.h>
>>> +#include <linux/types.h>
>>> #include <linux/ioctl.h>
>>>       
>> Awesome, you've just broken the userspace build of kvm as the
>> file linux/types.h conflicts with sys/types.h.
>>
>>     
>
> What I did is absolutely right.
>
>   

It was, though I'd have been happy to know about it in advance (maybe 
you did notify me; I was on vacation and haven't cleared the backlog yet).

> If there is any conflict then we need to solve it in better way.
>
> Can you please share what is the conflict and what you are expecting and
> what you are getting.
>   

I've already fixed kvm-userspace.git.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

