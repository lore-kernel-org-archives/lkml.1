Return-Path: <linux-kernel-owner+w=401wt.eu-S1762565AbZDHPFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762565AbZDHPFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZDHPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:05:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59190 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbZDHPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:05:19 -0400
X-Sasl-enc: Yqu3+4goFix7mdT5TLUcOlzfXHNxUzhKT1gytVPbqJNw 1239203117
Message-ID: <49DCBD2A.60602@fastmail.fm>
Date: Wed, 08 Apr 2009 16:05:14 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu> <49DCBBDF.4040603@fastmail.fm>
In-Reply-To: <49DCBBDF.4040603@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> Ingo Molnar wrote:
>   
>> * Jack Stone <jwjstone@fastmail.fm> wrote:
>>
>>   
>>     
>>> Ingo Molnar wrote:
>>>     
>>>       
>>>> No, i mean, this approach should be changed, and i dont think any 
>>>> type cast change should go via any trivial tree. It's easy to mess 
>>>> it up. Please submit them to the maintainer trees
>>>>       
>>>>         
>>> Ok. I'll try and find appropriate CCs. I'm going out shortly so it 
>>> might take me a while.
>>>     
>>>       
>> Since you do many such patches it might make sense to script up a 
>> "who maintains what" kind of script - and share that script with 
>> lkml.
>>
>> I have this silly little script:
>>
>>   git log $@ | grep Signed-off-by: |
>>    cut -d: -f2 | cut -d\< -f1 |
>>     sort | uniq -c | sort -n
>>
>> To find out any recent parties that touches a particular file. But 
>> it would be nice to somehow automate the pickup of mailing-list 
>> addresses from MAINTAINERS for example. We've literally got hundreds 
>> of email lists there.
>>
>> It is not trivial to do though :-)
>>   
>>     
> It would be useful. The main problem is working out what files belong to
> what MAINTAINERS entries.
>
> I'll see what I can cook up.
>
> Thanks,
>
> Jack
>   
Look what turned up!

http://marc.info/?l=linux-kernel&m=123916809504492&w=2

Thanks,

Jack
