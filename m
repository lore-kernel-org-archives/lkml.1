Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYJPHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYJPHeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYJPHd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:33:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:44786 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYJPHd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:33:57 -0400
Date: Thu, 16 Oct 2008 00:34:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Thorsten Leemhuis <thl@ct.heise.de>
cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <48F6E6EF.8020701@ct.heise.de>
Message-ID: <alpine.DEB.1.10.0810160032550.3905@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <48F6E6EF.8020701@ct.heise.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Thorsten Leemhuis wrote:

> On 16.10.2008 02:25, Greg KH wrote:
>> You brought this topic up a few months ago, and passed it off as
>> something we would discuss at the kernel summit.  But that never
>> happened, so I figured I'd bring it up again here.
>> 
>> So, as someone who constantly is dealing with kernel version numbers all
>> the time with the -stable trees, our current numbering scheme is a pain
>> a times.  How about this proposal instead?
>> 
>> We number the kernel based on the year, and the numbers of releases we
>> have done this year:
>> 	YEAR.NUMBER.MINOR_RELEASE
>> 
>> For example, the first release in 2009 would be called:
>> 	2009.0.0
>> The second:
>> 	2009.1.0
>> [...]
>
> That afaics has one minor downside: You don't know in advance how the next 
> kernel is going to be called. Example: the kernel that is currently developed 
> could become 2008.4 (the fifth kernel in 2008) if this development cycle in 
> the end is one of the quicker ones and gets finished this year. But if 
> everything is a bit slower then it might become 2009.0 (the first one in 
> 2009).
>
> Hence people that write a lot of articles about things that happen in linux 
> land (like LWN.net or I do) would be forced to write sentences like "[...]the 
> kernel that will become 2008.3 or 2009.0 will have feature foo that works 
> like this[...]". That will get really confusing if you read those articles 
> half a year later -- especially if that kernel became 2008.3 in the end, 
> because foo in 2009.0 might already look quite different again...

pick a name when the merge window opens

either based on when the merge window opens, or when it's expected to be 
released (and accept that you may have a 2008.3 released in early 2009, or 
a 2009.1 released in december 2008)

David Lang
