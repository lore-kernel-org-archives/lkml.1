Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXC1Uvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXC1Uvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965791AbXC1Uvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:51:40 -0400
Received: from heisenberg.zen.co.uk ([212.23.3.141]:59463 "EHLO
	heisenberg.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965780AbXC1Uvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:51:39 -0400
Message-ID: <460AD556.9090408@gmail.com>
Date: Wed, 28 Mar 2007 21:51:34 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Peter Osterlund <petero2@telia.com>
Subject: Re: Fix sudden warps in mousedev
References: <20070324001610.724a820a.zaitcev@redhat.com>	 <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>	 <20070326144206.93805eeb.zaitcev@redhat.com>	 <200703262114.45287.dtor@insightbb.com> <460934D7.9030700@redhat.com>	 <d120d5000703270846y87e4283m4009ff0a9f65dac4@mail.gmail.com>	 <4609409F.2070203@redhat.com> <d120d5000703270919y16ae3e56kb7d2fbd293213939@mail.gmail.com>
In-Reply-To: <d120d5000703270919y16ae3e56kb7d2fbd293213939@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Heisenberg-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 3/27/07, Chuck Ebbert <cebbert@redhat.com> wrote:
>> Dmitry Torokhov wrote:
>> >>
>> >> And why did the mouse numbers all get rearranged in 2.6.20, e.g.
>> >> mouse1 became mouse2 for many people?
>> >
>> > Input devices are not guaranteed to be stable.
>> >
>>
>> So people with z-axis mice need to redo their X config for each
>> kernel release when the device numbers change? Or should they
>> be using some other configuration?
>>
>> People using this now have X crashes on kernel upgrade because
>> event1 became event2:
>>
>>        Driver      "evdev"
>>        Option      "Device" "/dev/input/event1"
>>
>
> I'd recommend matching on "phys" or individual capabilities bits
> instead of device node. See "man evdev".
>
I wrote a few udev rules to create specific /dev nodes for X with evedv 
(I run with multiple X users / screens / keyboards / mice on one 
machine).  I can forward you the udev rules and helper scripts if you 
want.  This means that you can hardcode the /dev nodes in your xorg.conf 
file and udev will make sure they don't move on you.  I wrote this up in 
the early days of evdev development before the phys stuff was there.

Matt
