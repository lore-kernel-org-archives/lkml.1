Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXKKQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXKKQrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXKKQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:47:11 -0500
Received: from [81.2.110.250] ([81.2.110.250]:60550 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752108AbXKKQrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:47:10 -0500
Date: Sun, 11 Nov 2007 16:46:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Keith Chew" <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI card initialisation at boot
Message-ID: <20071111164644.7b2c743c@the-village.bc.nu>
In-Reply-To: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com>
References: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I am guessing that the ESCD has been corrupted, and putting a spare
> device caused the BIOS to reset the ESCD. In the BIOS, it has been
> setup as "Resource allocation by Auto(ESCD)".

Quite possibily. It may also be that the card had simply developed a bad
connection. 

> There is another option in the BIOS to set "Resource allocation by
> Manual". I have tried this setting and Linux has no problems booting
> up and using the PCI card.
> 
> My question is: Will setting the BIOS to "Resource allocation by
> Manual" prevent the crash from happening in the future? More
> specifically, does Linux still depend on ESCD even if the resource
> allocation is set to Manual?

Linux by default uses the BIOS resource assignments. It doesn't know
where those came from other than "the BIOS". Also as most vendors
checksum the ESCD I'd be suprised if an ESCD error caused the problem,
but I guess you can get unlucky.

Cards can simply lose connection especially if in a dirty, damp or
particularly in a vibration high environment. In the shipping industry,
for example, it is not uncommon to dismantle all the cards from a PC and
refit them then tighten all the screws as a routine maintenance activity.

Alan
