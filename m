Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbXGSDi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbXGSDi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXGSDiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:38:50 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58176
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448AbXGSDit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:38:49 -0400
Date: Wed, 18 Jul 2007 20:30:47 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: nigel@suspend2.net
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
 hibernation
In-Reply-To: <200707191215.05245.nigel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.64.0707182026130.19248@asgard.lang.hm>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
 <20070718180420.02352d4f.akpm@linux-foundation.org>
 <200707191215.05245.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Nigel Cunningham wrote:

> Hi.
>
> On Thursday 19 July 2007 11:04:20 Andrew Morton wrote:
>> On Sun, 15 Jul 2007 15:13:13 +0800
>> "Huang, Ying" <ying.huang@intel.com> wrote:
>>
>>>
>>> The changelog between v1 and v2
>>>
>>> 1. The kexec jump implementation is put into the kexec/kdump
>>>    framework instead of software suspend framework. The device
>>>    and CPU state save/restore code of software suspend is called
>>>    when needed.
>>>
>>> 2. The same code path is used for both kexec a new kernel and jump
>>>    back to original kernel.
>>
>> I like the idea but I think I'll let people chat about it a bit more
>> before looking at merging the patches, OK?
>
> Please wait until you see a complete implementation that actually works. I'm
> sitting here quietly, following (and now breaking) the "If you can't say
> anything positive, don't say anything at all" line because I think that the
> more into the implementation details people get, the uglier this is going to
> show itself to be. I'm perfectly willing to be proven wrong, but haven't seen
> anything so far that's even begun to convince me otherwise.

as someone who's eager to have this work, I have to agree with Nigel that 
it's premature to talk about merging anything.

the only exception I could see is if there are other uses for this 
functionality. but even then, let things settle out a little bit.

David Lang
