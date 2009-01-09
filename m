Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZAIRhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZAIRhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZAIRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:37:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:52401 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZAIRho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:37:44 -0500
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, linux-kernel@vger.kernel.org
Message-Id: <A1D2B092-1D51-4131-B5F2-D6B45767435F@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
In-Reply-To: <1231519043.27350.73.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: swiotlb: remove duplicated #include
Date: Fri, 9 Jan 2009 11:36:02 -0600
References: <20090104112541.GA25434@elte.hu> <20090104210420X.fujita.tomonori@lab.ntt.co.jp> <20090104121914.GA30255@elte.hu> <20090104214109A.fujita.tomonori@lab.ntt.co.jp> <20090104130113.GA24506@elte.hu>  <49613CC4.1000000@goop.org> <1231519043.27350.73.camel@zakaz.uk.xensource.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 9, 2009, at 10:37 AM, Ian Campbell wrote:

> On Mon, 2009-01-05 at 09:48 +1100, Jeremy Fitzhardinge wrote:
>> Ingo Molnar wrote:
>>> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>>
>>>
>>>>> In a few days, but wanted to hear back from either Jeremy or Becky
>>>>> first about how well they actually work in their usecases.
>>>>>
>>>> Well, you don't need to wait, I think.
>>>>
>>>> All Jeremy and Becky need is adding highmem support to swiotlb.  
>>>> How we
>>>> support it doesn't matter. We can choose better one.
>>>>
>>>> We all (including Jeremy) agreed that Becky's physical address  
>>>> scheme is
>>>> better (simpler) than Jeremy's struct page and offset scheme.  
>>>> Surely,
>>>> Becky's scheme works for Xen and him (Jeremy said that he tested it
>>>> lightly).
>>>>
>>>
>>> Jeremy said, when he submitted this series, shortly before  
>>> Christmas:
>>>
>>>>> Here's a work in progress series [...]
>>>>>
>>>>> Quick testing showed no problems, but I haven't had the chance  
>>>>> to do
>>>>> anything extensive.
>>>
>>> Jeremy, did you have a chance to do more testing with the current
>>> tip/master bits on Xen, so that we can push it to Linus?
>>>
>>
>> I'm going to be on vacation until the 12th, so I won't have a  
>> chance to
>> do anything until then (perhaps Ian will have a chance to poke at  
>> them
>> before then).  I'm expecting Becky's patches to work as-is, or if  
>> not,
>> be easily fixed with a couple of small bugfix patches.  So I say go
>> ahead if they work for everyone else.
>
> Only just got out from under my pile of vacation backlog...
>
> They don't quite work with Xen (at least the version in Jeremy's patch
> queue doesn't) but I agree that it should be possible to make it work
> and that there's no point in holding back just for Xen.

I'm also back (temporarily), and they're not quite going to work for  
powerpc, either, but it shouldn't be anything major to fix, and since  
it didn't work on powerpc before, that shouldn't hold anything up.   
I'm working on getting things working for me again now.   
Unfortunately, it now looks like I'm going to have to be out of the  
office next week, but I expect to get something out as soon as I'm  
back, if I don't get a chance to fix it today.

Jeremy, many thanks for your work merging my patches in with your  
series!

Cheers,
Becky

