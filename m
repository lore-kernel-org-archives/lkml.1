Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbXGDLro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbXGDLro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbXGDLrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:47:37 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:34594 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbXGDLrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:47:36 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 07:47:36 EDT
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Libata PATA status
Date: Wed, 4 Jul 2007 13:31:47 +0200
User-Agent: KMail/1.9.5
References: <20070703185116.59c8f5f5@the-village.bc.nu> <1D2B5126-1238-48F8-B841-E8F77C9A0F1B@mac.com> <20070704102129.44945ea8@the-village.bc.nu>
In-Reply-To: <20070704102129.44945ea8@the-village.bc.nu>
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041332.00769.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

Am Wednesday 04 July 2007 11:21 schrieben Sie:
> > I'd love to try to poke holes in the libata PATA support, but sadly
> > it doesn't look like any of my systems built-in ATA chipsets are
> > supported yet.  Has anyone started a rewrite of the PPC/PowerMac IDE
> > driver?  The current one is in "drivers/ide/ppc/pmac.c", and supports
> > these chipsets:

I'm using pata-cmd64x for a few month now on my G3 powermac. So far no 
problems except it only runs in UDMA/25 mode instead of UDMA/33 as the ide 
driver does. And of course - no cdrom or zip because they are connected to 
the Heathrow controller...

scsi0 : pata_cmd64x
scsi1 : pata_cmd64x
ata1: PATA max UDMA/25 cmd 0xfd63d090 ctl 0xfd63d082 bmdma 0xfd63d050 irq 0
ata2: PATA max UDMA/25 cmd 0xfd63d070 ctl 0xfd63d062 bmdma 0xfd63d058 irq 0
ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
ata1.00: ATA-7: SAMSUNG SP1654N, BV100-50, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48
pata_cmd64x: active 3 recovery 1 setup 1.
ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
ata1.00: configured for UDMA/25
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SP1654N  BV10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7
sd 0:0:0:0: [sda] Attached SCSI disk

> I'm not aware of anyone having done any PPC ports yet, although a couple
> of people have asked and said they would look at it. Currently our
> coverage is incomplete for some embedded and obscure platforms, of which
> the macintrash is probably the least 'obscure'.
>
> Alan

Marc

-- 
	"It is a noble cause that we defend and not particular interests."
		 Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
