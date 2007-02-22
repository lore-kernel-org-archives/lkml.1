Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXBVOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXBVOUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbXBVOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:20:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbXBVOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:20:46 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Arjan van de Ven <arjan@infradead.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45DDA43A.4030509@drzeus.cx>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	 <1172150712.3531.265.camel@laptopd505.fenrus.org>
	 <45DDA43A.4030509@drzeus.cx>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 15:20:34 +0100
Message-Id: <1172154034.3531.270.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 15:10 +0100, Pierre Ossman wrote:
> Arjan van de Ven wrote:
> > 
> > some can be used for both (PIT), but on a concept level the uses are
> > independent. The advantage of local apic over PIT is that local apic is
> > cheap to do "one shot" future events with, while the PIT will tick
> > periodic at a fixed frequency. With tickless idle.. that's not what you
> > want.
> > 
> 
> So with a local apic, and acpi_pm as clocksource, I shouldn't be getting timer
> interrupts? 

timer interrupts as in "irq0"?

you shouldn't if you use the hrtimers/tickless stuff...

can you get us a dmesg somewhere? maybe the kernel mentions why ;)

> Yet I do. Which I assume means that the kernel will still get woken
> up very often.

if irq0 keeps increasing at 100Hz or 1000Hz or so.. then yes
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

