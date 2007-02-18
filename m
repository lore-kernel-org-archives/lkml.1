Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbXBRAjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbXBRAjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965464AbXBRAjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:39:40 -0500
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:54032 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965457AbXBRAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:39:39 -0500
References: <200702162110.03355.kernel@kolivas.org> <200702171417.28376.kernel@kolivas.org> <45D74D34.5020201@redhat.com> <200702180800.07393.kernel@kolivas.org> <20070217154746.7ff10870.akpm@linux-foundation.org>
Message-ID: <cone.1171759159.711805.13918.501@kolivas.org>
X-Mailer: http://www.courier-mta.org/cone/
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, michael chang <thenewme91@gmail.com>,
       ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-ck1
Date: Sun, 18 Feb 2007 11:39:19 +1100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Sun, 18 Feb 2007 08:00:06 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> 
>> On Sunday 18 February 2007 05:45, Chuck Ebbert wrote:
>> ...
>> > But the one I like, mm-filesize_dependant_lru_cache_add.patch,
>> > has an on-off switch.
>> >
>>
>> ...
>>
>> Do you still want this patch for mainline?... 
> 
> Don't think so.  The problems I see are:
> 
> - It's a system-wide knob.  In many situations this will do the wrong
>   thing.  Controlling pagecache should be per-process.
> 
> - Its heuristics for working out when to invalidate the pagecache will be
>   too much for some situations and too little for others.
> 
> - Whatever we do, there will be some applications in some situations
>   which are hurt badly by changes like this: they'll do heaps of extra IO.
> 
> 
> Generally, the penalties for getting this stuff wrong are very very high:
> orders of magnitude slowdowns in the right situations.  Which I suspect
> will make any system-wide knob ultimately unsuccessful.

Rest assured I wasn't interested in pushing this patch for mainline anyway.

-ck users can also rest assured about this patch for the following reasons:

- The usage pattern on a desktop will guarantee that this patch helps 99.9% 
of the time rather than hurts. Therefore, this feature is enabled by default 
on -ck.

- With the usage pattern on a server of any sort, it will be unknown whether 
this patch helps or harms. Therefore, this feature is disabled by default on 
-cks.

--
-ck

