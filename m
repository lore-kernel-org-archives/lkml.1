Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbZDHPAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbZDHPAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763432AbZDHO7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:59:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56121 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758828AbZDHO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:59:49 -0400
X-Sasl-enc: uxbLZaLr3vQfM4o/p+cdfC7ImwYnvQU1EYEU7Mgsiy2Z 1239202788
Message-ID: <49DCBBDF.4040603@fastmail.fm>
Date: Wed, 08 Apr 2009 15:59:43 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu>
In-Reply-To: <20090408145715.GO12931@elte.hu>
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
>>> No, i mean, this approach should be changed, and i dont think any 
>>> type cast change should go via any trivial tree. It's easy to mess 
>>> it up. Please submit them to the maintainer trees
>>>       
>> Ok. I'll try and find appropriate CCs. I'm going out shortly so it 
>> might take me a while.
>>     
>
> Since you do many such patches it might make sense to script up a 
> "who maintains what" kind of script - and share that script with 
> lkml.
>
> I have this silly little script:
>
>   git log $@ | grep Signed-off-by: |
>    cut -d: -f2 | cut -d\< -f1 |
>     sort | uniq -c | sort -n
>
> To find out any recent parties that touches a particular file. But 
> it would be nice to somehow automate the pickup of mailing-list 
> addresses from MAINTAINERS for example. We've literally got hundreds 
> of email lists there.
>
> It is not trivial to do though :-)
>   
It would be useful. The main problem is working out what files belong to
what MAINTAINERS entries.

I'll see what I can cook up.

Thanks,

Jack
