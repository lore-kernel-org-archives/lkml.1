Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbXGZQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbXGZQZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761056AbXGZQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:25:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35893 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757955AbXGZQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:25:07 -0400
Date: Thu, 26 Jul 2007 17:31:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070726173121.70088a92@the-village.bc.nu>
In-Reply-To: <46A8C6F1.4080309@howardsilvan.com>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	<46A84B4A.6070902@shaw.ca>
	<46A8C6F1.4080309@howardsilvan.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
> ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> 
> It's a Shuttle HOT-661 motherboard (VIA Apollo Pro Plus mainboard 
> chipset).  Both FreeBSD and Linux identify the serial chipset type as 
> 16550A.

So you've got 16bytes of buffering. That ought to be enough on a modern
PC. The older kernels use quite limited internal buffers which may be a
factor, the current ones have a rewritten tty buffering layer which may
improve matters enormously.

Alan
