Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZCLKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZCLKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZCLKDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:03:23 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:54935 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZCLKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:03:22 -0400
Message-ID: <49B8DDDF.8080708@cateee.net>
Date: Thu, 12 Mar 2009 11:03:11 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>	<20090309141655.GA24213@silver.sucs.org>	<20090309081109.376f7a7e@infradead.org>	<20090309153449.GB24213@silver.sucs.org> <20090309095330.30278385@infradead.org>
In-Reply-To: <20090309095330.30278385@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 9 Mar 2009 15:34:50 +0000
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
>> On Mon, Mar 09, 2009 at 08:11:09AM -0700, Arjan van de Ven wrote:
>>> On Mon, 9 Mar 2009 14:16:55 +0000
>>> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>>>
>>>> The kernel doesn't load microcode automatically 
>>> it does if you have the right format; the kernel uses
>>> request_firmware() for this.
>>> The microcode on the intel website is not ready for this yet, but
>>> we're working hard to have future drops to be in the new format.
>> Wow so I was redundant AND wrong in the same email!
>>
>> What motivated the switch to the generic request_firmware interface?
>> Is it just less messy/faster than previous methods? 
> 
> there are various cases where microcode is needed (for example, when
> you hotplug a new cpu); request_firmware() is just the right way to do
> such things, and an initscript is just the wrong way

I don't agree ;-)
I agree that request_firmware method is better than init.d scripts, but
not that it is the right things. microcodes should be loaded at very
beginning of boot process, so by BIOS, by GRUB or on hotpug event by
request_firmware.
BTW: why do we have microcode loading modular?

Offtopic: IMHO if we could move the load of firmware before booting
linux, it would be nicer and cleaner (by open source point of view).

ciao
	cate

