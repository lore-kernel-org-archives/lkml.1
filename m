Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXGQEsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXGQEsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXGQEss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:48:48 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44805
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXGQEsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:48:47 -0400
Date: Mon, 16 Jul 2007 21:37:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Al Boldi <a1426z@gawab.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Hibernation considerations
In-Reply-To: <200707161951.35225.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0707162134040.19248@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707161045520.3410-100000@iolanthe.rowland.org>
 <200707161951.35225.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Boldi wrote:

> Alan Stern wrote:
>> On Mon, 16 Jul 2007, Al Boldi wrote:
>>> From a kexec'd hibernation kernel pov, both S3 and S4 look conceptually
>>> exactly the same.  The only difference is, in S3 the memory is in memory
>>> and in S4 the memory is on storage.  All device handling is exactly the
>>> same, so if there is a problem with device handling between the kexec'd
>>> hibernation kernel and the normal kernel, then that would have made
>>> itself visible.
>>
>> You have contradicted yourself.  "In S3 the memory is in memory and in
>> S4 the memory is on storage".  How does the memory get onto storage?
>> The kexec'd hibernation kernel writes it there.  To do so it accesses a
>> storage device.
>>
>> Consequently the device handling _cannot_ be exactly the same in S3 and
>> S4.
>
> Ok, you should have read this in the context of suspending/resuming from/to
> the normal kernel, and in that case they are exactly the same, i.e. kexec -e
> for suspend and kexec -j for resume.
>
> BTW, it would be really helpful if people would actually try the kexec
> hibernation patches, as this may yield a much more constructive discussion.

I would love to, but so far I don't see the nessasary pieces

once I kexec to the new kernel, how can it find out what pages of memory 
(and swap) need to be saved?

If i knew that then I could write a trivial perl program to save those 
pages with the appropriate headers to make a suspend file.

however, I'm now being told that that suspend file won't work if the 
machine is actually powered off, so there's a need to something more for 
the wake-up side of things as well.

David Lang
