Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbXHBXO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbXHBXO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXHBXOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:14:50 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:35968 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbXHBXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:14:49 -0400
Message-ID: <46B2655F.8060502@blueyonder.co.uk>
Date: Fri, 03 Aug 2007 00:14:39 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-git3 init failure
References: <46ABF0FA.8060301@blueyonder.co.uk> <6bffcb0e0707300725i3bb8b677i75aeec6fed66bee2@mail.gmail.com>
In-Reply-To: <6bffcb0e0707300725i3bb8b677i75aeec6fed66bee2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Sid,
>
> On 29/07/07, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
>   
>>  > Boot failure on x86_64 (64X2), says it can't find init, specifically
>>  > /init. 2.6.23-rc1-git1 boots and runs successfully. I haven't tried
>>  > -git2. I shall reboot on 2.6.23-rc1-git3 tomorrow and record the full
>>  > message.
>>  > Strings from vmlinux in both the above:-
>>  >
>>  > Kernel alive
>>  > /dev/console
>>  > <4>Warning: unable to open an initial console.
>>  > <4>Failed to execute %s
>>  > <4>Failed to execute %s.  Attempting defaults...
>>  > /sbin/init
>>  > /etc/init
>>  > /bin/init
>>  > /bin/sh
>>  > No init found.  Try passing init= option to kernel.
>>  >
>>  > Tried option "init=/sbin/init" and got the same failure.
>>  > Regards
>>  > Sid.
>>
>> I see the sam problem with 2.6.23-rc1-git5.
>>
>> Freeing unused kernel memory: 236k freed
>> failed to execute /init
>> kernel panic - not syncing: No init found. Try passing init= option to
>> kernel
>>
>> Copying /sbin/init to / results in the same error.
>> openSUSE 10.3Alpha6plus
>> # rpm -qf /sbin/init
>> sysvinit-2.86-90
>>     
>
> Please read chapter 4.1 and 4.5
> http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf
>
> It should be very simple
>
> git-bisect start
> git-bisect bad
> git-bisect good 0de085bb474f64e4fdb2f1ff3268590792648c7b
>
> and so on and so forth
>
>   
>> Regards
>> Sid.
>>     
>
> Regards,
> Michal
>
>   
I had to do a fresh install of opeSUSE 10.3 Alpha6 to replace a failing 
drive. After that I again built 2.6.23-rc1-git10 which boots without 
problems. My guess is that something on the old hard drive got mangled. 
The old drive was PATA, the new one SATA, also disappeared have been the 
problems that suddenly appeared with sata_nv slow responses and timeouts 
with no devices installed and which I didn't see without the sata_nv 
module loaded.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


