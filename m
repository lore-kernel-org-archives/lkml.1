Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbXEQKOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbXEQKOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbXEQKO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:14:26 -0400
Received: from [81.2.110.250] ([81.2.110.250]:40634 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754956AbXEQKOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:14:25 -0400
Date: Thu, 17 May 2007 11:19:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-storage nice value
Message-ID: <20070517111901.202309d9@the-village.bc.nu>
In-Reply-To: <20070517100308.GA14667@DervishD>
References: <20070517100308.GA14667@DervishD>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     My system is a bit modest: a 7 years old motheboard with VIA686B, a
> 1900+ Athlon XP, but with plenty of RAM (1280MB + 1GB swap). I know, if
> I want more hard disk performance I should buy a new box with SATA or
> whatever, but the fact is that I hadn't problems with the same hardware
> and kernel 2.4.x. I need 2.6.x, so I cannot go back to 2.4.x.

Disk is actually less likely to be a problem than PCI bus bandwidth - the
older VIA boards seem quite happy to fill the PCI bus solid during bursts
of disk I/O

> bad idea too, where should I look for culprits so I can tweak the system
> a bit and improve disk performance? I'm not 100% sure that the problem

You might want to try the reverse if you have a UDMA100 or UDMA133 drive
then setting the speed down to UDMA66 definitely evens out the behaviour
of VIA boards when doing video capture. I don't know if it helps playback.

Alan
