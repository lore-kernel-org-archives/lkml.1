Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZAENRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZAENRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZAENR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:17:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZAENRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:17:25 -0500
Date: Mon, 5 Jan 2009 14:16:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       beckyb@kernel.crashing.org, jj@chaosbits.net, weiyi.huang@gmail.com,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: swiotlb: remove duplicated #include
Message-ID: <20090105131634.GD6014@elte.hu>
References: <20090104112541.GA25434@elte.hu> <20090104210420X.fujita.tomonori@lab.ntt.co.jp> <20090104121914.GA30255@elte.hu> <20090104214109A.fujita.tomonori@lab.ntt.co.jp> <20090104130113.GA24506@elte.hu> <49613CC4.1000000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49613CC4.1000000@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>
>>   
>>>> In a few days, but wanted to hear back from either Jeremy or Becky  
>>>> first about how well they actually work in their usecases.
>>>>       
>>> Well, you don't need to wait, I think.
>>>
>>> All Jeremy and Becky need is adding highmem support to swiotlb. How 
>>> we support it doesn't matter. We can choose better one.
>>>
>>> We all (including Jeremy) agreed that Becky's physical address scheme 
>>> is better (simpler) than Jeremy's struct page and offset scheme. 
>>> Surely, Becky's scheme works for Xen and him (Jeremy said that he 
>>> tested it lightly).
>>>     
>>
>> Jeremy said, when he submitted this series, shortly before Christmas:
>>
>>  >> Here's a work in progress series [...]
>>  >>
>>  >> Quick testing showed no problems, but I haven't had the chance to 
>> do  >> anything extensive.
>>
>> Jeremy, did you have a chance to do more testing with the current  
>> tip/master bits on Xen, so that we can push it to Linus?
>>   
>
> I'm going to be on vacation until the 12th, so I won't have a chance to 
> do anything until then (perhaps Ian will have a chance to poke at them 
> before then).  I'm expecting Becky's patches to work as-is, or if not, 
> be easily fixed with a couple of small bugfix patches.  So I say go 
> ahead if they work for everyone else.

ok, i have put it into the to-Linus pile.

	Ingo
