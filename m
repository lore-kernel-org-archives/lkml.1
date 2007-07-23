Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbXGWEKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbXGWEKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 00:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXGWEKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 00:10:01 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52414
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXGWEKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 00:10:00 -0400
Date: Sun, 22 Jul 2007 21:09:01 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Power Management framework proposal
In-Reply-To: <1185163239.2714.37.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0707222105310.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> 
 <1185125189.2714.13.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm> 
 <1185143240.2714.24.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0707221946170.6350@asgard.lang.hm> <1185163239.2714.37.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Arjan van de Ven wrote:

> Date: Sun, 22 Jul 2007 21:00:39 -0700
> From: Arjan van de Ven <arjan@infradead.org>
> To: david@lang.hm
> Cc: LKML <linux-kernel@vger.kernel.org>,
>     linux-pm <linux-pm@lists.linux-foundation.org>
> Subject: Re: Power Management framework proposal
> 
>> example 1: a laptop screen
>>
>> mode  capacity power description
>> 0        0        0    off
>> 1      100      100    full brightness
>> 2       70       60    half power to the backlight
>> 3       50       35    quarter power to the backlight
>> 4       30       25    eighth power to the backlight
>> 5        5       10    backlight off.
>>
>> example 2: a front-panel display on a server (no variable backlight
>> control)
>>
>> mode capacity power description
>> 0       0        0   off
>> 1     100      100   backlight on
>> 2      50       10   backlight off
>
>
> the problem is: the person who SETS these needs to know what they mean.

that's what the description is for. this info can be provided by the 
driver as part of the list_modes() function.

> And the side that implements these needs to translate them as well...
>
> that's two translations, and information is lost in the abstract number
> in the middle that doesn't mean anything

with the current implementations you instead need to know what function to 
call and what the meaning of that function is. that's not documented in 
any system discoverable way, you have to read the driver documentation or 
code to find it.

>> if you don't want to make the shift with cpufreq, that's fine. it
>> sounds
>> like you are at least 90% of the way there anyway, it's not that big
>> a
>> deal, but do you think that there's value in replacing the current
>> ad-hoc
>> approach with something more structured (even if it's not this
>> proposal)?
>
> as someone who wrote (part of) a power policy manager; sorry but you
> take away information I need, and in addition the different API's are
> absolutely no big deal.

assuming that nobody else chimes in to disagree with you I'll accept your 
judgement and drop the issue.

David Lang
