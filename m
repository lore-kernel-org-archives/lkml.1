Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXCURnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXCURnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbXCURnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:43:14 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:42689 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXCURnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:43:13 -0400
Message-ID: <46016EAF.6010801@blueyonder.co.uk>
Date: Wed, 21 Mar 2007 17:43:11 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: auxsvr@gmail.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>	<200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk>
In-Reply-To: <45EFBC73.2030005@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce wrote:
> Andrew Morton wrote:
>> (cc restored.  Please always do reply-to-all)
>>
>>  
>>> On Wed, 28 Feb 2007 18:05:13 +0200 auxsvr@gmail.com wrote:
>>> On Wednesday 28 February 2007 17:19, Sid Boyce wrote:
>>>    
>>>> openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
>>>> require a password to unlock, but it asks for password. When the screen
>>>> unlocks, kwin is gone with no errors logged in /var/log/kdm or
>>>> /var/log/messages. No problems with 2.6.20.
>>>>
>>>> Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
>>>> Regards
>>>> Sid.
>>>>       
>>> This is the linux kernel mailing list. Perhaps you should post your 
>>> problem to the opensuse mailing list.
>>>     
>>
>> 2.6.20 worked.
>>
>> 2.6.20-rc2 did not.
>>
>> Working theory: the kernel broke.
>>
>> Sid, the chances that anyone can work out what caused this are pretty 
>> low. It would be great if you could perform a git bisection search 
>> sometime in
>> the next few weeks, work out which commit caused this.
>>
>> Thanks.
>>
>>
>>
>>   
> I shall go back to 2.6.20-git3 and work forward. Up to 2.6.20-git2 was OK.
> Regards
> Sid.
> 

I tracked the problem down to 2.6.20-git11. Up to 2.6.20-git10 is OK, 
but from 2.6.20-git11 up to current 2.6.21-rc4-git2 all exhibit the problem.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

