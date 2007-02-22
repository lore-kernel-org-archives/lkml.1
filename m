Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXBVQ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXBVQ1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXBVQ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:27:37 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44316 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXBVQ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:27:36 -0500
Message-ID: <45DDC488.1080008@drzeus.cx>
Date: Thu, 22 Feb 2007 17:27:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Arjan van de Ven <arjan@infradead.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>	 <1172099859.25076.132.camel@localhost.localdomain>	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>	 <1172150712.3531.265.camel@laptopd505.fenrus.org>	 <45DDA43A.4030509@drzeus.cx>	 <1172154034.3531.270.camel@laptopd505.fenrus.org>	 <45DDADEB.3030309@drzeus.cx>  <45DDB31C.8070306@drzeus.cx> <1172160024.25076.188.camel@localhost.localdomain>
In-Reply-To: <1172160024.25076.188.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>
> Here is the reason. The local APIC stops working in C3 state and we fall
> back to the PIT in that case. Not really exciting for dynticks, but the
> only way to keep the system alive. There is a patch coming up from
> Intel, which finds out how to use HPET even if it is not enabled by the
> BIOS. This will still end up on IRQ#0, but will give way longer idle
> sleeps than the PIT.
>
>   

So then the next two questions are; is it possible to disable C3 and is
it a net power gain to get rid of the wakeups in favor of having C3.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

