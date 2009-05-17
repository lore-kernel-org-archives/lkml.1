Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZEQT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZEQT0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZEQT0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:26:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:33077 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZEQTZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:25:59 -0400
Date: Sun, 17 May 2009 12:25:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: devzero@web.de
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Where do we stand with the Xen patches?
In-Reply-To: <720338507@web.de>
Message-ID: <alpine.DEB.1.10.0905171223250.26653@asgard>
References: <720338507@web.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009, devzero@web.de wrote:

>>> Aside from some whitespace issues around some Impact: lines, I
>>> don't know of any outstanding problems.  (I just pushed an updates
>>> to these branches to fix those, and fold a change to address
>>> Jesse's comment.)
>>>
>>> Please tell me if you have any further issues which prevents you
>>> from pulling these changes.  Otherwise I'd appreciate it if you
>>> pulled them soon, as we're already on -rc5, and I have more
>>> changes I'd like to prep for the next merge window.
>>
>> As in the past, my main worry is performance overhead of paravirt in
>> general.
>>
>> The patches that dont affect any native kernel fast path are
>> probably OK (but still pending final review).
>>
>> Regarding patches that do change the fastpath i'll do a round of
>> measurements of CONFIG_PARAVIRT against !CONFIG_PARAVIRT kernels,
>> and make up my mind based on that.
>>
>> You could accelerate this by sending some "perf stat" hard numbers
>> to give us an idea about where we stand today.
>>
>> 	Ingo
>
> maybe this is iust a stupid comment (please forgive, i?m no advanced kernel
> hacker), but can?t the code inserted by the patches and which changes the
> fastpath just #IFDEF`ed at the critical offsets ?  (as building a dom0 kernel is
> just another build target, isn`t it ?)

no, if dom0 is going to be widely deployed, it will be because the distros 
turn on dom0 support by default. as a result any penalties due to xen 
support will be felt by all users of those distros (even if they don't use 
xen)

David Lang
