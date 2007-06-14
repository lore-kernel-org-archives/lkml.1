Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXFNVVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXFNVVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXFNVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:21:18 -0400
Received: from lucidpixels.com ([75.144.35.66]:56061 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXFNVVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:21:17 -0400
Date: Thu, 14 Jun 2007 17:21:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Pim Zandbergen <P.Zandbergen@macroscoop.nl>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706141418.42082.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.64.0706141720330.28719@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com> <4671992D.7060400@macroscoop.nl>
 <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
 <200706141418.42082.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Jesse Barnes wrote:

> On Thursday, June 14, 2007 1:26:07 Justin Piszcz wrote:
>> On Thu, 14 Jun 2007, Pim Zandbergen wrote:
>>> Thanks for this patch. I was having the exact same symptoms as
>>> Justin Piszcz, on a different, but similar motherboard:
>>>
>>> Motherboard: GigaByte GA-G33-DS3R
>>> BIOS rev: F2
>>> Chipset: Intel G33
>>> Memory: 8GB
>>> Distro: Fedora 7 x86_64
>>> Kernel: kernel-2.6.21-1.3194.fc7
>>>
>>> Building vanilla 2.6.22-rc4 with your patch solved the problem.
>>>
>>> I'm now seeing this in the syslog
>>>
>>> ***************
>>> **** WARNING: likely BIOS bug
>>> **** MTRRs don't cover all of memory, trimmed 196608 pages
>>> ***************
>>>
>>> leaving me 7416672 kB of usable memory.
>>>
>>> If there's any way I can help with more info or testing,
>>> then let me know.
>>>
>>> Thanks,
>>> Pim
>
> Thanks for testing, Pim.  Glad it works for you.  Keep an eye out for
> BIOS upgrades, the next version might fix it.
>
>> That's strange, I guess different chipsets 'chew' up different
>> amounts of memory OR you have your DVT(?) (video-card
>> memory/aperature) set to 256MB? I have mine set to 128MB, in top:
>>
>> Mem:   8039576k total,  6187304k used,  1852272k free,      696k
>> buffers
>>
>> What type of memory are you using and what is your DVT set to?
>
> Different BIOSes will map things differently, so I'd expect differences
> in the "trimmmed xxx pages" message across machines.  But yeah, BIOS
> config options can also affect things, in particular I've heard that
> the fan control options change MTRR setup significantly.
>
> Jesse
>

To Intel,

When will HECI be supported via the kernel?  When it becomes supported, 
would that alter the MTRR map at all?

Justin.
