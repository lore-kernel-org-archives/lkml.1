Return-Path: <linux-kernel-owner+w=401wt.eu-S964964AbXBTO6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbXBTO6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXBTO6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:58:11 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:42597 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964964AbXBTO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:58:11 -0500
Message-ID: <45DB0BCD.6020507@aitel.hist.no>
Date: Tue, 20 Feb 2007 15:55:09 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: Scott Preece <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>	 <20070215061149.GE15654@redhat.com>	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>	 <20070215165339.GB5285@thunk.org>	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>	 <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com> <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
In-Reply-To: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
>
> Assuming these need not be GPL, I have a problem with
> EXPORT_SYMBOL_GPL and the general trend in the direction of making
> proprietary drivers harder on companies. Our drivers use basic
> interfaces in the kernel like open, read, write, ioctl, semaphores,
> interrupts, timers etc. This is functionality we would expect from any
> operating system. We used devfs before and had no problems there. Greg
> KH has gone and made the basic sysfs interface, which any generic
> driver could use as EXPORT_SYMBOL_GPL. I don't really care, I just
> don't use sysfs. The point is that old functionality is being ripped
> off and new ones introduced, and their interfaces are not open
> anymore. Hence there will be a point where non-GPLed drivers simply
> cannot be loaded.
>
> So why beat about the bush? Just make it illegal to load proprietary
> drivers, or remove EXPORT_SYMBOL_GPL.
Those wo introduce EXPORT_SYMBOL_GPL are not in a position where
they can make it illegal to load proprietary modules. They may want to,
but they can't.  The kernel has very many copyright holders, each
decides for his own part only.

Someone who didn't write the module interface or posix interface can't
stop you there.  Anti-proprietary folks then go and make new
useful subsystems, and make sure those are accessed with
EXPORT_SYMBOL_GPL only.  Then they phase out the old
interfaces as the new ones are clearly better, and the vast majority
with GPL drivers have no problem with this.
As long as there are developers with this attitude, expect
EXPORT_SYMBOL_GPL to crop up in new places over time.

Yes - this makes it harder (although not impossible) to distribute
closed-source drivers.  Which is exactly what these people want.
When they are powerless to forbid such drivers, they settle for making
them harder and harder to use instead.  They want this trend
to continue.

There is an obvious way around it - you (and other people
with an interest in closed-source drivers) can write & contribute your
own "sysfs" and whatever else you might need.  Make it better
than the existing sysfs so it actually gets into the kernel,
replacing the existing stuff. And of
course there will be no EXPORT_SYMBOL_GPL in it - since
that is what you want to avoid. 

The price for this then, is to outcompete the proponents of
GPL-only symbols.  If you offer more and better source (under the GPL)
then you can turn the trend and keep linux the way you want it.
If you don't - those that do contribute will get to shape linux
the way they like. Whoever makes linux gets to decide.

Another way is to stay with linux 2.4.  You won't get any
new stuff that way, but no new GPL surprises either.

Helge Hafting

