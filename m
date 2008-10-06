Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYJFRQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYJFRQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYJFRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:16:26 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.159]:35579 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbYJFRQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:16:25 -0400
Message-ID: <48EA47DF.2090207@cmu.edu>
Date: Mon, 06 Oct 2008 13:16:15 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: how to link to hrtimers in the kernel
References: <48EA31A4.6080903@cmu.edu> <Pine.LNX.4.64.0810060931140.4121@shark.he.net> <alpine.LFD.2.00.0810061849090.3166@apollo>
In-Reply-To: <alpine.LFD.2.00.0810061849090.3166@apollo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Mon, 6 Oct 2008, Randy.Dunlap wrote:
>> On Mon, 6 Oct 2008, George Nychis wrote:
>>
>>> Hi all,
>>>
>>> I have modified drivers/usb/core/devio.c to use hrtimer_nanosleep(), and have
>>> included linux/hrtimer.h with it.
> 
> Please do not use hrtimer_nanosleep() in drivers. That's
> wrong.
> 
> What do you want to achieve ?
>  

I am trying to sleep at the microsecond level, which ssleep and msleep 
cannot provide.  I couldn't find any other nanosleep method in the kernel.

I found information by searching the net on using jiffies to accomplish 
sleep periods, but that is not high enough in resolution.

I'd greatly appreciate any feedback.

Thanks!
George
