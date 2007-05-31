Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXEaMeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXEaMeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXEaMdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:33:52 -0400
Received: from lucidpixels.com ([75.144.35.66]:40978 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852AbXEaMdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:33:51 -0400
Date: Thu, 31 May 2007 08:33:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Robert Hancock <hancockr@shaw.ca>
cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of
 RAM on Intel 965WH motherboards. (FULL DMESG)
In-Reply-To: <465E513E.60903@shaw.ca>
Message-ID: <Pine.LNX.4.64.0705310832460.6709@p34.internal.lan>
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
 <465E513E.60903@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Robert Hancock wrote:

> Parag Warudkar wrote:
>> Robert Hancock wrote:
>> 
>> 
>>> 0-3319MB
>>> 4096-8832MB
>>> 
>>> leaving 64MB of memory at the top of RAM uncached. What do you want to
>>> bet that something important (kernel code?) is getting loaded there..
>>> 
>>> So essentially it's a BIOS problem, it's not setting up the MTRRs
>>> properly in order to map all of RAM as cacheable. As Andi says, complain
>>> to Intel.
>>> 
>> 
>> Could the BADRAM patch be useful for him?
>> http://rick.vanrein.org/linux/badram/download.html has 2.6.21 version.
>> It says it supports x86_64. May be using this patch he can exclude
>> that RAM from being used/accessed?
>
> I think that mem=8832M would work as well, to make the kernel use only the 
> memory that is marked cacheable. (It looks like this parameter takes the 
> highest memory address we want the kernel to use, not the highest memory 
> amount.)
>
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>

Thanks for all the help, I have contacted Intel with this information and 
I am going to try and get an update today, I may also try that mem= 
parameter with 'almost 8gb' sometime as well.

Is this typical for Intel motherboards?  Do AMD motherboards fair any 
better?  Curious for any user reports of people using 8GB on desktop 
boards..?
