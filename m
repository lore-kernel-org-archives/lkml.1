Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbYDNWBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbYDNWBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYDNWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:00:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35163 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171AbYDNWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:00:51 -0400
Date: Mon, 14 Apr 2008 22:56:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: hskinnemoen@atmel.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] avr32: add include/asm-avr32/serial.h
Message-ID: <20080414225617.5d41a13b@core>
In-Reply-To: <20080414184220.GC6695@cs181133002.pp.htv.fi>
References: <20080414141721.GI6695@cs181133002.pp.htv.fi>
	<20080414153625.6150e999@core>
	<20080414184220.GC6695@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 7beddb9fe7aee73227a9796a039cee9583cecc0a diff --git a/include/asm-avr32/serial.h b/include/asm-avr32/serial.h
> new file mode 100644
> index 0000000..5ecaebc
> --- /dev/null
> +++ b/include/asm-avr32/serial.h
> @@ -0,0 +1,13 @@
> +#ifndef _ASM_SERIAL_H
> +#define _ASM_SERIAL_H
> +
> +/*
> + * This assumes you have a 1.8432 MHz clock for your UART.
> + *
> + * It'd be nice if someone built a serial card with a 24.576 MHz
> + * clock, since the 16550A is capable of handling a top speed of 1.5
> + * megabits/second; but this requires the faster clock.
> + */
> +#define BASE_BAUD (1843200 / 16)
> +
> +#endif /* _ASM_SERIAL_H */

Acked-by: Alan Cox <alan@redhat.com>
