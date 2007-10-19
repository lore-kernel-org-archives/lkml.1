Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXJSQag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXJSQag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbXJSQaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:30:12 -0400
Received: from rtr.ca ([76.10.145.34]:2359 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbXJSQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:30:09 -0400
Message-ID: <4718DB8F.3070903@rtr.ca>
Date: Fri, 19 Oct 2007 12:30:07 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.23.1 Freezes on GB data transfers
References: <12bfabe40710170420m6882ea8eg3b8e6e7db72a0cdd@mail.gmail.com> <2c0942db0710190858n647192d6t270e43b2a3075320@mail.gmail.com>
In-Reply-To: <2c0942db0710190858n647192d6t270e43b2a3075320@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 10/17/07, Giangiacomo Mariotti <gg.mariotti@gmail.com> wrote:
>> Linux Kernel 2.6.23.1 freezes on GB data transfers.
>>
>> Pc completely freezed while transferring 4Gb of data from
>> dvd(/dev/hdc) to hd(nothing else was happening, cpu general usage at
>> 5-6%).Except for this,it has been working flawlessly for 1 day,but
>> when I tried to transfer 4Gb of data from the dvd to the hd,after
>> having completed 60% of the transfer, the system became completely
>> freezed,no keyboard,no mouse,no consoles,nothing, and the Caps Lock
>> LED started to blink.
> 
> The blinking Caps lock LED means that your system is Oopsing. Please
> try your test again from a console (not from X), and see if an oops
> message is printed out. If it is, you'll need to either copy it down
> or take a photograph of it with a digital camera, then post the text
> of it or post a link to the image.


I believe this is now the forth report of blinking-leds lockup with 2.6.23.1.

I wonder what's causing it?
My system has this as well, totally random, once every day or so.
New behaviour since 2.6.23-rc9 (I posted previously about this).

Cheers
