Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbXBVOvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbXBVOvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbXBVOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:51:06 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43938 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbXBVOvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:51:05 -0500
Message-ID: <45DDADEB.3030309@drzeus.cx>
Date: Thu, 22 Feb 2007 15:51:23 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>	 <1172099859.25076.132.camel@localhost.localdomain>	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>	 <1172150712.3531.265.camel@laptopd505.fenrus.org>	 <45DDA43A.4030509@drzeus.cx> <1172154034.3531.270.camel@laptopd505.fenrus.org>
In-Reply-To: <1172154034.3531.270.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 2007-02-22 at 15:10 +0100, Pierre Ossman wrote:
>   
>>
>> So with a local apic, and acpi_pm as clocksource, I shouldn't be getting timer
>> interrupts? 
>>     
>
> timer interrupts as in "irq0"?
>
>   

Yes:

  0:    9786349    XT-PIC-XT        timer

> you shouldn't if you use the hrtimers/tickless stuff...
>   

CONFIG_HIGH_RES_TIMERS=y
CONFIG_NO_HZ=y

> can you get us a dmesg somewhere? maybe the kernel mentions why ;)
>
>   

Sure. My dmesg is full of mmc debug crud right now, but I'll just reboot
and I'll have a clean one for you.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

