Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbZA2XU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbZA2XU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZA2XUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:20:49 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:64340 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZA2XUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kfenzBJln5aXuiAG95/55aKHRZIs+qvrIfO3z2KWIpXn/783hWQ603o8or/k8lTfiS
         iSUK/qELgDwLUazSrjI5wzZA7AxAz5Lrj9bowfVryyNJxAunLgDQsxQi36GV1ZipPHVT
         q7THp5/dSufOvKKknRSsBXkwQQSbOVUXbK3tg=
Message-ID: <498239CC.2010200@gmail.com>
Date: Thu, 29 Jan 2009 15:20:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: macbook pro radeon suspend issue
References: <49812E3B.6050106@gmail.com> <200901291536.37348.rjw@sisk.pl> <4982045B.6090206@gmail.com> <200901292319.37921.rjw@sisk.pl>
In-Reply-To: <200901292319.37921.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 29 January 2009, Justin P. Mattock wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> On Thursday 29 January 2009, Justin P. Mattock wrote:
>>>   
>>>       
>>>> No sure if there is a bug report already or not.
>>>> For the macbook pro(ATI chipset) suspend is broken.
>>>> As for kernel version: latest git.
>>>> Last week(before LCA, and during the week, since being no merges.)
>>>> the system would wakeup, show a black screen and sit there. Now
>>>> after a couple of merges have been completed The system wakes up,
>>>> but instantly reboot's.
>>>>
>>>> I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
>>>> no response
>>>> for some reason or another.
>>>> I can try and do a bisect, the only problem
>>>> I have though, is I never labeled good/bad commits(forgot how too);
>>>>
>>>> In any case If I'm in an urgent need, of having  to suspend
>>>> the system(not in anytime soon at the moment),
>>>> then Ill just revert kernels to one that I know works.     :^)
>>>>     
>>>>         
>>> Which is that?
>>>
>>> Rafael
>>>
>>>   
>>>       
>> O.K. I ended up grabbing the packages from debian
>> to get it working.
>>     
>
> Not sure what you mean.  Care to elaborate?
>
> Rafael
>
>   
Well, long story short,
s2ram was not working a few weeks
ago, as well as echo mem > sys/power/state also.
Now this morning I built the package s2ram
from the debian sid repository(even though I'm using jaunty), and viola
it works again(last week s2ram was leaving a blank screen for
some reason or another.)

The only issue for now at least is
echo mem > /sys/power/state
which results in a blank screen,
and an instant reboot.

aside note don't mean to confuse you.
(busy at the SPIE show in san jose);

regards;

Justin P. Mattock
