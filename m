Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbXGWIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbXGWIIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXGWIIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:08:40 -0400
Received: from wrzx28.rz.uni-wuerzburg.de ([132.187.3.28]:50923 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754353AbXGWIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:08:38 -0400
From: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Date: Mon, 23 Jul 2007 10:07:49 +0200
User-Agent: KMail/1.9.5
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de>
In-Reply-To: <46A3E973.6090701@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231007.50565.andreas.messer@stud-mail.uni-wuerzburg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23. Juli 2007 01:34 Stefan Richter wrote:
> (quoting in full for linux1394-devel, Cc added)
>
> Andreas Messer wrote at LKML:
> > Hello,
> >
> > I tried the new firewire stack with a external harddisc and a external
> > dvd writer and get massive i/o problems. Here is the kernel output for
> > the harddisc. Please cc me for further questions. I hope its not too much
> > output for lkml email.

< bugreport snipped>
>
> Are you sure the FireWire controller is from VIA?  Check with lscpi.
> The NVidia nForce2 chipset has an own FireWire controller, and that one
> is only "supported" by a gross hack in ohci1394 and at the moment
> unsupported in firewire-ohci.  There is even a bug report in Red Hat's
> bugzilla where fw-ohci hung up when trying to initialize an nForce2 chip.

The first System, where harddisc don't work at all with the new stack: 
Nvidia NForce2 Ultra Chipset; 1GB RAM; XP-M 2600; FW-Controller is
PCI addon card; lspci says Via
Vanilla Kernel 2.6.22, apic, Preempt, Dynamic Tics. hmm something else 
interesting?

> > On another PC same problem, but replugging one or two times get the thing
> > working.
>
> Which controller does this other PC have?

Second System, here replugging helped, testet with harddisc and external
dvd-rw drive:
Nvidia Nforce2 (no Ultra!) Chipset; 1GB Ram XP-M 2500@2600; Same FW Controller
Kernel almost the same (maybe different device drivers)
