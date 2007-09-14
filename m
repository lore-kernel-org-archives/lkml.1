Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbXINB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbXINB2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXINB2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:28:11 -0400
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:48482 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXINB2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:28:10 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 21:28:10 EDT
Date: Thu, 13 Sep 2007 21:03:03 -0400
From: Steven Toth <stoth@hauppauge.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
In-reply-to: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Message-id: <46E9DDC7.4000403@hauppauge.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
 <20070913131353.GB26972@linuxtv.org>
 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
 <46E95C54.4060502@gmail.com>
 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
 <46E99F36.8090809@hauppauge.com>
 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On 9/13/07, Steven Toth <stoth@hauppauge.com> wrote:
>   
>>>> Also there is to consider a non technical aspect, whether vendors will
>>>> misuse this interface for binary only, undermining the efforts put in
>>>> for OSS drivers.
>>>>
>>>>
>>>>         
>>> What holds companies for using the current available code putting it
>>> into an rpm or deb package and releasing such code now?
>>>
>>> The Avermedia example I pointed out to is a good example already.
>>> As from my side I won't release binary drivers.
>>> Although on the other side:
>>> * are drivers from vendors which work through several kernel versions
>>> that bad?
>>> * Why did someone duallicense videodev2 with BSD/GPL?
>>>
>>> I would appreciate if someone else on the list could also comment
>>> the reason that drivers should all be included in the linuxkernel just
>>> because forcing the companies to release binary drivers because
>>> of that. My opinion about that is if a company wants to go opensource
>>> they will do so, if not they will either not release a driver or release
>>> nothing.
>>>
>>>
>>>       
>> I know for certain that adding a userland API tuner/demod interface to
>> the kernel, allowing non-caring opportunistic silicon or board vendors
>> to developer closed source proprietary drivers, will have a negative
>> effect on the community and we'd set back linuxtv 3-5 years.
>>
>> I know for certain that it would happen. Trust me.
>>
>> I've told you this countless times and you're not hearing me.
>>
>> Hauppauge have some leverage with Conexant and NXP to release public
>> datasheets. If they just have to release a demod.so (or similar)
>> loadable, they'll defer to the board vendors and we'll see the certain
>> board vendors 'locking other board vendors' out of their drivers. We'll
>> see embedded firmware, not shared between drivers.
>>
>> Except, it won't stop at demod.so. It will extend into unfixable bugs
>> for VendorB's board, because VendorA doesn't want to release a new
>> demod.so, and VendorB has no linux resources. What happens next? For
>> financial reasons - demod.so will begin to include checks to see if
>> specific PCI or USB devices are present in the system, and will fail to
>> work properly (if at all) when they're not being used with the preferred
>> products.
>>
>>     
> Steven,
>
> what stops vendors of using the current existing code to achieve that
> goal. They could provide binary drivers with the existing API.
>
>   

Because the good people in this mailing list are keeping them honest. 
Give any board or silicon company the ability to protect their IP, even 
in the smallest way and they'll do it, and for no good technical reason. 
It's a cut throat market and it's not clear that everyone understands 
just how thin sales margins really are.

That means Hauppauge potentially releasing a binary driver, because it's 
much easier than seeking silicon vendor permission for a public diver. 
The net result of that would mean I'd have to leave the company and find 
another company that practices the one thing I truly care about .... 
open source and open development groups.

I'm keeping Hauppauge honest with their Linux involvement and I'm not 
alone. Other devs in other linux subsystems in other companies are doing 
the same thing.

Binary drivers (or binary components) leads Linux back in time.

I can't believe your so passionate about protecting secrets.

> What stops companies to intercept the ioctl calls and overriding some
> I2C commands?
>
>   

Why would a company want to do that? Companies don't do that, hackers do 
that.

> Since you know about windows drivers (at least I think that you know
> about it) you might know about the limitations of the v4l/dvb API
> in general the reason just put as much code as possible into the
> kernel just for forcing companies to release code under GPL doesn't
> seem to be valid.
>   

It seems perfectly valid to me.

> How about proprietary video formats, would you also place the decoding
> algorithms in kernel  just to force companies to release their code
> for it?
>   

The kernel has no good API for those, each new type of video device and 
suggested API is judged on it's own merits and discussed on the mailing 
lists.

> What do you think about the existing usbfs implementation, which
> allows to implement usb drivers completly in userspace?
>   

Those are not my problem and I don't use them, you should raise that 
with the relevant usb-dev mailing lists. I'm here because I care about 
linuxtv. Please stay on topic.

> What do you think about IOMMU?
>
>   
Just because AMD or INTEL want to invent some whizzy new technology it 
doesn't say anything about the TV card development and retail business. 
Intel and AMD have teams of Linux engineers helping operating system 
developers bring their ideas and technologies to new platforms. That's a 
million miles away from any of the TV board vendors I know of, who have 
little or NO fulltime linux developers and consider the < 5% market 
fringe at best.

Markus, senior devs in the LinuxTV group are telling you, based on their 
commercial experience, that userspace access is technically great, but 
long term it will be used against the community and will ultimately hurt 
linuxtv development.

If you want to reply and have the last word, go ahead, but repeating 
what I've said on this list in the past - I'll never support the 
userland tuning/demod idea.

I wanted to work directly with you on the em28xx tree, helping you 
remove the 5% of code that Johannes referred to, but you said no. I 
wanted to help you make the tree conform to the linuxtv standards for 
frameworks, you said no.

If you care about LinuxTV you'll work with the core subsystem developers 
to bring your em28xx tree inline. If you don't care then why are you here?

- Steve







