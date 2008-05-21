Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbYEUUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbYEUUDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbYEUUDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:03:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:32979 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYEUUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZoPfrv4f61Mlb4T0DTJy53TeTgo7KnsbqFEtJGminLt845jigPZ4DxZuCFlax2FyODcZkP43+e6J6llYjjTvdg6BjMRUf+1sQA4AaRdG6I44BJjurSoPuNOg9Pb3V6VEi+IpCTs0z0i6lRgrfGg6FoR5LrDXCeNZnALbdVIdAdI=
Message-ID: <dd18b0c30805211303k6e43d6d1l903da0c794521519@mail.gmail.com>
Date: Wed, 21 May 2008 20:03:16 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: completely lost as to what to do, or where to look.
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30805211004m6106b65occ97eff00cdbf630@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
	 <20080520223410.9a8f200d.akpm@linux-foundation.org>
	 <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
	 <20080521075917.GB18352@cs181133002.pp.htv.fi>
	 <dd18b0c30805210733m6d853709xf59331cfed3bfea@mail.gmail.com>
	 <6101e8c40805210751y350e3513ndd48621ac9d2b5d3@mail.gmail.com>
	 <dd18b0c30805211004m6106b65occ97eff00cdbf630@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 5:04 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Wed, May 21, 2008 at 2:51 PM, Oliver Pinter <oliver.pntr@gmail.com> wrote:
>> you use ati or nvidia binary driver?
>>
>> On 5/21/08, Justin Mattock <justinmattock@gmail.com> wrote:
>>> On Wed, May 21, 2008 at 7:59 AM, Adrian Bunk <bunk@kernel.org> wrote:
>>>> On Wed, May 21, 2008 at 06:51:24AM +0000, Justin Mattock wrote:
>>>>> On Wed, May 21, 2008 at 5:34 AM, Andrew Morton
>>>>> <akpm@linux-foundation.org> wrote:
>>>>> > On Wed, 21 May 2008 04:10:16 +0000 "Justin Mattock"
>>>>> > <justinmattock@gmail.com> wrote:
>>>>> >
>>>>> >> Hello; I'm lost as to where to look in the kernel, as to why I'm
>>>>> >> receiving a black screen with startx
>>>>> >> DRI seems to be fine, I'm noticing a sema_init but am not sure if this
>>>>> >> is the cause of the blackness.
>>>>> >> any direction as to where I might look would be helpful.
>>>>> >
>>>>> > Kernel version?
>>>>> >
>>>>> > A git-bisect should get you down the the offending commit within an
>>>>> > hour or three.  http://www.kernel.org/doc/local/git-quick.html has some
>>>>> > instructions.
>>>>> >
>>>>> > But if you're on 2.6.26-rcX, be sure to use the very latest - a pile of
>>>>> > bad DRI code got reverted recently.  This morning, I think.
>>>>> >
>>>>>
>>>>> Thanks for the help, From what I can remember I noticed this around
>>>>> 2.6.26-rc1. It could be an issue with DRI, but then again it could be
>>>>> something else. With running some more tests I'm noticing  a conflict
>>>>> with libdri.so, not recognizing the module or the module not
>>>>> recognizing libdri.so.
>>>>>...
>>>>
>>>> Which X video driver are you using?
>>>>
>>>> What exactly is the error message?
>>>>
>>>>> regards;
>>>>> Justin P. Mattock
>>>>
>>>> cu
>>>> Adrian
>>>>
>>>> --
>>>>
>>>>       "Is there not promise of rain?" Ling Tan asked suddenly out
>>>>        of the darkness. There had been need of rain for many days.
>>>>       "Only a promise," Lao Er said.
>>>>                                       Pearl S. Buck - Dragon Seed
>>>>
>>>>
>>>
>>> Hello; thanks for the feedback, from previous posts, you know what
>>> module I'm talking about, So with that in mind I'm going to go
>>> to the next question: From error messages "there isn't"
>>> the only leeway or light at the end of the tunnel I see is with
>>> libdri.so i.g. If I boot the system up with out messing with anything
>>> I will receive
>>> a black screen after issueing startx, (from looking at what I see, the
>>> screen will flash one time then black, it should flash or blink two
>>> times
>>> before giving me my lovely picture(wallpaper) then if I remove
>>> libdri.so everything starts up as usual so with that in mind since I
>>> received
>>> a post about DRI being all F*&^ked up then maybee that is the culprit,
>>> I think All I really need right now is info on the xserver and the
>>> kernel.
>>> What mechanisms are used or files that are responsible for the two too
>>> coexist.
>>> regards;
>>>
>>> --
>>> Justin P. Mattock
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>> --
>> Thanks,
>> Oliver
>>
>
> Alright: I'm using 2.6.26-rc3-00122-g748bf99, I pulled if I can
> remember Monday night and I did notice drmP.h and the rest of the drm
> files,
> but, will try and pull again to see if it makes a difference. As for
> the question about what video card nvidia or ati, I'm stuck with ati,
> went into apple yesterday to see if that would be easy to change out,
> but unfortunately I would have to get a new laptop.
> To bad apple didn't use an intel graphics card, that linux already has
> a module for.
> As for error messages looking at /var/log/Xorg.0.log it seems the
> Xserver can't finish completing  DRIScreenInit
> the /dev/dri/video0 is created, but then just stops after that, no
> conversation with the module and dri after /dev/dri/video0 is created.
> At this point, I'll try and pull and see if it makes a difference, and
> if not then I'll have to just keep trying.
> That's why right now I just need any kind of info about files or
> mechanisms that  are used in this situation so I can at least try and
> connect the dots with this issue.
>
> regards;
> --
> Justin P. Mattock
>

O.K. I've got my 8-balls back, from what I could tell there was three
areas that needed attention to:
1)  add nopage back into the kernel
2) The DRI needed to be reverted back to it's original state, or
modified due to some issue.
3) find_task_by_pid( pid) on the module side needed to be changed to
find_task_by_vpid( pid) or else you'll have an issue with init_pid_ns

I did have the latest DRI updates yesterday, but should have been
using nopage to build the module instead of fault.
so three weeks ago if the DRI wasn't adjusted, and if I would of found
find_task_by_(v)pid(pid) then I would of been O.K.(but am unsure at
the moment, still need to do some more tests) Now after up and running
I can confirm that suspend successfully wakes up, So I can go ahead
and look into appletouch surviving suspend, and the mighty mouse
scroll function surviving suspend as well(then play Myst).
Overall this was a good educational exercise for me since I suck at
reading and writing.
Again thank you guy's for helping me out with this,
regards;

-- 
Justin P. Mattock
