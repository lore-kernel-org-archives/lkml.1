Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYLaUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYLaUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYLaUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:16:20 -0500
Received: from mail.lang.hm ([64.81.33.126]:40138 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYLaUQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:16:19 -0500
Date: Wed, 31 Dec 2008 13:18:25 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <20081231191214.GF20882@localhost>
Message-ID: <alpine.DEB.1.10.0812311316350.18569@asgard.lang.hm>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm>
 <20081231183039.GE20882@localhost> <alpine.DEB.1.10.0812311204580.18334@asgard.lang.hm> <20081231191214.GF20882@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:

> [david@lang.hm - Wed, Dec 31, 2008 at 12:07:33PM -0800]
>> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>>
>>> [david@lang.hm - Wed, Dec 31, 2008 at 11:12:12AM -0800]
>>>> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>>>>
>>>>> [david@lang.hm - Tue, Dec 30, 2008 at 05:39:29PM -0800]
>>>>>>
>>>>>> so it looks like this is in alloc_bootmem_core in both cases.
>>>>>>
>>>>>> David Lang
>>>>>>
>>>>>
>>>>> Along with Andi's proposed earlyprintk=vga I think
>>>>> bootmem_debug option could be usefull here too.
>>>>
>>>> adding bootmem_debug creates so much additonal output that the oops
>>>> scrolls off the screen (except the last 'paragraph' of it)
>>>>
>>>> it looks like it's individual items being allocated (trying to scan it as
>>>> it scrolled by)
>>>
>>> on the picture you sent me i noticed the message
>>> "Your memory is not aligned you need to rebuild your
>>> kernel with bigger NODEMAP SIZE shift=20" and then
>>> srat code complains about "No NUMA code hash function found"
>>> which looks a bit scary. Btw, could you post this picture
>>> on some public resource so NUMA people could check it?
>>
>> http://linux.lang.hm/linux/IMG00030.jpg
>>
>> I'll try rebuilding with a bigger nodemap size and let you know
>>
>> David Lang
>>
>
> also you could just pass numa=off and check if it help.
> (even if it help it would not mean that problem are gone
> but become hidden)

with numa=off the system looks like it gets a bit further

http://linux.lang.hm/linux/IMG00031.jpg

this is with framebuffer disabled, earlyprintk=vga bootmem_debug numa=off

David Lang
