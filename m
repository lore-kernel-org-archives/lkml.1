Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXCRS7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXCRS7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXCRS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:59:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:43341 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXCRS7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:59:40 -0400
Date: Sun, 18 Mar 2007 19:59:14 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Bob Tracy <rct@gherkin.frus.com>
cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <20070318010941.70B46DBA1@gherkin.frus.com>
Message-ID: <Pine.LNX.4.64.0703181955550.12394@twin.jikos.cz>
References: <20070318010941.70B46DBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added Bartlomiej to CC)

On Sat, 17 Mar 2007, Bob Tracy wrote:

> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> PIIX4: IDE controller at PCI slot 0000:00:07.1
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
> (hangs here)
> The next two lines of output for 2.6.21-rc2 and earlier are:
> Probing IDE interface ide0...
> hda: TOSHIBA MK3017GAP, ATA DISK drive

Looks like it's related to some change in drivers/ide. As there have been 
only 13 patches in this area between rc2 and rc3, it should take only 3 or 
4 reboots to figure the offending patch using git-bisect - could you 
please give it a try?

Thanks,

-- 
Jiri Kosina
