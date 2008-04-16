Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYDPFyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYDPFyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYDPFyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:54:13 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56453 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbYDPFyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:54:12 -0400
Date: Wed, 16 Apr 2008 01:53:48 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] avr32: add include/asm-avr32/serial.h
Message-ID: <20080416015348.5170cc64@siona.local>
In-Reply-To: <20080414225617.5d41a13b@core>
References: <20080414141721.GI6695@cs181133002.pp.htv.fi>
	<20080414153625.6150e999@core>
	<20080414184220.GC6695@cs181133002.pp.htv.fi>
	<20080414225617.5d41a13b@core>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:56:17 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +/*
> > + * This assumes you have a 1.8432 MHz clock for your UART.
> > + *
> > + * It'd be nice if someone built a serial card with a 24.576 MHz
> > + * clock, since the 16550A is capable of handling a top speed of 1.5
> > + * megabits/second; but this requires the faster clock.
> > + */
> > +#define BASE_BAUD (1843200 / 16)
> > +
> > +#endif /* _ASM_SERIAL_H */  
> 
> Acked-by: Alan Cox <alan@redhat.com>

Not sure if that assumption is correct since I haven't heard of anyone
creating an avr32 board with a 16550A UART on it...

But I'm not going to be difficult about it. Applied this one and four
of the others:

Applying add include/asm-avr32/xor.h
Applying avr32: don't offer CONFIG_RTC
Applying avr32: don't offer CONFIG_GEN_RTC
Applying avr32: don't offer PARPORT_PC
Applying avr32: add include/asm-avr32/serial.h

I skipped the IDE one since Bart took it.

Thanks a lot!

Haavard
