Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZABRmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZABRmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZABRlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:41:53 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:40383 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbZABRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZO5bgjIzyFgmT9IG7/v5ViXYhMuC0ISEYYhXpu7FhZn+hUBtNOR6FLvWc5HCeooBAm
         QT8OuziQqAdgaiKswRbucOkg7wYXq8Vw1U9Qpux47LuWhCekrVJbVWYXXku1AyHVV1v7
         P3YuOylk2wUHb51qLf2ctfQ8BettsVWAJEXj0=
Date: Fri, 2 Jan 2009 20:24:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20090102172426.GB5372@localhost>
References: <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[david@lang.hm - Fri, Jan 02, 2009 at 10:21:52AM -0800]
> On Wed, 31 Dec 2008, david@lang.hm wrote:
>
>> On Thu, 1 Jan 2009, Andi Kleen wrote:
>>
>>> On Wed, Dec 31, 2008 at 12:59:08PM -0800, david@lang.hm wrote:
>>>> On Wed, 31 Dec 2008, Andi Kleen wrote:
>>>>
>>>>>> on the picture you sent me i noticed the message
>>>>>> "Your memory is not aligned you need to rebuild your
>>>>>> kernel with bigger NODEMAP SIZE shift=20" and then
>>>>>> srat code complains about "No NUMA code hash function found"
>>>>>> which looks a bit scary. Btw, could you post this picture
>>>>>> on some public resource so NUMA people could check it?
>>>>>
>>>>> This case used to be handled cleanly (NUMA disabled), but perhaps
>>>>> that has regressed. But still it sounds like something is going wrong,
>>>>> unless his machine really has a very weird memory map.
>>>>
>>>> it shouldn't, it was one of the high-volume servers 4-5 years ago and only
>>>> has 4G of ram in it
>>>
>>> From looking at the screenshot Cyrill sent you seem to have a funny
>>> SRAT with overlapping areas that is rejected in the end. I suspect the
>>> fallback code doesn't handle this properly.
>>>
>>> Does it work when you boot with numa=noacpi ?
>>
>> it gets past the point where the bootmemory_debug messages flow by, but 
>> I get another oops (snapshot of the screen is at  
>> http://linux.lang.hm/linux/IMG00031.jpg )
>
> oops, I misread your mail, IMG00031.jpg was with numa=off
>
> I just posted IMG00033.jpg which is with numa=noacpi and earlyprintk=vga  
> but not bootmem_debug
>
> David Lang
>

Thanks, David! Trying to understand what is going on :)

Here is a new picture if someone would like to jump into
the bug handling

	http://linux.lang.hm/linux/IMG00033.jpg

		- Cyrill -
