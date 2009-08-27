Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZH0OjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZH0OjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZH0OjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:39:18 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41684 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZH0OjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OV8rd/uVlqmCsjqdOZefX1N3TUPNgXITqUxBsv0PU4PnT5kjMjYK8g4FtXwIrNP67U
         w5RqGTvimlpTupV6/mEQjkc/55yTEgjsGuWGpcTphe1NjFVkkDrQd+xH1cIAkQewpSjW
         5soHgxem/X5vuQIVhgN6xZKnAtz9pDtSHPIM8=
MIME-Version: 1.0
In-Reply-To: <4A95D677.2020807@kernel.org>
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
	 <20090802095523.e08166e3.rdunlap@xenotime.net>
	 <a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com>
	 <20090802193045.c3f3195c.rdunlap@xenotime.net>
	 <4A766F39.7090903@kernel.org> <4A95D677.2020807@kernel.org>
Date: Thu, 27 Aug 2009 22:39:13 +0800
Message-ID: <a8e1da0908270739sbab4821x6ec402a72587a337@mail.gmail.com>
Subject: Re: mm/-next release on kernel.org web page?
From: Dave Young <hidave.darkstar@gmail.com>
To: "J.H." <warthog9@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, webmaster@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 8:42 AM, J.H.<warthog9@kernel.org> wrote:
> J.H. wrote:
>>
>> Randy Dunlap wrote:
>>>
>>> On Mon, 3 Aug 2009 10:08:40 +0800 Dave Young wrote:
>>>
>>>> On Mon, Aug 3, 2009 at 12:55 AM, Randy Dunlap<rdunlap@xenotime.net>
>>>> wrote:
>>>>>
>>>>> On Sun, 2 Aug 2009 15:56:20 +0800 Dave Young wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> The last mm patchset is 2.6.28-rc2-mm1. We can not download -mm
>>>>>> patchset from kernel.org web page since the -next tree born.
>>>>>>
>>>>>> Could you consider put mmtom release there just like before? And even
>>>>>> -next tree patchset? It will be more convenient for users who test
>>>>>> kernel just by downloading from web. Now it's impossible for them to
>>>>>> test these patchsets because they normally do not subscribe to lkml.
>>>>>
>>>>> from www.kernel.org:
>>>>> For comments about the web pages, please send mail to
>>>>> webmaster@kernel.org.
>>>>>
>>>>> also from www.kernel.org:
>>>>> Please don't use finger.kernel.org for any sort of automatic
>>>>> monitoring. The number of automatic bots hitting this port is causing the
>>>>> finger daemon to shut down more often than not. The same information is
>>>>> available from http://www.kernel.org/kdist/finger_banner.
>>>>>
>>>>> and of course the finger_banner file is not up to date.
>>>>>
>>>>> You may consider using my
>>>>> http://www.xenotime.net/linux/scripts/kcurrent script.
>>>>> Its output (today) is:
>>>>>
>>>>> The latest stable version of the Linux kernel is:           2.6.30.4
>>>>> The latest prepatch for the stable Linux kernel tree is:    2.6.31-rc5
>>>>> The latest 2.4 version of the Linux kernel is:              2.4.37.4
>>>>> The latest 2.2 version of the Linux kernel is:              2.2.26
>>>>> The latest prepatch for the 2.2 Linux kernel tree is:       2.2.27-rc2
>>>>> The latest -mm patch to the stable Linux kernels is:
>>>>>  2.6.28-rc2-mm1
>>>>> mmotm-2009-0730-0501 ... applies to: 2.6.31-rc4
>>>>> next-20090731 ... applies to: v2.6.31-rc4
>>>>
>>>> Thanks randy. Very helpful. But I still have same question. Normal
>>>> users need a more convenient and straightforward  way to get what they
>>>> want.  It will be better that we put them on www.kernel.org main page,
>>>> not only the version info but also the download link.
>>>>
>>>> At least for me when I started my kernel hacking some years ago I
>>>> always download kernel from www.kernel.org main page. I'm not sure
>>>> whether others people do same thing. Current -next and mmtom are more
>>>> like for us to do internal testing.
>>>
>>> Oh, I agree with you, but webmaster@kernel.org seems to be ignoring these
>>> emails (this is the third such one in the last 3-4 months).
>>
>> In fact we have been responding to these inquiries both to the public ones
>> we have gotten (what we get added to on LKML), and to the private inquires,
>> the latest one from LKML being a bit more than a week ago:
>>
>> http://lkml.org/lkml/2009/7/24/334
>>
>> We have been well aware of the problem for quite some time, the code base
>> has rotted horribly, and the way kernel trees are placed in the hierarchy
>> has changed from any reasonable assumption that was made many years ago when
>> the code was first put together.  We (meaning me) are, literally, in the
>> middle of revamping this code, however it's basically a complete re-write of
>> the code base at this point.
>>
>> And in the last few weeks we've been dealing with quite a lot on top of
>> trying to make forward progress on this code base, like the Bind DNS
>> vulnerabilities, OSCon, Linux Symposium and the plethora of other things
>> that need doing.  Really, we aren't ignoring the problem, there's just one
>> of me and a lot to do and I'm plugging away at it all.  Please be patient,
>> I'm trying to get it done and up and running.  Until then *PLEASE* bear with
>> us while we get through everything.
>>
>> - John 'Warthog9' Hawley
>>
>
>
> Not to reply to myself, but I've pushed out an update that should
> incorporate the expected trees now, this does eliminate the 2.2 and all but
> the last 2.4 tree (2.4.37.5), but does include all of the stable 2.6.x
> trees, the snapshots and linux-next.  Frontpage, finger and rss should all
> be showing the new information universally.  I'll probably tweak things a
> bit more (layout and such for the rss & html) but the kernels should now be
> listed as people expect.

Thanks for your work.

Is it possible to add latest mmotm link?
Just link to andrew's broken-out.tar.gz with the stamp name?

>
> - John 'Warthog9' Hawley
> Chief Kernel.org Administrator
>



-- 
Regards
dave
