Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0BQWjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:39:05 -0500
Received: from mail.crca.org.au ([67.207.131.56]:42005 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0BQWjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:39:01 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B7C709B.2060809@crca.org.au>
Date: Thu, 18 Feb 2010 09:41:31 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.33-rc8 regression on i915: resume from hibernate locks up
 every 2nd time
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com> <201002172152.39255.rjw@sisk.pl> <74fd948d1002171410l5688c3dfy125ac5c7e80ad1a1@mail.gmail.com> <201002172320.57491.rjw@sisk.pl>
In-Reply-To: <201002172320.57491.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Rafael J. Wysocki wrote:
> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
>> 2010/2/17 Rafael J. Wysocki <rjw@sisk.pl>:
>>> On Wednesday 17 February 2010, Rafael J. Wysocki wrote:
>>>> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
>>>>> Hi,
>>>>>
>>>>> commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
>>>>> while aborting hibernation) introduced two new issues which were not
>>>>> present in 2.6.33-rc7:
>>>>>
>>>>> - every second resume from hibernate results in a blank screen
>>>>> - the annoying flash at the end of atomic copy/restore during the
>>>>> hibernate process is back (present in kernels < 2.6.33)
>>>>>
>>>>> The first issue is serious, the second is just an annoyance.
>>>> The second one is an expected price of fixing the aborted hibernation
>>>> regression.
>>>>
>>>> The first one shouldn't happen, though.
>>>>
>>>> I'll see if I can reproduce that locally.
>>> No, I can't.
>>>
>>> Is the driver compiled directly into the kernel or modular?
>> The driver is modular.
>> And sorry, I forgot to tell you I'm using TuxOnIce, it certainly makes
>> a difference.
> 
> It shouldn't in fact, although I'm not sure.

You're right. It shouldn't. I'm using exactly the same driver model
calls in exactly the same order, and not changing driver code at all.

Regards,

Nigel
