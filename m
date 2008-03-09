Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYCIXNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYCIXNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYCIXNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:13:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYCIXNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:13:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on pata_ali
Date: Mon, 10 Mar 2008 00:12:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803082246.47987.rjw@sisk.pl> <20080309073824.902DC82CF2E@smtp04.mtu.ru>
In-Reply-To: <20080309073824.902DC82CF2E@smtp04.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803100012.27520.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of March 2008, Andrey Borzenkov wrote:
> Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > On one of my test boxes I'm unable to do just about anything with audio
> > CDs using the current -git (2.6.24 is fine in that respect on the same
> > box).
> > 
> > When an audio CD is inserted into the drive, I get the following errors in
> > dmesg and nothing more happens (quite obviously):
> > 
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
> >          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
> >          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> > ata1.00: status: { DRDY }
> > ata1: soft resetting link
> > ata1.00: configured for UDMA/33
> > ata1: EH complete
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
> >          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
> >          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> > ata1.00: status: { DRDY }
> > ata1: port is slow to respond, please be patient (Status 0x80)
> > ata1: device not ready (errno=-16), forcing hardreset
> > ata1: soft resetting link
> > ata1.00: qc timeout (cmd 0xa1)
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > ata1.00: revalidation failed (errno=-5)
> > ata1: failed to recover some devices, retrying in 5 secs
> > ata1: port is slow to respond, please be patient (Status 0x80)
> > ata1: device not ready (errno=-16), forcing hardreset
> > ata1: soft resetting link
> > ata1.00: qc timeout (cmd 0xa1)
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > ata1.00: revalidation failed (errno=-5)
> > ata1: failed to recover some devices, retrying in 5 secs
> > ata1: port is slow to respond, please be patient (Status 0x80)
> > ata1: device not ready (errno=-16), forcing hardreset
> > ata1: soft resetting link
> > ata1.00: qc timeout (cmd 0xa1)
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > ata1.00: revalidation failed (errno=-5)
> > ata1.00: disabled
> > 
> > where ata1 is:
> > 
> > scsi0 : pata_ali
> > scsi1 : pata_ali
> 
> Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
> all. Have you tried to disable ATAPI DMA (libata.dma=1)?

Data CDs seem to work fine here.

Thanks,
Rafael
