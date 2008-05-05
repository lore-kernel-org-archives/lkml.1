Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbYEESiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbYEESiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbYEES32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:29:28 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:35644 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761386AbYEES3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:29:22 -0400
Message-ID: <481F51F0.4000408@krogh.cc>
Date: Mon, 05 May 2008 20:29:04 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	 <20080501223938.921f7cd2.akpm@linux-foundation.org>	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc>	 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>	 <481B70F9.6000201@krogh.cc> <481F4728.9050100@krogh.cc>	 <Pine.LNX.4.64.0805051050350.27703@shark.he.net>	 <481F49C0.4080001@krogh.cc> <2c0942db0805051121r47cc97d2jb71cc8ab9eaa7981@mail.gmail.com>
In-Reply-To: <2c0942db0805051121r47cc97d2jb71cc8ab9eaa7981@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Mon, May 5, 2008 at 10:54 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>> Randy.Dunlap wrote:
>>
>>> On Mon, 5 May 2008, Jesper Krogh wrote:
>>>
>>>
>>>> Jesper Krogh wrote:
>>>>
>>>>> Ray Lee wrote:
>>>>>
>>>>>> BTW, I may have missed this earlier, but does it happen *anywhere*
>> on
>>>>>> the troublesome filesystem (ie, in a newly created subdirectory)?
>>>>>>
>>>>> Yes. It is reproducible on a newly created subdirectory on the
>>>>> filesystem.
>>>>>
>>>> Now I've created a new filesystem. (resized the original LVM-volume to
>> half
>>>> and created a new ext3 one next to it). The problem persists on this new
>>>> filesystem.
>>>>
>>>> Just guessing, can there be something timing related in clearing the
>> FS-cache
>>>> for the filesystem?
>>>>
>>>> Any other suggestions/pointers.
>>>>
>>> Hi,
>>>
>>> Has anyone else been able to reproduce this problem?
>>>
>>  No, and out of my systems. I only have this external SCSI-IDE-raid device I
>> can reproduce it on. The internal system disks doesnt allow me to reproduce
>> it on the same installation.
> 
> I'd been meaning to ask what the topology was. External, eh? Are you
> sure the enclosure, cabling, and card/connectors are all good? Have
> you tried swapping out cables?

It is new SCSI-controller, new cable and new terminator put onto it. But
(just enlighten me), if I had problems at this level I'd expect the
serverlog to be full of SCSI/FS-related errors and not just a single
syscall, that doesn't even touch the array due to caching, to be
failing.

Jesper
-- 
Jesper
