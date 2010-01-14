Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489Ab0ANTQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0ANTQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366Ab0ANTQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:16:05 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33939 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0ANTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:16:04 -0500
Message-ID: <4B4F6D5F.10008@cs.helsinki.fi>
Date: Thu, 14 Jan 2010 21:15:43 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Subject: Re: Linux 2.6.33-rc4
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>	<20100113133357.67f9df6d@jbarnes-piketon>	<4B4E403C.1050509@cs.helsinki.fi> <20100113165530.2a7e7645@jbarnes-piketon>
In-Reply-To: <20100113165530.2a7e7645@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wed, 13 Jan 2010 23:50:52 +0200
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> Jesse Barnes wrote:
>>> On Wed, 13 Jan 2010 23:03:00 +0200
>>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>
>>>> On Wed, Jan 13, 2010 at 7:44 AM, Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>> Hmm. Odd release. Something like 40% of the patches are in DRM
>>>>> (mostly nouveau and radeon, both staging, so it's a bit less scary
>>>>> than it sounds. But there's a noticeable i915 component too).
>>>>> That's all pretty unusual, afaik.
>>>> 2.6.33-rc4 still suffers from an annoying screen flicker with i915
>>>> and KMS on my machine. I *think* it started with 2.6.33-rc1 but I
>>>> haven't had the time to dig deeper.
>>> Does this patch fix it?  If so I'll queue something like this up for
>>> -rc5.
>> Yes, it does. Thanks!
> 
> Great, thanks for testing.  I'll send Eric a patch to disable this
> feature more properly.

OK, I think I am seeing a different kind of flicker now. It doesn't 
happen anywhere as often as before (which is probably why I missed it 
last night). The flicker is more like a flash of some other window 
whereas the flicker before used to "shake" the screen.

Does this ring a bell?

			Pekka
