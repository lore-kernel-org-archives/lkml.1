Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbXFCJP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbXFCJP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 05:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXFCJPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 05:15:15 -0400
Received: from heisenberg.zen.co.uk ([212.23.3.141]:51080 "EHLO
	heisenberg.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXFCJPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 05:15:13 -0400
Message-ID: <4662869A.9030700@gmail.com>
Date: Sun, 03 Jun 2007 10:15:06 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <20070602010539.GA13512@linux-os.sc.intel.com> <20070602092232.GP7217@one.firstfloor.org> <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-Heisenberg-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>
>
> On Sat, 2 Jun 2007, Andi Kleen wrote:
>
>>> I feel, having a silent/transparent workaround is not a good idea.
>>> With that
>>
>> If enough RAM is chopped off users will notice. They tend to complain
>> when they miss RAM.  I don't like panic very much because for many
>> users it will be a show stopper (even when they are not blessed
>> with "quiet" boots like some distributions do)
>>
>> The message in dmesg could be also emphasized a bit with a little
>> ASCII art (but no <blink> tag in there)
>>
>> The problem I'm more worried about is if the system will be really
>> stable --- could it be that the memory controller is still
>> misconfigured and cause other stability issues? (we've had such
>> cases in the past). Also I'm not sure we can handle the case of
>> the MTRR wrong not at the end of memory but at the hole sanely.
>>
>> -Andi
>>
>
> So far I have been booting with mem=8832M and have run stress/loaded
> the memory subsystem pretty good; what other tests should I run?
>
> It'd be nice if we could pose some sort of solution/warning for the
> future so other people do not have to experience the same problems.
>
> What are the next steps?
>
Wouldn't it be possible for the e820/MTRR set up code detect the problem
and suggest a mem=xxxx that would fix the problem (while also
complaining that the BIOS is broken)?

Matt

