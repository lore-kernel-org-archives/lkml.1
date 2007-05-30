Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXE3Iyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXE3Iyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXE3Iym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:54:42 -0400
Received: from lucidpixels.com ([75.144.35.66]:57408 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXE3Iyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:54:41 -0400
Date: Wed, 30 May 2007 04:54:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
 motherboards.
In-Reply-To: <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0705300453410.3755@p34.internal.lan>
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no> <465CF8CA.8070009@shaw.ca>
 <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Justin Piszcz wrote:

>
>
> On Tue, 29 May 2007, Robert Hancock wrote:
>
>> Justin Piszcz wrote:
>>> Short Description of Problem:
>>> Linux 2.6.21.3 does not run properly with 8GB of ram on the Intel 965WH 
>>> motherboard.
>>> I found it interesting in make menuconfig on x86_64 there is no 4GB/64GB
>>> options in the kernel that I remember seeing in 32bit.
>> 
>> That's because that option is not applicable in 64-bit mode.
>> 
>> Can you send your full dmesg output from the 8GB bootup?
>> 
>> -- 
>> Robert Hancock      Saskatoon, SK, Canada
>> To email, remove "nospam" from hancockr@nospamshaw.ca
>> Home Page: http://www.roberthancock.com/
>> 
>
> Kernel dmesg attached from 8GB bootup.
>
> Robert, how come the option is not applicable in 64-bit mode? If I want to 
> use all 8GB of memory I need to run a 32-bit kernel?
>
> Justin.

Look at how slow the raid benchmarks are in dmesg with 8GB of memory!

[   59.592560] raid6: using algorithm sse2x4 (476 MB/s)
[   59.597558] raid5: using function: generic_sse (56.000 MB/sec)

Yikes!

With mem=4096M:
[   60.336352] raid6: using algorithm sse2x4 (6804 MB/s)
[   60.341345] raid5: using function: generic_sse (8552.000 MB/sec)

What is going on here?

Justin.


