Return-Path: <linux-kernel-owner+w=401wt.eu-S1764871AbXFFOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764871AbXFFOa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbXFFOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:30:19 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45832 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXFFOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:30:18 -0400
Date: Wed, 06 Jun 2007 08:29:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Bad behaviour after hdparm -M  128
In-reply-to: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no>
To: linux-kernel@vger.kernel.org
Message-id: <4666C4B9.8060408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> Hi,
> 
> I tried to enable acoustic management on my SATA drive, because
> hdparm -I reported a recommended value of 128, and a current value
> of 0 (off).
> 
> I did this:
> 
> $ sudo hdparm -M 128 /dev/sda
> /dev/sda:
>  setting acoustic management to 128
>  HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
>  acoustic      = not supported
> 
> It apperently failed, no big deal.
> 
> However, I had these messages in the kernel log, and they don't look
> really harmless to me:
> 
> ata3.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata3.01: cmd ef/42:80:00:00:00/00:00:00:00:00/50 tag 0 cdb 0x0 data 0 
>          res 51/04:80:00:00:00/00:00:00:00:00/50 Emask 0x1 (device error)
> ata3.01: configured for UDMA/133
> ata3: EH complete
> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> Is this expected behaviour?
> 
> I used kernel 2.6.21 with the libata PIIX SATA driver and a
> Seagate ST98823AS drive.

Yes, that's expected if the drive rejects the command.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

