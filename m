Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXKTWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXKTWHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXKTWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:07:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46816 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755916AbXKTWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:07:12 -0500
Date: Tue, 20 Nov 2007 22:05:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: noah <noah123@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
Message-ID: <20071120220512.46b9e975@the-village.bc.nu>
In-Reply-To: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  kernel: [734344.717844] irq 21: nobody cared (try booting with the
> "irqpoll" option)
>  kernel: [734344.717866]

Your machine decided to emit interrupt 21 without an apparent reason.
Whatever caused that made the kernel shut down IRQ 21 at which point the
disk drives on that IRQ were no longer being serviced. Everything on IRQ
21 would have died - which may be why your networking failed too.

What do you have on IRQ 21 and is this a one off ?
