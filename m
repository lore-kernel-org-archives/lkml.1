Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXFQLJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXFQLJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbXFQLIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:08:51 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42760
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbXFQLIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:08:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: high ping times with wireless-dev
Date: Sun, 17 Jun 2007 13:08:38 +0200
User-Agent: KMail/1.9.6
Cc: netdev <netdev@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Gary Zambrano <zambrano@broadcom.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
References: <200706162327.47413.maxi@daemonizer.de> <200706171255.40155.mb@bu3sch.de>
In-Reply-To: <200706171255.40155.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171308.39169.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007 12:55:39 Michael Buesch wrote:
> On Saturday 16 June 2007 23:27:43 Maximilian Engelhardt wrote:
> > [...]
> > ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> > ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> 
> > IRQ 10
> > ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
> > b44.c:v2.0
> > eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:29:99:a7
> > [...]
> 
> Ok, I prepared two debugging patches.
> 
> Please enable SonicsSiliconBackplane Debugging in the kernel kconfig,
> so I can get more detail information about your card.
> Device Drivers/Sonics Silicon Backplane/SSB debugging
> (Must disable "No SSB kernel messages")
> 
> Please apply and test the attached debugging patches in a row.
> So apply patch 1 and test if it works again. If not, apply
> patch 2 and test if it works.
> Always save complete dmesg log on each test run and send it to me.
> 
> Thanks for testing.
> (This time it seems we are actually getting somewhere, when
> dealing with sane people. :D )
> 

Ah, forgot to say. Apply patch 2 on top of patch 1.

-- 
Greetings Michael.
