Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZGHVTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZGHVTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZGHVTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:19:31 -0400
Received: from krypton.spydercomm.com ([69.64.33.54]:54951 "EHLO
	krypton.spydercomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZGHVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:19:31 -0400
Message-ID: <4A550D61.40707@queuemail.com>
Date: Wed, 08 Jul 2009 17:19:29 -0400
From: paul s <mactel-linux.org-users@queuemail.com>
Reply-To: mactel-linux.org-users@queuemail.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: mactel-linux-users <mactel-linux-users@lists.sourceforge.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Mactel-linux-users] touchpad synaptics pm-suspend
References: <4A53C580.2040000@queuemail.com> <4A540461.1030204@gmail.com>	 <4A541D42.8070004@queuemail.com> <4A5424C5.10405@gmail.com>	 <4A546A87.5070009@queuemail.com> <4A54CC78.9020707@gmail.com> <dd18b0c30907081124o2c439504m6b90f9dc00453358@mail.gmail.com>
In-Reply-To: <dd18b0c30907081124o2c439504m6b90f9dc00453358@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > interesting, s2ram works,

agreed...

 > (while doing this multiple times) s2disk
 > shutdowns the system(configuration issue somewhere)

hibernate took a while to shutdown... resume was slow once x started, 
all applications and service restored though...

 > the screen is really dark and green
 > (probably missing a library)

everything looks good with mine when it comes back from sleep, the 
button for the touchpad works, its just the touchpad itself... killing x 
doesn't fix it either...



On 07/08/2009 02:24 PM, Justin Mattock wrote:
> On Wed, Jul 8, 2009 at 9:42 AM, Justin P.
> Mattock<justinmattock@gmail.com> wrote:
>> paul s wrote:
>>> does your touchpad work from resume? i know it is not the same model, but
>>> curious...
>>>
>>> i updated the kernel from rawhide(2.6.31.rc2) and there were just crazy
>>> system errors, actually even saw a kernelloops warning for the first time...
>>>
>>>
>>>
>>> On 07/08/2009 12:47 AM, Justin P. Mattock wrote:
>>>> paul s wrote:
>>>>> i have not, just what is in the repository for the distribution...
>>>>>
>>>>>
>>>>>
>>>>> On 07/07/2009 10:28 PM, Justin P. Mattock wrote:
>>>>>> paul s wrote:
>>>>>>> hi -
>>>>>>>
>>>>>>> when my mbp4,1 comes back from suspend the touchpad is
>>>>>>> frozen|unresponsive|not working. it only seems to be with suspend as
>>>>>>> when it returns from hibernate it is fine...
>>>>>>>
>>>>>>> i am using 2.6.29.5-191.fc11.x86_64 is anyone experiencing this
>>>>>>> issue...
>>>>>>>
>>>>>>> i have been looking around, played with the fdi and also added a
>>>>>>> script
>>>>>>> to the /etc/pm/sleep.d to load and unload appletouch to no avail...
>>>>>>>
>>>>>>> cheers
>>>>>>> paul
>>>>>>>
>>>>>>>
>>>>>>> ------------------------------------------------------------------------------
>>>>>>> Enter the BlackBerry Developer Challenge
>>>>>>> This is your chance to win up to $100,000 in prizes! For a limited
>>>>>>> time,
>>>>>>> vendors submitting new applications to BlackBerry App World(TM) will
>>>>>>> have
>>>>>>> the opportunity to enter the BlackBerry Developer Challenge. See full
>>>>>>> prize
>>>>>>> details at: http://p.sf.net/sfu/Challenge
>>>>>>> _______________________________________________
>>>>>>> Mactel-linux-users mailing list
>>>>>>> Mactel-linux-users@lists.sourceforge.net
>>>>>>> https://lists.sourceforge.net/lists/listinfo/mactel-linux-users
>>>>>>>
>>>>>> have you tried the latest stable kernel?
>>>>>>
>>>>>> Justin P. Mattock
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>> Not sure for redhat, but if you feel comfortable,
>>>> try just grabbing  a fresh tar.ball from kernel.org,
>>>> or use git to pull the latest from Linus's tree.
>>>> (this way your  up-to-date, and the fix could be already
>>>> in there).
>>>>
>>>> Justin P. Mattock
>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>> If you can save those messages, and
>> send them to kernel.org.
>> Honestly I have not tried S2D/S2R
>> on my machine for a while(probably
>> end up with a black screen).
>>
>> Justin P. Mattock
>>
>>
> 
> interesting, s2ram works,
> bluetooth is intact, touch pad is intact
> (while doing this multiple times) s2disk
> shutdowns the system(configuration issue somewhere)
> the only issue is the first s2ram takes a good minuet,
> but after that resumes within seconds.
> the screen is really dark and green
> (probably missing a library)
> 
