Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbXJ2Nsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbXJ2Nsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXJ2NsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:48:07 -0400
Received: from www.tglx.de ([62.245.132.106]:32876 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbXJ2NsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:48:06 -0400
Date: Mon, 29 Oct 2007 14:47:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
In-Reply-To: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
Message-ID: <alpine.LFD.0.9999.0710291440570.3186@localhost.localdomain>
References: <200710290628.l9T6SDpo012530@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Mikael Pettersson wrote:

> On Sun, 28 Oct 2007 21:33:02 -0700, H. Peter Anvin wrote:
> > Mikael Pettersson wrote:
> > > My old 486 fails to boot with the 2.6.24-rc1 kernel.
> > > Grub loads it, 4 lines of text appear but not the kernel's
> > > "Linux version <blah> greet", and the machine reboots.
> > > Double-checked with a serial console: nothing appears
> > > before it reboots.
> > 
> > What four lines of text?
> 
> They're impossible to capture because they're only visible
> on the VGA screen for like 0.2 seconds before the machine
> reboots and the screen is blanked; they don't show up on
> the serial console.
> 
> They look like paths to the vmlinuz and initrd surrounded
> by [ ] brackets, so I guess they come from grub.

Any chance to use serial console ?

Enable CONFIG_EARLY_PRINTK and add
 
earlyprintk=serial,ttyS0,115200,keep

to the kernel command line.

Can you please provide your .config file ?

I tested on my i386 box and Linus latest git boots fine:
# uname -a
Linux museum386 2.6.24-rc1-2a397e82 #1 PREEMPT Mon Oct 29 13:39:29 CET 2007 i386 unknown
# cat /proc/cpuinfo
processor       : 0
vendor_id       : unknown
cpu family      : 3
model           : 0
model name      : 386
stepping        : unknown
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : no
fpu_exception   : no
cpuid level     : -1
wp              : no
flags           :
bogomips        : 6.93
clflush size    : 32

Thanks,

	tglx
