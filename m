Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXF2Jtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXF2Jtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXF2Jts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:49:48 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:39800 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXF2Jts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:49:48 -0400
In-Reply-To: <46B96294322F7D458F9648B60E15112C6F3312@zch01exm26.fsl.freescale.net>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com> <5f0438212493766009684d63e41c85cc@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C6F3281@zch01exm26.fsl.freescale.net> <8ee77b5f79ee0c0c5ead1f0acbe95bda@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C6F3312@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e463944d2ab9266347361f7cd3b61b09@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>,
       <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5 v2] Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Fri, 29 Jun 2007 11:49:42 +0200
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> No.  The #address-cells is determined by the bus binding,
>> so that all RapidIO busses on the planet can be represented
>> in a similar way in the OF device tree.  Take for example
>> the PCI binding, which gives you three address cells -- one
>> to distinguish between different address spaces (configuration
>> space, legacy I/O space, memory mapped space) and to contain
>> some flags (prefetchable vs. non-prefetchable, etc.); the
>> other two 32-bit cells contain a 64-bit address, although
>> config and legacy I/O never are more than 32 bit, and many
>> PCI devices can't do 64-bit addressing at all.
>>
>> Now, there is no OF binding for RapidIO yet of course, but
>> it would be good to start thinking about one while doing
>> the binding for your specific controller -- it will make
>> life easier down the line for everyone, including yourself.
>>
> How about I add more words here for more clear expression?
> Such as "<2> for 34 and 50 bit address, <3> for 66 bit address".

You should more explicitly define the address format, i.e.
what every bit means -- just saying it is 64 or 96 bits isn't
enough.  While you're doing that, think of a way that can
represent _every possible_ RapidIO address, not just the ones
supported by this particular controller.


Segher

