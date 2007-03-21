Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXCUVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXCUVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXCUVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:35:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49368 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbXCUVft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:35:49 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: john stultz <johnstul@us.ibm.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, jikos@jikos.cz
In-Reply-To: <200703212118.51395.bzolnier@gmail.com>
References: <20070321195450.36D5EDBA1@gherkin.frus.com>
	 <200703212118.51395.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 14:34:27 -0700
Message-Id: <1174512867.5477.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 21:18 +0100, Bartlomiej Zolnierkiewicz wrote:
> Thanks for narrowing it down, I'm adding John to cc:.
> 
> On Wednesday 21 March 2007, Bob Tracy wrote:
> > I originally wrote:
> > > Platform is a Dell CPxJ 650GT notebook.  Attempts to boot 2.6.21-rc3
> > > and -rc4 produce the following console output:
> > > 
> > > (apparently normal boot)
> > > ...
> > > Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> > > ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> > > PIIX4: IDE controller at PCI slot 0000:00:07.1
> > > PIIX4: chipset revision 1
> > > PIIX4: not 100% native mode: will probe irqs later
> > >     ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio
> > >     ide1: BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
> > > (hangs here)
> > > 
> > > The next two lines of output for 2.6.21-rc2 and earlier are:
> > > Probing IDE interface ide0...
> > > hda: TOSHIBA MK3017GAP, ATA DISK drive


Hmmm. Are you able to capture a full dmesg? If so could you send it to
me? Also, does booting w/ "clocksource=jiffies" change the behavior?

thanks
-john


