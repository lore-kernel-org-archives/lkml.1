Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXAWUbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXAWUbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933128AbXAWUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:31:50 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:62016 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbXAWUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:31:49 -0500
Message-ID: <45B670F5.7030008@student.ltu.se>
Date: Tue, 23 Jan 2007 21:32:53 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Noah Watkins <nwatkins@ittc.ku.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] whitespace cleanup for 2.6.20-rc5-rt7
References: <11693256381932-git-send-email-nwatkins@ittc.ku.edu>	<20070122195836.GC21277@elte.hu>	<6bffcb0e0701221354j341e9f07s761c6c049d7196ce@mail.gmail.com>	<45B54BE7.5030805@student.ltu.se> <87sle2mvv5.wl%takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <87sle2mvv5.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi wrote:
> At Tue, 23 Jan 2007 00:42:31 +0100,
> Richard Knutsson wrote:
>   
>> Michal Piotrowski wrote:
>>     
>>> How about this script?
>>>
>>> "d) Ensure that your patch does not add new trailing whitespace.  The 
>>> below
>>>   script will fix up your patch by stripping off such whitespace.
>>>
>>>     #!/bin/sh
>>>
>>>     strip1()
>>>     {
>>>         TMP=$(mktemp /tmp/XXXXXX)
>>>         cp "$1" "$TMP"
>>>         sed -e '/^+/s/[     ]*$//' <"$TMP" >"$1"
>>>         rm "$TMP"
>>>     }
>>>
>>>     for i in "$@"
>>>     do
>>>         strip1 "$i"
>>>     done
>>> "
>>> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
>>>       
>> I believe:
>>
>> for i in "$@"; do \
>> 	sed --in-place -e "s/[	 ]+$//" "$i"
>> done
>>
>> will do as well...
>>     
>
> Hi Richard,
>
> IIRC, `+' is extended regex, so -r option is needed:
>
> sed -r --in-place -e "s/[	 ]+$//" "$i"
>   
Yes, so right! Just because I did not understood why to use -e instead 
of -r (and even commented on it), I put an -e...

Thanks for pointing it out :)

