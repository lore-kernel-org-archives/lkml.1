Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXHMW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXHMW3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbXHMW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:28:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:43567 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760532AbXHMW2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:28:04 -0400
X-Authenticated: #441233
X-Provags-ID: V01U2FsdGVkX1/UsYwjRPDUtfA9+pG5AqsrSGpi5LA7nbAzeQhTMX
	n1BcrjRG0ZGlU1
Date: Tue, 14 Aug 2007 00:28:00 +0200
From: Michael Mauch <michael.mauch@gmx.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: Serial ports rearranged in 2.6.22?
Message-ID: <20070813222800.GB25159@elmicha>
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	Yinghai Lu <yhlu.kernel@gmail.com>
References: <20070810213925.GB10855@elmicha> <86802c440708102154r59e1acbj90fa0d5b73197fb9@mail.gmail.com> <20070811154925.GA9618@elmicha> <200708131534.15235.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708131534.15235.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:

> On Saturday 11 August 2007 09:49:25 am Michael Mauch wrote:
> > Yinghai Lu wrote:
> > 
> > > On 8/10/07, Michael Mauch <michael.mauch@gmx.de> wrote:
> > > >
> > > > With 2.6.22 I get the names <-> ports/irqs the other way around:
> > > >
> > > > 00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
> > > > 00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
> > > > ...
> > > http://lkml.org/lkml/2007/7/25/455
> > 
> > Thanks - I applied that patch and the names are back to normal again:
> > 
> > 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> 
> Just FYI, the patch Yinghai mentioned above was experimental, and
> we decided it was the wrong solution.
> 
> For 2.6.22, the easiest workaround is to boot with the 
> "legacy_serial.force" option.

Ah, ok, and load the legacy_serial module. Going from built-in serial to
modules I was already challenged to find serial_core, 8250, 8250_pnp
and/or 8250_pci (the help in "make menuconfig" does not seem to show the
help that is written in the Kconfig file for 8250_pnp and 8250_pci).

> For 2.6.23, we reverted my patch that caused the names to be swapped:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=57d4810ea0d9ca58a7bcc1336607f0cede0a2abf

Thanks for the information - I wondered how you decided. 

What about 2.6.22.x? Or should the distro kernels use that revert patch
for their stable 2.6.22 kernels?

Regards...
		Michael

