Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZAEQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZAEQVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZAEQVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:21:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36779 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbZAEQVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:21:36 -0500
Date: Mon, 5 Jan 2009 16:21:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090105162125.093b4adf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090104110559.306186c4@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
	<20090104110559.306186c4@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right now I don't think I have time for it (this is going to take time..
> there's so many weird things with serial ports that it's bound to break
> stuff in the beginning etc)

I can't duplicate this. Can you check you don't have

config SERIAL_8250_DETECT_IRQ
        bool "Autodetect IRQ on standard ports (unsafe)"
        depends on SERIAL_8250_EXTENDED
        help
          Say Y here if you want the kernel to try to guess which IRQ
          to use for your serial port.

          This is considered unsafe; it is far better to configure the
IRQ in a boot script using the setserial command.

          If unsure, say N.


enabled

