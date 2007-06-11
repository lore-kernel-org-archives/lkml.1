Return-Path: <linux-kernel-owner+w=401wt.eu-S1763372AbXFKHo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372AbXFKHo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXFKHot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:44:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:56459 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbXFKHos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:44:48 -0400
Message-ID: <466CFD6D.2080201@qumranet.com>
Date: Mon, 11 Jun 2007 10:44:45 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan>	 <4663DCE9.3000107@qumranet.com>	 <20070604202248.GA18668@dreamland.darkstar.lan>	 <46647B3E.2090205@qumranet.com>	 <20070604212207.GA22365@dreamland.darkstar.lan>	 <46651069.5040003@qumranet.com>	 <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>	 <466BED18.5040708@qumranet.com> <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>
In-Reply-To: <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca wrote:
>>
>> I've managed to reproduce this on kvm-21 (it takes many boots for this
>> to happen, but it does eventually).
>
> Hum, any clue on the cause? 

 From what I've seen, it's the new Linux clocksource code.

> Should I test older versions?

They're unlikely to be better.  Instead, it would be best to see what 
the guest is doing.

I suggest downloading the source rpm for the kernel, building it, and 
sprinkling printk()s until we know exactly what source the guest is 
executing at the time of the hang.

Use of the qemu -kernel, -append, and -serial can redirect the console 
to the command line so that it's easy to capture all debug output.

-- 
error compiling committee.c: too many arguments to function

