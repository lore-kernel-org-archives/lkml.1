Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbXEQKdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbXEQKdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEQKcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:32:55 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:64481 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbXEQKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:32:54 -0400
Date: Thu, 17 May 2007 12:34:36 +0200
From: DervishD <lkml@dervishd.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-storage nice value
Message-ID: <20070517103436.GA15329@DervishD>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070517100308.GA14667@DervishD> <20070517111901.202309d9@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070517111901.202309d9@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Alan :)

 * Alan Cox <alan@lxorguk.ukuu.org.uk> dixit:
> >     My system is a bit modest: a 7 years old motheboard with VIA686B, a
> > 1900+ Athlon XP, but with plenty of RAM (1280MB + 1GB swap). I know, if
> > I want more hard disk performance I should buy a new box with SATA or
> > whatever, but the fact is that I hadn't problems with the same hardware
> > and kernel 2.4.x. I need 2.6.x, so I cannot go back to 2.4.x.
> 
> Disk is actually less likely to be a problem than PCI bus bandwidth - the
> older VIA boards seem quite happy to fill the PCI bus solid during bursts
> of disk I/O

    I was supposing something in that line, since disk speed is quite
high (when I only read or write but not both). I just didn't think about
PCI bandwidth.

> > bad idea too, where should I look for culprits so I can tweak the system
> > a bit and improve disk performance? I'm not 100% sure that the problem
> 
> You might want to try the reverse if you have a UDMA100 or UDMA133 drive
> then setting the speed down to UDMA66 definitely evens out the behaviour
> of VIA boards when doing video capture. I don't know if it helps playback.

    Won't that reduce disk performance when using just one disk? I don't
pass much data between disks (or even copy data within one disk), so not
being able to watch movies while copying data is, for me, more
acceptable than having a slower disk all the time.

    And yes, all my disks are UDMA100.

    Is there a way of changing chipset behaviour from userspace so PCI
bus is not filled during IO bursts?

    Thanks a lot for your answer, Alan :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
