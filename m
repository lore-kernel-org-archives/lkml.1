Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbZGIEOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbZGIEOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZGIEOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:14:43 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:64613 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZGIEOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CW9n1PBksNuq+gkFUd8JPBG7Lop6PsV4TgI0K7kdyKX0gM2aiUZp+T9EW9vQHjHj0Q
         vspD+4HYdLWMnRoEXRMGAY2p0FM25gFmEeX5cUmXOM/SxuLGjkkJj6NhhUuzEuYAEjlh
         8YiUnJS6EiJ+zuhm4LSUQGshCatiR6d/AaJoI=
Message-ID: <4A556F04.3090408@gmail.com>
Date: Wed, 08 Jul 2009 21:16:04 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: mactel-linux.org-users@queuemail.com
CC: mactel-linux-users <mactel-linux-users@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Mactel-linux-users] touchpad synaptics pm-suspend
References: <4A53C580.2040000@queuemail.com> <4A540461.1030204@gmail.com>	 <4A541D42.8070004@queuemail.com> <4A5424C5.10405@gmail.com>	 <4A546A87.5070009@queuemail.com> <4A54CC78.9020707@gmail.com> <dd18b0c30907081124o2c439504m6b90f9dc00453358@mail.gmail.com> <4A550D61.40707@queuemail.com>
In-Reply-To: <4A550D61.40707@queuemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paul s wrote:
> > interesting, s2ram works,
>
> agreed...
>
> > (while doing this multiple times) s2disk
> > shutdowns the system(configuration issue somewhere)
>
> hibernate took a while to shutdown... resume was slow once x started, 
> all applications and service restored though...
>
> > the screen is really dark and green
> > (probably missing a library)
>
> everything looks good with mine when it comes back from sleep, the 
> button for the touchpad works, its just the touchpad itself... killing 
> x doesn't fix it either...
>
>
>
> On 07/08/2009 02:24 PM, Justin Mattock wrote:
>> On Wed, Jul 8, 2009 at 9:42 AM, Justin P.
>> Mattock<justinmattock@gmail.com> wrote:
>>> paul s wrote:
>>>> does your touchpad work from resume? i know it is not the same 
>>>> model, but
>>>> curious...
>>>>
>>>> i updated the kernel from rawhide(2.6.31.rc2) and there were just 
>>>> crazy
>>>> system errors, actually even saw a kernelloops warning for the 
>>>> first time...
>>>>
>>>>
>>>>
>>>> On 07/08/2009 12:47 AM, Justin P. Mattock wrote:
>>>>> paul s wrote:
>>>>>> i have not, just what is in the repository for the distribution...
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 07/07/2009 10:28 PM, Justin P. Mattock wrote:
>>>>>>> paul s wrote:
>>>>>>>> hi -
>>>>>>>>
>>>>>>>> when my mbp4,1 comes back from suspend the touchpad is
>>>>>>>> frozen|unresponsive|not working. it only seems to be with 
>>>>>>>> suspend as
>>>>>>>> when it returns from hibernate it is fine...
>>>>>>>>
>>>>>>>> i am using 2.6.29.5-191.fc11.x86_64 is anyone experiencing this
>>>>>>>> issue...
>>>>>>>>
>>>>>>>> i have been looking around, played with the fdi and also added a
>>>>>>>> script
>>>>>>>> to the /etc/pm/sleep.d to load and unload appletouch to no 
>>>>>>>> avail...
>>>>>>>>
>>>>>>>> cheers
>>>>>>>> paul
>>>>>>>>
>>>>>>>>
>>>>>>>> ------------------------------------------------------------------------------ 
>>>>>>>>
>>>>>>>> Enter the BlackBerry Developer Challenge
>>>>>>>> This is your chance to win up to $100,000 in prizes! For a limited
>>>>>>>> time,
>>>>>>>> vendors submitting new applications to BlackBerry App World(TM) 
>>>>>>>> will
>>>>>>>> have
>>>>>>>> the opportunity to enter the BlackBerry Developer Challenge. 
>>>>>>>> See full
>>>>>>>> prize
>>>>>>>> details at: http://p.sf.net/sfu/Challenge
>>>>>>>> _______________________________________________
>>>>>>>> Mactel-linux-users mailing list
>>>>>>>> Mactel-linux-users@lists.sourceforge.net
>>>>>>>> https://lists.sourceforge.net/lists/listinfo/mactel-linux-users
>>>>>>>>
>>>>>>> have you tried the latest stable kernel?
>>>>>>>
>>>>>>> Justin P. Mattock
>>>>>>>
>>>>>> -- 
>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>> linux-kernel"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>>
>>>>> Not sure for redhat, but if you feel comfortable,
>>>>> try just grabbing  a fresh tar.ball from kernel.org,
>>>>> or use git to pull the latest from Linus's tree.
>>>>> (this way your  up-to-date, and the fix could be already
>>>>> in there).
>>>>>
>>>>> Justin P. Mattock
>>>>>
>>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>> linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>> If you can save those messages, and
>>> send them to kernel.org.
>>> Honestly I have not tried S2D/S2R
>>> on my machine for a while(probably
>>> end up with a black screen).
>>>
>>> Justin P. Mattock
>>>
>>>
>>
>> interesting, s2ram works,
>> bluetooth is intact, touch pad is intact
>> (while doing this multiple times) s2disk
>> shutdowns the system(configuration issue somewhere)
>> the only issue is the first s2ram takes a good minuet,
>> but after that resumes within seconds.
>> the screen is really dark and green
>> (probably missing a library)
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
s2ram works as expected over here,
s2disk resulted in a shutdown
(after looking at the documentation, seems
easier to just stick with s2ram).

Anyways the machine I have here is the macbook pro
with the ati chipset.
you on the other hand have the nvidia which acts differently
than having the radeon module and so forth.
you also have a different module than appletouch/synaptics
to deal with the touchpad i.g. bcm5974. In this case
I don't have any machines that have that hardware here.

My guess is hoping somebody who is reading this post, and has the hardware
add to this on why s2ram works, but s2disk fry's the mechanism for bcm5974
to wakeup from s2disk and be functional?
Also since the hardware is new try and update xserver/synaptic to make sure
that area is up-to-date(as well as making sure your xorg.conf is set right)

In the meantime I'll have to see if there is any info on doing s2ram
(simple version) somewhere to try, so I can see if this results with a 
non working
touchpad. With the equipment I have here.

Justin P. Mattock
