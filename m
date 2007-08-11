Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbXHKPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbXHKPtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXHKPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:49:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:40676 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755410AbXHKPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:49:31 -0400
X-Authenticated: #441233
X-Provags-ID: V01U2FsdGVkX18jAL1JB4ojzKMFpnT6tDx2mr64dv0/uQ0qmQDzw6
	OUpuhztkiRRVme
Date: Sat, 11 Aug 2007 17:49:25 +0200
From: Michael Mauch <michael.mauch@gmx.de>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Serial ports rearranged in 2.6.22?
Message-ID: <20070811154925.GA9618@elmicha>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <20070810213925.GB10855@elmicha> <86802c440708102154r59e1acbj90fa0d5b73197fb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708102154r59e1acbj90fa0d5b73197fb9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:

> On 8/10/07, Michael Mauch <michael.mauch@gmx.de> wrote:
> > Hi,
> >
> > until 2.6.21, I had the normal assignments for ttyS0 and ttyS1:
> >
> > 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> > 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >
> > With 2.6.22 I get the names <-> ports/irqs the other way around:
> >
> > 00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
> > 00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
> >
> > Is this supposed to be that way? Should we reassign these names with
> > udev? udev-114 doesn't seem to have built-in rules to assign the
> > traditional names.
> >
> > Or could it be related to some brokeness in my BIOS (ACPI/PNP)?
> >
> > I'm using the 8250_pnp module (and it's the same with builtin serial
> > modules). I made sure that I did not accidentally change the BIOS
> > settings for the serial ports.
> >
> > I'm using Gentoo, but on the lirc list was a Fedora user with the same
> > symptoms.
> 
> http://lkml.org/lkml/2007/7/25/455

Thanks - I applied that patch and the names are back to normal again:

00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

Regards...
		Michael
