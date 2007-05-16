Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXEPRJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXEPRJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbXEPRJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:09:22 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4031 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbXEPRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:09:21 -0400
Date: Wed, 16 May 2007 18:09:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gerd Hoffmann <kraxel@suse.de>,
       Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] early printk and boot console fixups.
In-Reply-To: <200705160959.12433.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64N.0705161803110.29569@blysk.ds.pg.gda.pl>
References: <45D5C473.4010608@suse.de> <86802c440705152117o34325f1dw4a0cdf95241b3b42@mail.gmail.com>
 <200705160959.12433.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Bjorn Helgaas wrote:

> > for early_uart_console, I have some ideas:
> > 1. merged that into early_serial_console in
> > arch/x86_64/kernel/early_printk.c, and
> > move early_printk.c to kernel/, --- make it understand
> >      earlyprintk=uart,io,0x3f8,9600n8
> >      earlyprintk=uart,mmio,0xff5e0000,115200n8
> > in addition to vga, ttyS, serial
> 
> I would rather try to merge 8250_early and early_printk.
> "console=uart,io,0x3f8" is already pretty similar to
> "earlyprintk=serial", and it would be nice to have only one.
> 
> "console=uart" does have the disadvantage that you have to know the
> port address.  But it has the advantage that it doesn't depend on
> compiled-in legacy serial port names.  If you need early console
> output, you're probably a developer and can come up with the address.

 Given the generic name of "uart" I am assuming this will work with any 
UART driver making use of the serial_core.c core -- am I correct?

  Maciej
