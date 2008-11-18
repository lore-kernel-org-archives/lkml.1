Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYKRREd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYKRREd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYKRREZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:04:25 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28650 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYKRREY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:04:24 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=t36uTbNctW2kqKI0HG0A:9 a=18xRyBx3kwlqNikTilUA:7 a=GxTNnvSIIhWljiopYVkRGvft5uUA:4 a=8vwIo7ogVYEA:10 a=Ipjc5-nZaCwA:10
Message-ID: <4922F596.1010805@shaw.ca>
Date: Tue, 18 Nov 2008 11:04:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fredrik_Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com> <4922ED5A.3030808@shaw.ca> <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
In-Reply-To: <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrik Markström wrote:
> Thanks for the prompt respons.
> 
> I do agree that it would be better for everyone to release it under
> GPL and I have already expressed that to our customer.
> 
> At this point I feel that we have two possibilities, help our customer
> violate GPL or say no to the project. I'd prefer a third option where
> I could tell the customer that we can setup the project in a certain
> way (some "cleanroom" setup ?) to ensure that the results can not be
> considered derived work.

The problem is that if it's coded specifically for Linux it's pretty 
much inherently a derived work. Things like the NVIDIA binary graphics 
driver, the old Atheros madwifi HAL stuff, etc. are on a little more 
solid ground as their binary part is theoretically OS-independent and 
there's an open-source shim layer to interface to the kernel, but some 
would say even they are taking some legal risk.

> 
> Is your short answer also the definite answer considering this ?

I don't think anyone on this list is a lawyer, and since this is a legal 
question, legal advice would be what I would suggest you and/or this 
company should have before considering going down the non-GPL driver 
road. The risk is mainly that a kernel contributor (or one of their 
employers like IBM, Red Hat, etc.) could sue them for violating the GPL.

> 
> /Fredrik
> 
> 
> 
> 
> 2008/11/18 Robert Hancock <hancockr@shaw.ca>:
>> Fredrik Markström wrote:
>>> Linus, others...
>>>
>>> I'm working for as a consultant for a large hardware company porting
>>> Linux to their new cpu-architecture and everything is pretty much
>>> up and running. Now they want us to develop a closed-source (to
>>> protect their IP) ethernet driver for their proprietary Ethernet MAC.
>>>
>>> My question is:    Is there a fair way to do this and still comply to
>>> the intent and spirit of the Linux licensing ?
>>>
>>> If yes, how ?
>> In a word, I would say: no.
>>
>> When developing a non-GPL kernel driver, one finds themselves on very shaky
>> legal ground. Unless one is 100% sure their code is not legally considered a
>> derived work from the kernel, it's likely a GPL violation.
>>
>> One could point out the pile of other Ethernet drivers in the kernel from
>> the likes of Intel, Broadcom, etc. and ask why those companies did not feel
>> the need to "protect their IP" in this manner.. as well as the significant
>> advantages of having their driver in the mainline kernel, and the horrible
>> disadvantages of trying to manage closed-source drivers..
>>
> 
