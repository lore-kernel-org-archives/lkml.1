Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZADWsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZADWsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZADWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:48:46 -0500
Received: from gw.goop.org ([64.81.55.164]:57668 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZADWsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:48:46 -0500
Message-ID: <49613CC4.1000000@goop.org>
Date: Mon, 05 Jan 2009 09:48:36 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       beckyb@kernel.crashing.org, jj@chaosbits.net, weiyi.huang@gmail.com,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: swiotlb: remove duplicated #include
References: <20090104112541.GA25434@elte.hu> <20090104210420X.fujita.tomonori@lab.ntt.co.jp> <20090104121914.GA30255@elte.hu> <20090104214109A.fujita.tomonori@lab.ntt.co.jp> <20090104130113.GA24506@elte.hu>
In-Reply-To: <20090104130113.GA24506@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>   
>>> In a few days, but wanted to hear back from either Jeremy or Becky 
>>> first about how well they actually work in their usecases.
>>>       
>> Well, you don't need to wait, I think.
>>
>> All Jeremy and Becky need is adding highmem support to swiotlb. How we 
>> support it doesn't matter. We can choose better one.
>>
>> We all (including Jeremy) agreed that Becky's physical address scheme is 
>> better (simpler) than Jeremy's struct page and offset scheme. Surely, 
>> Becky's scheme works for Xen and him (Jeremy said that he tested it 
>> lightly).
>>     
>
> Jeremy said, when he submitted this series, shortly before Christmas:
>
>  >> Here's a work in progress series [...]
>  >>
>  >> Quick testing showed no problems, but I haven't had the chance to do 
>  >> anything extensive.
>
> Jeremy, did you have a chance to do more testing with the current 
> tip/master bits on Xen, so that we can push it to Linus?
>   

I'm going to be on vacation until the 12th, so I won't have a chance to 
do anything until then (perhaps Ian will have a chance to poke at them 
before then).  I'm expecting Becky's patches to work as-is, or if not, 
be easily fixed with a couple of small bugfix patches.  So I say go 
ahead if they work for everyone else.

    J
