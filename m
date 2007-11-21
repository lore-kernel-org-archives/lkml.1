Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbXKUAsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbXKUAsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbXKUArr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:47:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58234 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755233AbXKUArq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:47:46 -0500
Date: Wed, 21 Nov 2007 00:45:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: noah <noah123@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
Message-ID: <20071121004545.512ad3ea@the-village.bc.nu>
In-Reply-To: <d00698fb0711201416n30b54d26kd8d5887896d3da83@mail.gmail.com>
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
	<20071120220512.46b9e975@the-village.bc.nu>
	<d00698fb0711201416n30b54d26kd8d5887896d3da83@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've had other freezes before but this was the first time I was able
> to see what was actually going on.
> IRQ 21 appears to be shared between sata_nv and ethernet.
> 
> Does this mean my hardware/BIOS is broken somehow?

Not neccessarily. It could a bug in one of the drivers using IRQ 21
(sata_nv or the nvidia ethernet), it could be another inactive device, or
it could be a hardware funny.

Nvidia stuff can be quite hard to diagnose as we have no documentation
but we can try. The first question is whether it is network or disk
triggered - seeing if heavy loads to one or the other trigger the problem
might be a first plan.


Alan
