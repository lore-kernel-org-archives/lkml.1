Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYEPJCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYEPJCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYEPJCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:02:22 -0400
Received: from mail.numalliance.com ([213.41.233.134]:65133 "EHLO
	mail.numalliance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYEPJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:02:20 -0400
Message-ID: <482D4CC8.2050501@free.fr>
Date: Fri, 16 May 2008 10:58:48 +0200
From: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080513)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
References: <1209462094.4816ed4e93977@imp.free.fr> <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com> <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com> <4821C526.8030901@free.fr> <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com> <4829566B.7090804@free.fr> <Pine.LNX.4.64.0805151036030.18708@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805151036030.18708@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter a écrit :
> On Tue, 13 May 2008, Stéphane ANCELOT wrote:
>
>   
>> I kept my kernel running with few applications for 5 days , doing
>> nothing more than backing up few kb of data on disk and refresh few X apps.
>>
>> Ater five days the global memory available go down from 24Mb to 8Mb ...
>>     
>
> That is normal. Linux tries to put all memory to use and will free on 
> demand.
>
>   
>> The are some signifiant changes in slabinfo but now, I do not know where
>> to search ?
>>     
>
> Compile the slabinfo tool.
>
> gcc -o slabinfo linux/Documentation/vm/slabinfo.c
>
> Then you can do
>
> slabinfo -T
>
> to get an overview of how much is used by slabs. But I do not see that 
> slabs are using an excessive amount. So toying around with slabinfo is 
> not going to get you anywhere.
>
>   
1) slabinfo  tells me SYSFS support for SLUB not active

In the kernel, there is SLAB or SLUB , my kernel is at this time 
configured for SLAB allocator.

it is documented SLUB minimizes cache line usage.
Do you think I have to switch to SLUB ?

2) regarding memory debugging, your reply and some mesages told it was 
normal the memory was growing (with ext3 buffer_heads...) and released 
on demand.
 This sounds to me it becomes VERY VERY difficult telling if my system 
is STABLE or NOT. Is there a way to bypass it ?
I assume I have to do some kind of small program trying to allocate 
almost the full remaining memory available at startup to empty caches ?


Best Regards
Steph




