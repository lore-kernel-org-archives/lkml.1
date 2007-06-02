Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXFBUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXFBUL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXFBULu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:11:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:44069 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbXFBULt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:11:49 -0400
Date: Sat, 2 Jun 2007 16:11:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Andi Kleen <andi@firstfloor.org>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <20070602092232.GP7217@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
 <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org>
 <200706011441.57149.jbarnes@virtuousgeek.org> <20070602010539.GA13512@linux-os.sc.intel.com>
 <20070602092232.GP7217@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Andi Kleen wrote:

>> I feel, having a silent/transparent workaround is not a good idea. With that
>
> If enough RAM is chopped off users will notice. They tend to complain
> when they miss RAM.  I don't like panic very much because for many
> users it will be a show stopper (even when they are not blessed
> with "quiet" boots like some distributions do)
>
> The message in dmesg could be also emphasized a bit with a little
> ASCII art (but no <blink> tag in there)
>
> The problem I'm more worried about is if the system will be really
> stable --- could it be that the memory controller is still
> misconfigured and cause other stability issues? (we've had such
> cases in the past). Also I'm not sure we can handle the case of
> the MTRR wrong not at the end of memory but at the hole sanely.
>
> -Andi
>

So far I have been booting with mem=8832M and have run stress/loaded the 
memory subsystem pretty good; what other tests should I run?

It'd be nice if we could pose some sort of solution/warning for the future 
so other people do not have to experience the same problems.

What are the next steps?

Justin.

