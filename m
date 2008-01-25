Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYAYTEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYAYTEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYAYTEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:04:23 -0500
Received: from gw.goop.org ([64.81.55.164]:55423 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919AbYAYTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:04:22 -0500
Message-ID: <479A32B4.9030904@goop.org>
Date: Fri, 25 Jan 2008 11:04:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
References: <47993F1A.5070408@goop.org> <20080125110935.GA20026@elte.hu> <479A30A3.7050305@goop.org> <200801251119.02565.yinghai.lu@sun.com>
In-Reply-To: <200801251119.02565.yinghai.lu@sun.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Friday 25 January 2008 10:55:31 am Jeremy Fitzhardinge wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>>>
>>>   
>>>       
>>>> [PATCH] x86: trim ram need to check if mtrr is there v3
>>>>     
>>>>         
>>>   
>>>       
>>>>> H. Peter Anvin wrote:
>>>>> Looks like the code doesn't check that the CPU *has* MTRRs...
>>>>>       
>>>>>           
>>>> so more strict check if mtrr is there really.
>>>> bail out if mtrr all blank when qemu cpu model is used
>>>>
>>>> and check if is AMD as early
>>>> also remove 4G less check, according to hpa.
>>>>     
>>>>         
>>> thanks, applied. Shouldnt we put in an exception for when there is MTRR 
>>> support, but they dont cover anything. Still emit a warning - but 
>>> booting up real slow is still better than losing all of RAM and crashing 
>>>   
>>>       
>> The problem is re-occuring for me with current x86.git.  Looks like v2 
>> did the trick, and v3 is broken...
>>     
>
> so the ram size less 4g is way out for your case.
>
> again, can you post /proc/mtrrs with v2 patch?
>   

It was empty.  But ignore this report; it wasn't against the right 
version of x86.git.

    J
