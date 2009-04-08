Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbZDHOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbZDHOqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZDHOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:46:42 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44322 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbZDHOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:46:41 -0400
X-Sasl-enc: VyhiEQLaZYcqiewFlA2BOsTUmxTQEV9z5kJwjjuNebU+ 1239202000
Message-ID: <49DCB8C5.4090108@fastmail.fm>
Date: Wed, 08 Apr 2009 15:46:29 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu>
In-Reply-To: <20090408144055.GH12931@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jack Stone <jwjstone@fastmail.fm> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Jack Stone <jwjstone@fastmail.fm> wrote:
>>>
>>>   
>>>       
>>>> Fixed patch
>>>>
>>>> Thanks,
>>>>     
>>>>         
>>> Hm, what was fixed?
>>>   
>>>       
>> I removed casts on pointer arithmetic which probably still needed to be
>> there to do the arithmetic properly.
>>     
>
> ... which pretty much proves the point that these patches should not 
> go via any "trivial" tree.
>
> Those additions of mmu pointers you did were outright lethal, i 
> doubt this stuff could have booted on both 32-bit and 64-bit x86.
>
> Please dont do this. Or if you do, please double check your change 
> and double check that the relevant vmlinux disassembly is still bit 
> for bit the same.
>   

Thats what I meant by fixed - those changes were removed from the patch.

Thanks,

Jack
