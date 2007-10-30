Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbXJ3OHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbXJ3OHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXJ3OHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:07:44 -0400
Received: from aun.it.uu.se ([130.238.12.36]:60574 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXJ3OHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:07:43 -0400
Date: Tue, 30 Oct 2007 15:07:20 +0100 (MET)
Message-Id: <200710301407.l9UE7Kwn028913@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: mikpe@it.uu.se, tglx@linutronix.de
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 14:47:49 +0100 (CET), Thomas Gleixner wrote:
> On Mon, 29 Oct 2007, Mikael Pettersson wrote:
> 
> > On Sun, 28 Oct 2007 21:33:02 -0700, H. Peter Anvin wrote:
> > > Mikael Pettersson wrote:
> > > > My old 486 fails to boot with the 2.6.24-rc1 kernel.
> > > > Grub loads it, 4 lines of text appear but not the kernel's
> > > > "Linux version <blah> greet", and the machine reboots.
> > > > Double-checked with a serial console: nothing appears
> > > > before it reboots.
> > > 
> > > What four lines of text?
> > 
> > They're impossible to capture because they're only visible
> > on the VGA screen for like 0.2 seconds before the machine
> > reboots and the screen is blanked; they don't show up on
> > the serial console.
> > 
> > They look like paths to the vmlinuz and initrd surrounded
> > by [ ] brackets, so I guess they come from grub.
> 
> Any chance to use serial console ?
> 
> Enable CONFIG_EARLY_PRINTK and add
>  
> earlyprintk=serial,ttyS0,115200,keep
> 
> to the kernel command line.

As I mentioned in my first message, I did hook up
a serial console except I used the console=ttyS0,115200
boot parameter, but the kernel rebooted before any
output appeared. I can try the earlyprintk= version
above next time I'm near the 486 if you think it will
make any difference.

> Can you please provide your .config file ?

I posted a link to it in my first message:

>Config is at http://user.it.uu.se/~mikpe/linux/tmp/486-config-2.6.24-rc1.
>The kernel is unpatched 2.6.24-rc1 compiled with gcc-4.2.2.

/Mikael
