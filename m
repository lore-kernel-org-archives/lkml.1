Return-Path: <linux-kernel-owner+w=401wt.eu-S935129AbXEVWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbXEVWCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbXEVWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:02:09 -0400
Received: from mail.tmr.com ([64.65.253.246]:43924 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712AbXEVWCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:02:07 -0400
Message-ID: <465368D6.1010906@tmr.com>
Date: Tue, 22 May 2007 18:04:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tomas Carnecky <tom@dbservice.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com>
In-Reply-To: <464C5FAC.8060609@dbservice.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Carnecky wrote:
> Despite it's a Microsoft product, it's actually very nice and useful. A
> little pad with a few buttons and connectors for a headset. It's an USB
> device, but it doesn't represent itself as an input/HID device:
>    HID device not claimed by input or hiddev
> 
> I plugged it into a windows box and the USB protocol it uses looks very
> simple (see attachment): everytime I press one of the eight buttons, it
> sends one byte, a bitmap of the pressed buttons.
> 
> What would be the best way to have this device appear in the system?
> Having a separate driver/device node? Or is it possible to have a small
> driver that would translate the gamevoice commands into evdev messages
> and have a new /dev/input/eventX device appear?
> 
> I could write something like that myself, my C skills are good enough
> for that, I'd just need some advice how to use the kernel USB/evdev
> interfaces.
> 
 From your description it sounds as though it would be useful in 
applications where voice connect was useful and visual wasn't, such as 
blind users and embedded applications where a USB pluggable interface 
might be useful in unusual situations.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
