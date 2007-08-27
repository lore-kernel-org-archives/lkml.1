Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXH0Rax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXH0Rax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbXH0Ral
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:30:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:43672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758758AbXH0Raj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:30:39 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18KLRo2S3QKtQWAtAIXy8wO3MumGIBSHdUvc0T3f9
	/dthHCpNJz0T/m
Date: Mon, 27 Aug 2007 19:30:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH, RFC] wake up from a serial port
In-Reply-To: <20070827100029.GB1972@elf.ucw.cz>
Message-ID: <Pine.LNX.4.60.0708271924180.5705@poirot.grange>
References: <Pine.LNX.4.60.0708260010250.3809@poirot.grange>
 <20070827100029.GB1972@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Pavel Machek wrote:

> Hi!
> 
> > Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> > e.g.,
> > 
> > echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup
> > 
> > Requires
> > 
> > # CONFIG_SYSFS_DEPRECATED is not set
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Hmm, interesting, looks ok to me. What are you using it for?

Linkstation / kurobox systems from Buffalo Tech. have an AVR controller 
connected to host's UART. The AVR controls power, buttons, fan, LEDs, 
sensors... So, practically the only way to wake the system up is to press 
a button, which sends a byte from the AVR to the CPU.

Thanks
Guennadi
---
Guennadi Liakhovetski
