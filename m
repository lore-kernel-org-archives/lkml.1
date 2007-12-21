Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXLUNZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXLUNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbXLUNZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:25:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52393 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875AbXLUNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:25:50 -0500
Date: Fri, 21 Dec 2007 13:18:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schmitt <mschmitt@unixkiste.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: drive appears confused; hda lost interrupt; IRQ169: nobody
 cared
Message-ID: <20071221131812.7d362e7e@the-village.bc.nu>
In-Reply-To: <1198237821.4577.63.camel@elara.tcw.local>
References: <1198237821.4577.63.camel@elara.tcw.local>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I changed the mainboard of this computer recently to this P4P800-SE from
> a rubish oem SIS chipset board and I had the problems right away,
> starting with kernel 2.6.18 but problems persist even with 2.6.23
> (Debian kernels).

Your IRQ routing appears broken. That is usually a BIOS problem.

> So, my main concern is that there may be some sort of data corruption
> even if I don't see them right now but as the messages seem to be very
> serious... dunno. Any thoughts?

Check for BIOS uupdates also try playing with the various pci irq
routing, APIC and acpi options. 

Alan
