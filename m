Return-Path: <linux-kernel-owner+w=401wt.eu-S1946013AbXBVOJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946013AbXBVOJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946011AbXBVOJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:09:50 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51974 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946013AbXBVOJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:09:49 -0500
Message-ID: <45DDA43A.4030509@drzeus.cx>
Date: Thu, 22 Feb 2007 15:10:02 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>	 <1172099859.25076.132.camel@localhost.localdomain>	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr> <1172150712.3531.265.camel@laptopd505.fenrus.org>
In-Reply-To: <1172150712.3531.265.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> some can be used for both (PIT), but on a concept level the uses are
> independent. The advantage of local apic over PIT is that local apic is
> cheap to do "one shot" future events with, while the PIT will tick
> periodic at a fixed frequency. With tickless idle.. that's not what you
> want.
> 

So with a local apic, and acpi_pm as clocksource, I shouldn't be getting timer
interrupts? Yet I do. Which I assume means that the kernel will still get woken
up very often.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
