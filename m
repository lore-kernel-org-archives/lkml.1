Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZFFGlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZFFGlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZFFGla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:41:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59145 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZFFGl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:41:29 -0400
Message-ID: <4A2A0E8C.1010109@cs.helsinki.fi>
Date: Sat, 06 Jun 2009 09:37:00 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Woody Suwalski <woodys@xandros.com>, jbarnes@virtuousgeek.org,
       eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org, tim.gardner@canonical.com, apw@canonical.com,
       stefan.bader@canonical.com
Subject: Re: Intel 915GM MCHBAR bug
References: <4A242C81.6020906@cs.helsinki.fi>	<4A298971.5080006@xandros.com>	<4A2A0951.1020608@cs.helsinki.fi> <20090605232711.d8503262.akpm@linux-foundation.org>
In-Reply-To: <20090605232711.d8503262.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, 06 Jun 2009 09:14:41 +0300 Pekka Enberg <penberg@cs.helsinki.fi> 
wrote:
>>>> Wanna show us the patch?
>>>>
>>>> Because the world could certainly do with more i915 bugfixes :(
>>>   
>>> Here is Jesse's patch from 
>>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
>>> adopted for 2.6.30-rc8... (needed to redo hunk #3 for i915_gem_tile.c)
>> Yup. I took the two patches from here:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314
>>
>> and did the same rediffing on top of 2.6.30-rc8 for the first one.
>>
>> Andrew, do you want me to forward you the (tested) patches or should we 
>> wait for Jesse et al to take care of it?
> 
> Yes, please send them out.

OK, I did that. I am bit unhappy that I had to do it, though. The patch 
dates back to January (!) and Ubuntu folks have been carrying it for a 
while now.

Looking at the amount of reports out in the wild (on Ubuntu forums, 
etc.), I really don't understand why this wasn't submitted earlier. 
Instead, the bug was flagged with low priority because it's "just a 
performance problem." Considering the system is more or less unusable 
for me, I obviously think it's a critical bug fix.

Andrew Morton wrote:
> These might end up being 2.6.30.1 material.

Yes, agreed completely. We probably want ACK from Jesse and Bjorn, though.

			Pekka
