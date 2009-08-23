Return-Path: <linux-kernel-owner+w=401wt.eu-S933515AbZHWL4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515AbZHWL4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933506AbZHWL4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:56:41 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41780 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbZHWL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:41 -0400
Date: Sun, 23 Aug 2009 13:56:42 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc6: ACPI handle has no context apparenty from libata
	during suspend to RAM
Message-ID: <20090823115642.GA6697@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908231424.07900.arvidjaar@mail.ru>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Every time I do to sleep I get:
> 
> PM: Entering mem sleep
> Suspending console(s) (use no_console_suspend to debug)
> btusb_bulk_complete: hci0 urb ffff88005485d180 failed to resubmit (1)
> btusb_bulk_complete: hci0 urb ffff880039086c00 failed to resubmit (1)
> btusb_intr_complete: hci0 urb ffff880078556780 failed to resubmit (1)
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> ACPI handle has no context!
> sdhci-pci 0000:03:01.1: PME# disabled
> sdhci-pci 0000:03:01.1: PCI INT B disabled
> ACPI handle has no context!
> ata5: port disabled. ignoring.
> ata_piix 0000:00:1f.1: PCI INT A disabled
> ehci_hcd 0000:00:1d.7: PCI INT A disabled
> ...
> Otherwise there are no negative effects as far as I can tell.

JFTR, I've seen this as well, on a VT8237 libata system I believe.

Andreas Mohr
