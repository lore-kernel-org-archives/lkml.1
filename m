Return-Path: <linux-kernel-owner+w=401wt.eu-S936709AbXFFXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936709AbXFFXYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935647AbXFFXY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:24:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:39725 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763575AbXFFXYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:24:25 -0400
Date: Wed, 6 Jun 2007 19:24:24 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061620.10627.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061923470.2716@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061528.44070.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061857420.2716@p34.internal.lan>
 <200706061620.10627.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:57 pm Justin Piszcz wrote:
>> On Wed, 6 Jun 2007, Jesse Barnes wrote:
>>> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>>>> Nope, I booted with only netconsole= options.  I have a lot of HW
>>>> in the box and I guess the buffer is too small.  Not sure where to
>>>> change it in the kernel.  Looking..
>>>
>>> It's called "kernel log buffer size" and it's in "General setup".
>>>
>>> Jesse
>>
>> Did the dmesg output get you what you needed?  Why the few KB
>> difference?
>>
>> :)
>
> Yeah, looked at your e820 and your MTRR settings and I think my patch is
> doing the right thing (i.e. trimming just the right amount of memory,
> leaving you with as much as possible).
>
> The mem= approach though looks slightly off, but I haven't looked at
> x86_64's mem= handling to see why.  From a high level though, adjusting
> end_pfn is the right thing to do, since theoretically mem= could choose
> to make holes in your low memory and keep your high memory in the
> allocation pools (though it's not generally implemented this way).
>
> Jesse
>

Ahh, ok!  Sounds great, I will keep running the kernel with your patch 
without mem= and let you know if I see any issues.

Chances of getting this into 2.6.22-rc5?

Justin.
