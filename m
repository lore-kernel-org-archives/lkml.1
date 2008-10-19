Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbYJSRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbYJSRrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYJSRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:47:12 -0400
Received: from mail.lang.hm ([64.81.33.126]:38478 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYJSRrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:47:12 -0400
Date: Sun, 19 Oct 2008 10:47:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <200810191945.16271.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0810191045500.20238@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <200810191451.24342.rjw@sisk.pl> <alpine.DEB.1.10.0810190928360.20238@asgard.lang.hm> <200810191945.16271.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Rafael J. Wysocki wrote:

> On Sunday, 19 of October 2008, david@lang.hm wrote:
>> On Sun, 19 Oct 2008, Rafael J. Wysocki wrote:
>>
>>> On Sunday, 19 of October 2008, Jiri Kosina wrote:
>>>> On Fri, 17 Oct 2008, david@lang.hm wrote:
>>>>
>>>>>> Surely some scripts will start to break as soon as the third number gets
>>>>>> three digits.
>>>>> we've had three digit numbers in the third position before (2.3 and 2.5
>>>>> went well past three digits IIRC)
>>>>
>>>> Did we? I only recall 2.5.7[something] and 2.3.5[something] (plus special
>>>> 2.3.99 release).
>>>>
>>>>>> Actually, I thought we could continue to use a w.x.y.z numbering
>>>>>> scheme, but in such a way that:
>>>>>> w = ($year - 2000) / 10 + 2 (so that we start from 2)
>>>>>> x = $year % 10
>>>>>> y = (number of major release in $year)
>>>>>> z = (number of stable version for major release w.x.y)
>>>>>> Then, the first major release in 2009 would be 2.9.1 and its first
>>>>>> -stable "child" would become 2.9.1.1.  In turn, the first major
>>>>>> release in 2010 could be 3.0.1 and so on.
>>>>> if you want the part of the version number to increment based on the year,
>>>>> just make it the year and don't complicate things.
>>>>
>>>> In addition to that, having the kernel version dependent on year doesn't
>>>> really seem to make much sense to me. Simply said, I don't see any
>>>> relation of kernel source code contents to the current date in whatever
>>>> calendar system.
>>>>
>>>> And 2.x+1.y-rcZ+1 immediately following 2.x.y-rcZ really hurts my eyes :)
>>>
>>> Hm, why would that happen?
>>
>> with the date based numbers, that was one of the things that 'could'
>> happen as the year changed (2008.5.0-rc4 would be followed by
>> 2009.1.0-rc5)
>
> Well, in that case I think it would be reasonable to cuntinue the 2008
> numbering so that 2009.1.0-rc5 in your example would still be 2008.5.0-rc5.
>
> That said, I kind of agree that the numbering need not be time-related.  One
> alternative might be to release 2.9.0 instead of 2.6.29 and then continue in
> in such a way that each of the three numbers is always a one-digit decimal.
> Then, we'd have 2.9.0, 2.9.1 ... 2.9.9, 3.0.0, 3.0.1 etc.

so how would you do the -stable releases?

David Lang
