Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXE0NOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXE0NOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 09:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXE0NOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 09:14:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:48287 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXE0NOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 09:14:42 -0400
Message-ID: <465984E5.10506@tmr.com>
Date: Sun, 27 May 2007 09:17:25 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Documentation on /sys/power/resume
References: <4658C807.9040005@tmr.com> <200705271253.03396.rjw@sisk.pl> <46597F37.5050107@tmr.com> <200705271506.45714.rjw@sisk.pl>
In-Reply-To: <200705271506.45714.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 27 May 2007 14:53, Bill Davidsen wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> Hi,
>>>
>>> On Sunday, 27 May 2007 01:51, Bill Davidsen wrote:
>>>       
>>>> Not in the ABI doc, is there and doc at all, and if not could someone 
>>>> who knows where it's used might give me a hint, as a quick look didn't 
>>>> bring enlightenment. Or is it a future hook which doesn't work yet?
>>>>         
>>> That's something that in theory may allow you to resume the system from
>>> and initrd script.
>>>
>>> Basically, you write your resume device's major and minor numbers
>>> into it as the "MAJ:MIN" string (eg. "8:3" for /dev/sda3 on my box) and the
>>> kernel will try to read the image from this device and restore it.
>>>
>>> It only works with partitions and the use of it us discouraged, so it's
>>> deliberately undocumented.
>>>
>>>       
>> Thanks, that's just different enough from what little info I had to make 
>> what I have not work. I'm looking at resume from a non-swap location.
>>     
>
> Only suspend2 can do this right now.  The built-in swsusp can resume from a
> swap file as long as it's not located on LVM.
>   
Sounds like sispend2 is still needed, I haven't needed a suspending 
kernel in a few years, and I was hoping that with suspend working in 
mainline that resume would have been implemented. Sounds as if that's 
not the case, my swap is RAID1, I was hoping to resume from one of the 
mirrors, since they are based on a partition. No joy wit or without 
/sys/power/resume, so I'll look further.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

