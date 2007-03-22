Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbXCVTta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbXCVTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934207AbXCVTta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:49:30 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:46997 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934201AbXCVTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:49:29 -0400
Message-ID: <4602DDBC.5000106@blueyonder.co.uk>
Date: Thu, 22 Mar 2007 19:49:16 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk> <200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de>
In-Reply-To: <20070322105908.GS752@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Mar 21, 2007 at 06:42:58PM -0700, Randy Dunlap wrote:
>   
>> On Thu, 22 Mar 2007 01:32:36 +0000 Sid Boyce wrote:
>>
>>     
>>> ...
>>>       
>> There's not a lot of docs out there.
>>
>> The man-page:  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
>>
>> Linus's email doc:
>> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
>>
>> I worked on something over last weekend, but it doesn't really add
>> much to the references above.
>> ...
>>     
>
>
> FWIW:
> My standard instructions for users who are asked to bisect are [1]:
>
>
> <--  snip  -->
>
> # install git and cogito on your computer
>
> # clone Linus' tree:
> cg-clone \ 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
> # start bisecting:
> cd linux-2.6
> git bisect start
> git bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
> git bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356
>
> # start round
> cp /path/to/.config .
> make oldconfig
> make
> # install kernel, check whether it's good or bad, then:
> git bisect [bad|good]
> # start next round
>
>
> After at about 8 reboots, you'll have found the guilty commit
> ("...  is first bad commit").
>
>
> More information on git bisecting:
>   man git-bisect
>
> <--  snip  -->
>
>
>   
>> ~Randy
>>     
>
> cu
> Adrian
>
> [1] the start and end commits and the number of reboots are variable,
>     but the rest of the text is generic
>
>   
Kernel built and installed, so I shall have something to report in the 
next couple of days.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


