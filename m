Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZFFGTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZFFGTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZFFGTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:19:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47077 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZFFGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:19:10 -0400
Message-ID: <4A2A0951.1020608@cs.helsinki.fi>
Date: Sat, 06 Jun 2009 09:14:41 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Woody Suwalski <woodys@xandros.com>
CC: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org, tim.gardner@canonical.com, apw@canonical.com,
       stefan.bader@canonical.com
Subject: Re: Intel 915GM MCHBAR bug
References: <4A242C81.6020906@cs.helsinki.fi> <4A298971.5080006@xandros.com>
In-Reply-To: <4A298971.5080006@xandros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woody Suwalski wrote:
> Andrew Morton wrote:
>> On Fri, 05 Jun 2009 11:02:21 +0300
>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>>  
>>> Hi Jesse,
>>>
>>> (I am cc'ing linux-kernel.)
>>>
>>> On Mon, 01 Jun 2009 22:31:13 +0300
>>>    
>>>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>>
>>>>      
>>>>> Hi Jesse,
>>>>>
>>>>> I am seeing this on my Eee PC 701 which is running a Ubuntu 
>>>>> 2.6.28-11.42-generic stock kernel:
>>>>>
>>>>> [   76.826966] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't
>>>>> read from MCHBAR.  Disabling tiling.
>>>>> [   76.827215] [drm] Initialized i915 1.6.0 20080730 on minor 0
>>>>> [   76.834037] [drm:i915_setparam] *ERROR* unknown parameter 4
>>>>> [   76.834104] [drm:i915_getparam] *ERROR* Unknown parameter 6
>>>>>
>>>>> Google turned up this patch
>>>>>
>>>>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
>>>>>
>>>>>
>>>>> but I don't seem to find it mainline kernel.
>>>>>
>>>>> Was the bug fixed in some other way? It seem that distributions have
>>>>> not yet picked up your patch and I am unsure if it's in any of the
>>>>> -stable kernels.
>>>>>         
>>> On Thu, 2009-06-04 at 11:27 +0100, Jesse Barnes wrote:
>>>    
>>>> I think Eric acked it but may not have pushed it to drm-intel-next
>>>> yet.  Should happen in the next week or two though as we prepare the
>>>> merge window series.
>>>>       
>>> OK, thanks for the info! FYI, I tested 2.6.30-rc8 with your patch
>>> applied and everything works smoothly on my EeePC 701. I did not test
>>> plain 2.6.30-rc8 as I expect it to show same kind of behavior as Ubuntu
>>> distro kernel. Is this correct or do you want me to test 2.6.30-rc8 too?
>>>
>>> I wonder why the patch hasn't received more attention as it's a pretty
>>> critical bug. The _default_ Ubuntu 9.04 netbook remix installation is
>>> completely broken for EeePC 701 (and probably others as well) without
>>> the patch. And it's not as if I'm the only one that suffers from it. A
>>> quick Google search reveals that a lot of people are hitting it.
>>>
>>> So I really do think we need to merge this patch to the upcoming 2.6.31
>>> ASAP and backport it to -stable after it has gotten some more testing.
>>
>> Wanna show us the patch?
>>
>> Because the world could certainly do with more i915 bugfixes :(
>   
> Here is Jesse's patch from 
> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
> adopted for 2.6.30-rc8... (needed to redo hunk #3 for i915_gem_tile.c)

Yup. I took the two patches from here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314

and did the same rediffing on top of 2.6.30-rc8 for the first one.

Andrew, do you want me to forward you the (tested) patches or should we 
wait for Jesse et al to take care of it?

			Pekka
